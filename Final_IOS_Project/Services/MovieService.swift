
import Foundation

class MovieService {
    private let key = "movies_key"

    func saveMovies(_ movies: [Movie]) {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadMovies() -> [Movie] {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decodedMovies
        }
        return []
    }
}
