//
//  RepositoryNameView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

struct RepositoryNameView: View {
    var repositoryName: String
    
    var body: some View {
        let parts = repositoryName.components(separatedBy: "/")
        if parts.count == 2 {
            return AnyView(
                HStack {
                    Text(parts[0])
                        .font(.system(size: 12))
                        .foregroundColor(.purple)
                        .lineLimit(1)
                    Text("/")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, -6)
                    Text(parts[1])
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.leading, -9)
                }
            )
        } else {
            return AnyView(
                Text(repositoryName)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
                    .lineLimit(1)
            )
        }
    }
}

