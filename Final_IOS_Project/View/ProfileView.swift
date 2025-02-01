import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            //close button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 30)
                        .foregroundColor(.white)
                        .opacity(0.9)
                }
                .padding()

                Spacer()
            }

            //profile section
            VStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .opacity(0.8)

                Text("Esho Caleb")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("caleb@example.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 10)

            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.horizontal)

            // favorite movies section
            Text("Favorite Movies ❤️")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 2)

            if viewModel.favoriteMovies.isEmpty {
                Text("No favorite movies yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(viewModel.favoriteMovies) { movie in
                            HStack {
                                // display movie image from Local or API
                                if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Image(systemName: "film")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray.opacity(0.7))
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                //movie title
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(movie.title)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("⭐️ \(movie.rating)/5")
                                        .font(.subheadline)
                                        .foregroundColor(.yellow)
                                }

                                Spacer()

                                // unfavorite button
                                Button(action: {
                                    viewModel.toggleFavorite(movie: movie)
                                }) {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(12)
                            .shadow(color: Color.white.opacity(0.1), radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
