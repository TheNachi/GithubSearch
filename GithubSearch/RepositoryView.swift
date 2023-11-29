//
//  RepositoryView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct RepositoryView: View {
    @State private var searchText: String = ""
    @State private var repositories: [Repository] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Repositories")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                
                HStack {
                    Image("searchIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("Search for repositories...", text: $searchText)
                        .font(.system(size: 14))
                        .padding(.vertical, 8)
                    
                    Button(action: searchRepositories) {
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
                        ForEach(repositories, id: \.id) { repo in
                            RepositoryCell(repository: repo)
                            
                        }
                    }
                }
                Spacer()
            }
            
            if repositories.isEmpty && !isLoading {
                InformationMessageView(imageName: "searchImage", message: "Search Github for repositories, issues and pull requests!")
            }
        }
        .padding()
        .navigationBarHidden(true)
    }
    
    private func searchRepositories() {
        isLoading = true
        GitHubAPIManager.shared.searchRepositories(query: searchText) { result in
            isLoading = false
            switch result {
            case .success(let repositories):
                self.repositories = repositories
            case .failure(let error):
                print("Error searching users: \(error)")
            }
        }
    }
}



struct InformationMessageView: View {
    var imageName: String
    var message: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 67)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
        }
    }
}


struct RepositoryCell: View {
    var repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 8) {
                if let ownerAvatarURL = repository.owner?.avatar_url, let url = URL(string: ownerAvatarURL) {
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
                
                Text(repository.full_name)
                    .font(.system(size: 12))
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .frame(width: 10, height: 10)
                    Text("\(repository.stargazers_count)")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                
                if let language = repository.language {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                    Text(language)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
            
            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 4).stroke(Color(hex: 0xD9D9D9), lineWidth: 1))
    }
}
