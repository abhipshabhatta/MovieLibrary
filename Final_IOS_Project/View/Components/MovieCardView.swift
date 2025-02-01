import SwiftUI

struct MovieCardView: View {
    var movie: Movie

    var body: some View {
        VStack {
            if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .cornerRadius(10)
            } else if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "film")
                        .resizable()
                        .frame(height: 180)
                        .background(Color.gray.opacity(0.3))
                }
                .frame(height: 180)
                .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(height: 180)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }

            Text(movie.title)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
