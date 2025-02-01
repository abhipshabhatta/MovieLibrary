import SwiftUI

struct AddMovieView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var releaseYear: String = ""
    @State private var rating: Int = 0
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                //back Button + Title
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.leading)

                    Spacer()

                    Text("Add New Movie")
                        .font(.title2)
                        .fontWeight(.bold)
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
                .padding(.top)

                ScrollView {
                    VStack(spacing: 15) {
                        //movie image preview
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.9))
                                .frame(height: 220)
                                .cornerRadius(12)
                                .overlay(
                                    Text("No Image Selected")
                                        .foregroundColor(.white.opacity(0.9))
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
                            .background(Color.gray.opacity(0.9))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        // movie info
                        VStack(alignment: .leading, spacing: 10) {
                            TextField("Movie Title", text: $title)
                                .padding()
                                .background(Color.gray.opacity(0.9))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            
                            TextField("Release Year", text: $releaseYear)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.gray.opacity(0.9))
                                .cornerRadius(8)
                                .foregroundColor(.white)

                            HStack {
                                Text("⭐️ \(rating) /5")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Spacer()
                                Stepper("", value: $rating, in: 0...5)
                                    .labelsHidden()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.9))
                            .cornerRadius(8)

                            TextField("Movie Description", text: $description)
                                .padding()
                                .background(Color.gray.opacity(0.9))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)

                        //floating Save Button
                        Button(action: {
                            if let year = Int(releaseYear) {
                                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

                                viewModel.addMovie(
                                    title: title,
                                    releaseYear: year,
                                    rating: rating,
                                    description: description,
                                    imageData: imageData,
                                    posterPath: nil
                                )
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Save Movie")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(title.isEmpty || releaseYear.isEmpty ? Color.gray : Color.red)
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
