//
//  RepositoryCell.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

struct RepositoryCell: View {
    var repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                
                RepositoryNameView(repositoryName: repository.full_name)
                
                
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
            
            if let lastUpdated = Date().formattedDateString(from: repository.updated_at) {
                Text("Updated \(lastUpdated) ago")
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
