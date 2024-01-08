//
//  UserResultsView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct UserResultsView: View {
    private let sortedUsers: [User]
    
    init(users: [User]) {
        self.sortedUsers = users.sorted(by: { $0.login.username < $1.login.username })
    }
    
    var body: some View {
        List(sortedUsers) { user in
            NavigationLink {
                UserView(user: user)
            } label: {
                AsyncImageCard(
                    title: user.login.username,
                    subtitle: "\(user.name.first) \(user.name.last)",
                    imageURL: user.photoURL
                )
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        UserResultsView(users: [.paulina])
    }
}
