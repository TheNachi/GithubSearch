//
//  User.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let login: String
    let node_id: String
    let avatar_url: String
    let gravatar_id: String?
    let url: String
    let html_url: String
    let followers_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let received_events_url: String
    let type: String
    let score: Double?
    let following_url: String
    let gists_url: String
    let starred_url: String
    let events_url: String
    let public_repos: Int?
    let public_gists: Int?
    let followers: Int?
    let following: Int?
    let created_at: String?
    let updated_at: String?
    let name: String?
    let bio: String?
    let email: String?
    let location: String?
    let site_admin: Bool
    let hireable: Bool?
    let text_matches: [TextMatch]?
    let blog: String?
    let company: String?
    let suspended_at: String?
}

struct TextMatch: Codable {
    let object_url: String
    let object_type: String?
    let property: String
    let fragment: String
    let matches: [Match]
}
