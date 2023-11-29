//
//  SearchBarView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let placeholder: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image("searchIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField(placeholder, text: $searchText)
                .font(.system(size: 14))
                .padding(.vertical, 8)
            
            Button(action: action) {
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
    }
}
