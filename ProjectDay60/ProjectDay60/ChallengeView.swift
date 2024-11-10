//
//  ChallengeView.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 10/11/24.
//

import SwiftUI

struct UserInfo: Codable, Identifiable
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
}

struct FriendInfo: Codable, Identifiable
{
    var id: String
    var name: String
}

struct ChallengeView: View
{
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
