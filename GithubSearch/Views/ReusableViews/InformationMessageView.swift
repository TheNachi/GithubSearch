//
//  InformationMessageView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/29/23.
//

import SwiftUI

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
