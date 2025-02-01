import SwiftUI

struct EditMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    var movie: Movie

    @State private var title: String
    @State private var releaseYear: String
    @State private var rating: Int
    @State private var description: String
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: MovieViewModel, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        _title = State(initialValue: movie.title)
        _releaseYear = State(initialValue: "\(movie.releaseYear)")
        _rating = State(initialValue: movie.rating)
        _description = State(initialValue: movie.description)

        // Load existing image if available
        if let imageData = movie.imageData {
            _selectedImage = State(initialValue: UIImage(data: imageData))
        }
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                //navigation header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Edit Movie")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 15) {
                        //movie image preview
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        } else if let imageData = movie.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 220)
                                .cornerRadius(12)
                                .overlay(
                                    Text("No Image Selected")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.subheadline)
                                )
                        }

                        //change image button
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text(selectedImage == nil ? "Select Image" : "Change Image")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        //Edit Form
                        VStack(alignment: .leading, spacing: 12) {
                            CustomTextField(placeholder: "Movie Title", text: $title)
                            CustomTextField(placeholder: "Release Year", text: $releaseYear, keyboardType: .numberPad)

                            //Ratings
                            HStack {
                                Text("⭐️ \(rating) /5")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Spacer()
                                Stepper("", value: $rating, in: 0...5)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                            CustomTextField(placeholder: "Movie Description", text: $description)
                        }
                        .padding(.horizontal)

                        //Save Button
                        Button(action: {
                            if let year = Int(releaseYear) {
                                let imageDataToSave = selectedImage?.jpegData(compressionQuality: 0.8) ?? movie.imageData
                                viewModel.updateMovie(
                                    movie: movie,
                                    newTitle: title,
                                    newReleaseYear: year,
                                    newRating: rating,
                                    newDescription: description,
                                    newImageData: imageDataToSave
                                )
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Save Changes")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .disabled(title.isEmpty || releaseYear.isEmpty)
                    }
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
    }
}
