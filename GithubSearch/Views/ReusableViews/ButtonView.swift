//
//  ButtonView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

struct ButtonView: View {
    let imageName: String
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Image(imageName)
                    .foregroundColor(.black)
                    .padding(.top, 15)
                    
                Spacer()
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
            }
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 118)
            .background(backgroundColor)
            .border(Color(hex: 0xD9D9D9), width: 0.4)
            .cornerRadius(8)
        }
    }
}
