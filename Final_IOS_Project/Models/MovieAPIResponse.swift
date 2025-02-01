import Foundation

struct MovieAPIResponse: Codable {
    let results: [APIMovie]
}

struct APIMovie: Codable {
    let title: String
    let release_date: String
    let overview: String
    let poster_path: String?
}
