//
//  ContentView.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 09/11/24.
//

import SwiftUI

struct User: Codable, Identifiable
{
    var id: String
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
}

struct Friend: Codable, Identifiable
{
    var id: String
    var name: String
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
            
            // Decodifica os dados JSON
            if let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
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
                viewModel.loadData()
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
}
