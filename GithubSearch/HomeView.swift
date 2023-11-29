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
                        Button(action: {
                            selectedTab = 2
                        }) {
                            VStack(alignment: .leading) {
                                Image("userIcon")
                                    .foregroundColor(.black)
                                    .padding(.top, 15)
                                    
                                Spacer()
                                Text("Users")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                            }
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 118)
                            .background(Color(hex: 0xECF5F8))
                            .border(Color(hex: 0xD9D9D9), width: 0.4)
                            .cornerRadius(8)
                        }

                        Button(action: {
                            selectedTab = 1
                        }) {
                            VStack(alignment: .leading) {
                                Image("repositoriesIcon")
                                    .foregroundColor(.black)
                                    .padding(.top, 15)
                                
                                Spacer()
                                Text("Repositories")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                            }
                            .padding(.leading, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 118)
                            .background(Color(hex: 0xF6EDF8))
                            .border(Color(hex: 0xD9D9D9), width: 0.4)
                            .cornerRadius(8)
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

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double((hex >> 0) & 0xff) / 255,
            opacity: alpha
        )
    }
}
