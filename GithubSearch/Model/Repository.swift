//
//  Repository.swift
//  GithubSearch
//
//  Created by Munachimso Ugorji on 11/26/23.
//

import Foundation

struct Repository: Codable, Identifiable {
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    let owner: Owner?
    let `private`: Bool
    let html_url: String
    let description: String?
    let fork: Bool
    let url: String
    let created_at: String
    let updated_at: String
    let pushed_at: String
    let homepage: String?
    let size: Int
    let stargazers_count: Int
    let watchers_count: Int
    let language: String?
    let forks_count: Int
    let open_issues_count: Int
    let master_branch: String?
    let default_branch: String
    let score: Double?
    let forks_url: String
    let keys_url: String
    let collaborators_url: String
    let teams_url: String
    let hooks_url: String
    let issue_events_url: String
    let events_url: String
    let assignees_url: String
    let branches_url: String
    let tags_url: String
    let blobs_url: String
    let git_tags_url: String
    let git_refs_url: String
    let trees_url: String
    let statuses_url: String
    let languages_url: String
    let stargazers_url: String
    let contributors_url: String
    let subscribers_url: String
    let subscription_url: String
    let commits_url: String
    let git_commits_url: String
    let comments_url: String
    let issue_comment_url: String
    let contents_url: String
    let compare_url: String
    let merges_url: String
    let archive_url: String
    let downloads_url: String
    let issues_url: String
    let pulls_url: String
    let milestones_url: String
    let notifications_url: String
    let labels_url: String
    let releases_url: String
    let deployments_url: String
    let git_url: String
    let ssh_url: String
    let clone_url: String
    let svn_url: String
    let forks: Int
    let open_issues: Int
    let watchers: Int
    let topics: [String]?
    let mirror_url: String?
    let has_issues: Bool
    let has_projects: Bool
    let has_pages: Bool
    let has_wiki: Bool
    let has_downloads: Bool
    let has_discussions: Bool
    let archived: Bool
    let disabled: Bool
    let visibility: String
    let license: License?
    let permissions: Permissions?
    let text_matches: [SearchResultTextMatches]?
    let temp_clone_token: String?
    let allow_merge_commit: Bool?
    let allow_squash_merge: Bool?
    let allow_rebase_merge: Bool?
    let allow_auto_merge: Bool?
    let delete_branch_on_merge: Bool?
    let allow_forking: Bool?
    let is_template: Bool?
    let web_commit_signoff_required: Bool?
    let starred_at: String?
}

struct Owner: Codable {
    let name: String?
    let email: String?
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: String
    let gravatar_id: String?
    let url: String
    let html_url: String
    let followers_url: String
    let following_url: String
    let gists_url: String
    let starred_url: String
    let subscriptions_url: String
    let organizations_url: String
    let repos_url: String
    let events_url: String
    let received_events_url: String
    let type: String
    let site_admin: Bool
    let starred_at: String?
}

struct License: Codable {
    let key: String
    let name: String
    let url: String?
    let spdx_id: String?
    let node_id: String
    let html_url: String?
}

struct Permissions: Codable {
    let admin: Bool
    let maintain: Bool
    let push: Bool
    let triage: Bool
    let pull: Bool
}

struct SearchResultTextMatches: Codable {
    let object_url: String
    let object_type: String?
    let property: String
    let fragment: String
    let matches: [Match]
}

struct Match: Codable {
    let text: String
    let indices: [Int]
}

