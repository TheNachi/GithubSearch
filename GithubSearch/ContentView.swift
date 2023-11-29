//
//  ContentView.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect(x: 0, y: 0, width: UIScreen.main.scale, height: 8),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray6
                
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image

        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            Color.black
                .shadow(color: .black, radius: 5, x: 0, y: 5)
            
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Home", image: selectedTab == 0 ? "homeSelected" : "homeUnselected")
                    }
                    .tag(0)
                
                RepositoryView()
                    .tabItem {
                        Label("Repositories", image: selectedTab == 1 ? "repositoriesSelected" : "repositoriesUnselected")
                    }
                    .tag(1)
                
                UsersView()
                    .tabItem {
                        Label("Users", image: selectedTab == 2 ? "userSelected" : "userUnselected")
                    }
                    .tag(2)
            }
            .accentColor(.black)
        }
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
