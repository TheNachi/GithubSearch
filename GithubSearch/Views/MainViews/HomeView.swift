//
//  HomeView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            HStack {
                VStack(alignment: .leading) {
                    Text("Home")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)

                    HStack(spacing: 20) {
                        ButtonView(imageName: "userIcon",
                                   title: "Users",
                                   backgroundColor: Color(hex: 0xECF5F8)) {
                            selectedTab = 2
                        }

                        ButtonView(imageName: "repositoriesIcon",
                                   title: "Repositories",
                                   backgroundColor: Color(hex: 0xF6EDF8)) {
                            selectedTab = 1
                        }
                    }
                    .padding(.top, 30)

                    Spacer()
                }
                .padding(20)
                Spacer()
            }
            .navigationTitle("Home")
            .navigationBarHidden(true)
        }
    }
}
