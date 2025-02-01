import Foundation
import CoreData
import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favoriteMovies: [Movie] = []
    @Published var searchText: String = ""


    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchMoviesFromCoreData()
        fetchMoviesFromAPI() //load API movies on startup
    }
    // search for movies
        var filteredMovies: [Movie] {
            if searchText.isEmpty {
                return movies
            } else {
                return movies.filter { movie in
                    movie.title.lowercased().hasPrefix(searchText.lowercased()) ||
                    "\(movie.releaseYear)".hasPrefix(searchText) //search by year
                }
            }
        }

    // fetch movies from API
    func fetchMoviesFromAPI() {
        let apiKey = "8b4e9bbc890441087b185ea624b1648f"
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"

        guard let url = URL(string: urlString) else {
            print("Invalid API URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Request Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from API")
                return
            }

            do {
                let result = try JSONDecoder().decode(MovieAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    for apiMovie in result.results {
                        let releaseYear = Int(apiMovie.release_date.prefix(4)) ?? 0

                        let movie = Movie(
                            title: apiMovie.title,
                            releaseYear: releaseYear,
                            rating: Int.random(in: 1...5),
                            description: apiMovie.overview,
                            imageData: nil,
                            posterPath: apiMovie.poster_path
                        )

                        self.movies.append(movie)
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")
                }
            }
        }.resume()
    }

    // fetch movies from Core Data
    func fetchMoviesFromCoreData() {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try context.fetch(request)
            let coreDataMovies = movieEntities.map { movie in
                Movie(
                    id: movie.id ?? UUID(),
                    title: movie.title ?? "Unknown",
                    releaseYear: Int(movie.releaseYear),
                    rating: Int(movie.rating),
                    description: movie.movieDescription ?? "No description",
                    imageData: movie.imageData,
                    isFavorite: movie.isFavorite
                )
            }

            DispatchQueue.main.async {
                self.movies = coreDataMovies + self.movies //merge API movies with added movies
                self.favoriteMovies = self.movies.filter { $0.isFavorite }
            }
        } catch {
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
    }


    func addMovie(title: String, releaseYear: Int, rating: Int, description: String, imageData: Data?, posterPath: String?) {
        let newMovie = MovieEntity(context: context)
        newMovie.id = UUID()
        newMovie.title = title
        newMovie.releaseYear = Int16(releaseYear)
        newMovie.rating = Int16(rating)
        newMovie.movieDescription = description
        newMovie.imageData = imageData
        newMovie.posterPath = posterPath //store API movie poster path in Core Data

        saveContext()
        fetchMoviesFromCoreData()
    }

    // update movie
    func updateMovie(movie: Movie, newTitle: String, newReleaseYear: Int, newRating: Int, newDescription: String, newImageData: Data?) {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", movie.id as CVarArg)

        do {
            let movieEntities = try context.fetch(request)
            if let movieEntity = movieEntities.first {
                movieEntity.title = newTitle
                movieEntity.releaseYear = Int16(newReleaseYear)
                movieEntity.rating = Int16(newRating)
                movieEntity.movieDescription = newDescription
                movieEntity.imageData = newImageData

                saveContext()
                fetchMoviesFromCoreData()
            }
        } catch {
            print("Failed to update movie: \(error.localizedDescription)")
        }
    }

    // delete movie
    func deleteMovie(movie: Movie) {
            DispatchQueue.main.async {
                self.movies.removeAll { $0.id == movie.id } //deletes selected movie
            }

            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", movie.id as CVarArg)

            do {
                let movieEntities = try context.fetch(request)
                if let movieEntity = movieEntities.first {
                    context.delete(movieEntity)
                    saveContext()
                    DispatchQueue.main.async {
                        self.fetchMoviesFromCoreData()
                    }
                }
            } catch {
                print("Failed to delete movie: \(error.localizedDescription)")
            }
        }
    
    // toggle favorite
    func toggleFavorite(movie: Movie) {
        DispatchQueue.main.async {
            if let index = self.movies.firstIndex(where: { $0.id == movie.id }) {
                self.movies[index].isFavorite.toggle()
                self.favoriteMovies = self.movies.filter { $0.isFavorite }
            }
        }

        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", movie.id as CVarArg)

        do {
            let movieEntities = try context.fetch(request)
            if let movieEntity = movieEntities.first {
                movieEntity.isFavorite.toggle()
                saveContext()
                DispatchQueue.main.async {
                    self.fetchMoviesFromCoreData()
                }
            }
        } catch {
            print("Failed to toggle favorite: \(error.localizedDescription)")
        }
    }

    // Save context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save movie: \(error.localizedDescription)")
        }
    }
}
