//
//  ChallengeView.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 10/11/24.
//

import SwiftUI
import SwiftData

@Model
class UserInfo: Codable, Identifiable
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
    var friends: [FriendInfo]
    
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
    
    required init(from decoder: any Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.isActive = try container.decode(Bool.self, forKey: .isActive)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decode(Int.self, forKey: .age)
        self.company = try container.decode(String.self, forKey: .company)
        self.email = try container.decode(String.self, forKey: .email)
        self.address = try container.decode(String.self, forKey: .address)
        self.about = try container.decode(String.self, forKey: .about)
        self.registered = try container.decode(String.self, forKey: .registered)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.friends = try container.decode([FriendInfo].self, forKey: .friends)
    }
    
    func encode(to encoder: any Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.isActive, forKey: .isActive)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.company, forKey: .company)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.address, forKey: .address)
        try container.encode(self.about, forKey: .about)
        try container.encode(self.registered, forKey: .registered)
        try container.encode(self.tags, forKey: .tags)
        try container.encode(self.friends, forKey: .friends)
    }
}

@Model
class FriendInfo: Codable, Identifiable
{
    var id: String
    var name: String
    
    enum CodingKeys: CodingKey
    {
        case id
        case name
    }
    
    init(id: String, name: String)
    {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: any Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
}

struct ChallengeView: View
{
    @Environment(\.modelContext) var modelContext
    @State var users: [UserInfo] = []
    
    var body: some View
    {
        NavigationStack
        {
            List(users)
            { user in
                NavigationLink(destination: UserWithDetailView(user: user))
                {
                    VStack(alignment: .leading)
                    {
                        Text(user.name)
                            .font(.headline)
                        Text(user.isActive ? "Ativo" : "Inativo")
                            .foregroundStyle(user.isActive ? .green : .red)
                    }
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Usuários")
        }
    }
    
    func loadData() async
    {
        if !users.isEmpty
        {
            return
        }
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else { return }
        
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([UserInfo].self, from: data)
            {
                self.users = decodedResponse
                
                for response in decodedResponse
                {
                    modelContext.insert(response)
                }
            }
            
        } catch {
            print("Invalid data")
        }
    }
    
}

#Preview
{
    ChallengeView()
}
