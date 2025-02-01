import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var showAddMovieView = false
    @State private var showProfileView = false
    @State private var searchText = ""
    @State private var editMovie: Movie?

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    //search
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return viewModel.movies
        } else {
            return viewModel.movies.filter { movie in
                movie.title.lowercased().hasPrefix(searchText.lowercased()) ||
                "\(movie.releaseYear)".hasPrefix(searchText) //search movies by year
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        //Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search by Title or Year", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        //header with profileButton
                        HStack {
                            Text("Trending Movies 🎬")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            Button(action: {
                                showProfileView = true
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            .padding(.trailing, 20)
                        }
                        
                        //movie Grid
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(filteredMovies, id: \.id) { movie in //ensure unique ID
                                ZStack(alignment: .topTrailing) {
                                    MovieCardView(movie: movie)
                                        .onTapGesture {
                                            editMovie = movie
                                        }
                                    
                                    //favorite Button
                                    Button(action: {
                                        withAnimation {
                                            viewModel.toggleFavorite(movie: movie)
                                        }
                                    }) {
                                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(movie.isFavorite ? .red : .white)
                                            .shadow(radius: 5)
                                    }
                                    .padding(8)
                                    .offset(x: -30, y: 0)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    //delete button
                                    Button(action: {
                                        withAnimation {
                                            viewModel.deleteMovie(movie: movie)
                                        }
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.white)
                                            .shadow(radius: 5)
                                    }
                                    .padding(8)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
                .sheet(isPresented: $showAddMovieView) {
                    AddMovieView(viewModel: viewModel)
                }
                .sheet(item: $editMovie) { movie in
                    EditMovieView(viewModel: viewModel, movie: movie) //shows editPage on tap
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(viewModel: viewModel)
                }
                
                //floating add movieButton
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddMovieView = true
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Movie")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
