//
//  UserDetailView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/28/23.
//

import SwiftUI


struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var user: User?
    @State private var repositories: [Repository] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                if let ownerAvatarURL = user?.avatar_url, let url = URL(string: ownerAvatarURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                        case .empty:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
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
                
                VStack(alignment: .leading) {
                    Text(user?.name ?? "")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Text(user?.login ?? "")
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text(user?.bio ?? "")
                .font(.system(size: 12))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                Image("locationIcon")
                    .frame(width: 10, height: 10)
                Text(user?.location ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                Image("linkIcon")
                    .frame(width: 10, height: 10)
                Text(user?.blog ?? "")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)
            
            HStack(spacing: 6) {
                Image("peopleIcon")
                    .frame(width: 10, height: 10)
                Text("\(user?.followers ?? 0) followers   .")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                Text("\(user?.following ?? 0) following")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
            
            Text("Repositories  \(repositories.count)")
                .font(.system(size: 10))
                .fontWeight(.semibold)
            
            Divider()
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(repositories, id: \.id) { repo in
                        RepositoryCell(repository: repo)
                        
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .padding(.horizontal, 20)
        .onAppear {
            // Load repositories when the view appears
            if let reposURL = user?.repos_url {
                loadRepositories(url: reposURL)
            }
        }
        
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Users")
            }
        }
    }
    
    private func loadRepositories(url: String) {
        isLoading = true
        GitHubAPIManager.shared.getRepositories(url: url) { result in
            switch result {
            case .success(let repos):
                self.repositories = repos
            case .failure(let error):
                print("Error loading repositories: \(error)")
            }
            isLoading = false
        }
    }
}
