//
//  UserCell.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

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
