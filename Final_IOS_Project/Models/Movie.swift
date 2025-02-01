import Foundation
import SwiftUI

struct Movie: Identifiable, Codable {
    var id = UUID()
    var title: String
    var releaseYear: Int
    var rating: Int
    var description: String
    var imageURL: String?  //for API movies
    var imageData: Data?  //for locally added movies
    var posterPath: String? //for API movie posters
    var isFavorite: Bool = false //new favorite property

}
