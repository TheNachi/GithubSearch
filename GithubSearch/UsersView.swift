//
//  UserView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct UsersView: View {
    @State private var username: String = ""
    @State private var users: [User] = []
    @State private var isLoading: Bool = false
    @State private var selectedUser: User?
    @State private var isUserDetailActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Text("Users")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                    
                    HStack {
                        Image("searchIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Search for users...", text: $username)
                            .font(.system(size: 14))
                            .padding(.vertical, 8)
                        
                        Button(action: findUsers) {
                            Text("Search")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.black))
                        }
                    }
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
                    
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else {
                        ScrollView(showsIndicators: false) {
                            ForEach(users, id: \.id) { user in
                                UserCell(user: user)
                                    .onTapGesture {
                                        selectedUser = user
                                        getUserDetails()
                                    }
                            }
                        }
                        .background(
                            NavigationLink(
                                destination: UserDetailView(user: selectedUser),
                                isActive: $isUserDetailActive
                            ) {
                                EmptyView()
                            }
                                .hidden() // Hide the default navigation link
                        )
                    }
                }
                
                if users.isEmpty && !isLoading {
                    InformationMessageView(imageName: "searchImage", message: "Search Github for users...")
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func findUsers() {
        GitHubAPIManager.shared.searchUsers(query: username) { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print("Error searching users: \(error)")
            }
        }
    }
    
    private func getUserDetails() {
        if let url = URL(string: selectedUser?.url ?? "") {
            GitHubAPIManager.shared.getUserDetails(url: url) { result in
                switch result {
                case .success(let user):
                    selectedUser = user
                    isUserDetailActive = true
                case .failure(let error):
                    print("Error fetching user details: \(error)")
                }
            }
        }
    }
}


struct UserCell: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                if let url = URL(string: user.avatar_url) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        case .failure(_):
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    EmptyView()
                }
                
                Text(user.login)
                    .font(.system(size: 12))
                    .lineLimit(1)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
    }
}

