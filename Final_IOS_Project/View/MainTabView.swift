import SwiftUI

struct HomeView: View {
    @State private var navigateToMovies = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                // Netflix logo
                Image("netflix_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .padding()

                Text("Welcome to Filmify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                //button to navigate to MovieList
                Button(action: {
                    navigateToMovies = true
                }) {
                    Text("Explore Movies")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding()

                Spacer()
            }
            .background(Color.black)
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $navigateToMovies) {
                MovieListView(viewModel: MovieViewModel())
            }
        }
    }
}

#Preview {
    HomeView()
}
