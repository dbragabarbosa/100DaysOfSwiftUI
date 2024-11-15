//
//  UserWithDetailView.swift
//  ProjectDay60
//
//  Created by Daniel Braga Barbosa on 10/11/24.
//

import SwiftUI
import SwiftData

struct UserWithDetailView: View
{
    var user: UserInfo
    
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
            
            ForEach(user.friends)
            { friend in
                Text(friend.name)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(user.name)
    }
}

//#Preview
//{
//    let friendsTest1: FriendInfo = FriendInfo(id: "2", name: "Jose")
//    let friendsTest2: FriendInfo = FriendInfo(id: "3", name: "Maria")
//    
//    let userTest: UserInfo = UserInfo(id: "1", isActive: true, name: "Daniel", age: 23, company: "Inter", email: "dbragabarbosa@gmail.com", address: "BH", about: "Galo", registered: "10/11/2024", tags: ["um", "dois"], friends: [friendsTest1, friendsTest2])
//    
//    UserWithDetailView(user: userTest)
    
    
    
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: UserInfo.self, configurations: config)
//        
//        let friendsTest1: FriendInfo = FriendInfo(id: "2", name: "Jose")
//        let friendsTest2: FriendInfo = FriendInfo(id: "3", name: "Maria")
//        
//        let userTest: UserInfo = UserInfo(id: "1", isActive: true, name: "Daniel", age: 23, company: "Inter", email: "dbragabarbosa@gmail.com", address: "BH", about: "Galo", registered: "10/11/2024", tags: ["um", "dois"], friends: [friendsTest1, friendsTest2])
//
//        return UserWithDetailView(user: userTest)
//            .modelContainer(container)
//    } catch {
//        return Text("Failed to create preview: \(error.localizedDescription)")
//    }
//}
