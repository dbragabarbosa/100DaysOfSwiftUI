//
//  ContentView.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 09/11/24.
//

import SwiftUI
import SwiftData

@Model
class User: Codable, Identifiable
{
    @Attribute(.unique) var id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
    
    enum CodingKeys: CodingKey
    {
        case id
        case isActive
        case name
        case age
        case company
        case email
        case address
        case about
        case registered
        case tags
        case friends
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
         id = try container.decode(String.self, forKey: .id)
         isActive = try container.decode(Bool.self, forKey: .isActive)
         name = try container.decode(String.self, forKey: .name)
         age = try container.decode(Int.self, forKey: .age)
         company = try container.decode(String.self, forKey: .company)
         email = try container.decode(String.self, forKey: .email)
         address = try container.decode(String.self, forKey: .address)
         about = try container.decode(String.self, forKey: .about)
         registered = try container.decode(String.self, forKey: .registered)
         tags = try container.decode([String].self, forKey: .tags)
         friends = try container.decode([Friend].self, forKey: .friends)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(company, forKey: .company)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(about, forKey: .about)
        try container.encode(registered, forKey: .registered)
        try container.encode(tags, forKey: .tags)
        try container.encode(friends, forKey: .friends)
    }
}

@Model
class Friend: Codable, Identifiable
{
    @Attribute(.unique) var id: String
    var name: String
    
    enum CodingKeys: CodingKey
    {
        case id
        case name
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

class UserViewModel: ObservableObject
{
    @Published var users: [User] = []
    
    func loadData() {
        // Verifica se a lista de usuários está vazia para evitar múltiplos fetches
        guard users.isEmpty else { return }
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Falha ao obter dados: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }
            
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    self.users = decodedUsers
                }
            } else {
                print("Falha ao decodificar JSON")
            }
        }.resume()
    }
    
    func loadDataWithSwiftData(context: ModelContext)
    {
        let fetchRequest = FetchDescriptor<User>()
        if let storedUsers = try? context.fetch(fetchRequest), !storedUsers.isEmpty
        {
            users = storedUsers
            return
        }
        
        // Caso não tenha dados locais, busca na API
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("URL inválida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else
            {
                print("Falha ao obter dados: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }
            
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: data)
            {
                DispatchQueue.main.async
                {
                    for user in decodedUsers
                    {
                        context.insert(user)
                    }
                    
                    self.users = decodedUsers
                }
            } else {
                print("Falha ao decodificar JSON")
            }
        }.resume()
    }
}

struct ContentView: View
{
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View
    {
        NavigationStack
        {
            List(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(user: user))
                {
                    VStack(alignment: .leading)
                    {
                        Text(user.name)
                            .font(.headline)
                        Text(user.isActive ? "Ativo" : "Inativo")
                            .foregroundColor(user.isActive ? .green : .red)
                    }
                }
            }
            .navigationTitle("Usuários")
            .onAppear {
//                viewModel.loadData()
                viewModel.loadDataWithSwiftData(context: modelContext)
            }
        }
    }
}

struct UserDetailView: View
{
    let user: User
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            Text("Nome: \(user.name)")
                .font(.title)
            Text("Idade: \(user.age)")
            Text("Empresa: \(user.company)")
            Text("Email: \(user.email)")
            Text("Endereço: \(user.address)")
            Text("Sobre: \(user.about)")
            
            Text("Amigos:")
                .font(.headline)
                .padding(.top, 10)
            
            ForEach(user.friends) { friend in
                Text(friend.name)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(user.name)
    }
}

#Preview
{
    ContentView()
        .modelContainer(for: [User.self, Friend.self])
}
