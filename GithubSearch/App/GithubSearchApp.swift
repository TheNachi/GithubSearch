//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import SwiftUI

@main
struct GithubSearchApp: App {
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            ContentView(selectedTab: $selectedTab)
        }
    }
}
