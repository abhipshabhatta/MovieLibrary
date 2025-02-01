import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                //display the movie image
                if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                } else if let imageURL = movie.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(10)
                        default:
                            Color.gray.frame(height: 300).cornerRadius(10)
                        }
                    }
                } else {
                    //placeholder if no image is available
                    Color.gray.frame(height: 300).cornerRadius(10)
                }

                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Text("Released: \(movie.releaseYear)")
                    .font(.subheadline)

                Text("⭐️ Rating: \(movie.rating)/5")
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Text(movie.description)
                    .font(.body)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Movie Details")
    }
}
