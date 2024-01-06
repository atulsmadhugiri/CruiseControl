import CoreTransferable
import PhotosUI
import SwiftUI

struct ProfilePictureContent: View {
  let imageState: ImageState

  var body: some View {

    switch imageState {
    case .empty:
      Image(systemName: "person.fill")
        .font(.system(size: 100))

    case .failure(_):
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)

    case .loading(_):
      ProgressView()

    case .success(let image):
      if let uiImage = UIImage(data: image) {
        Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill).frame(
          width: 100, height: 100
        ).clipped()
      } else {
        ProgressView()
      }
    }

  }
}

struct ProfilePicture: View {
  let imageState: ImageState

  var body: some View {
    ProfilePictureContent(imageState: imageState)
      .frame(width: 100, height: 100)
      .cornerRadius(8)
  }
}

struct EditableProfilePicture: View {
  @ObservedObject var viewModel: ProfileViewModel

  var body: some View {
    ProfilePicture(imageState: viewModel.imageState).overlay(alignment: .bottomTrailing) {
      PhotosPicker(
        selection: $viewModel.imageSelection, matching: .all(of: [.images, .not(.livePhotos)]),
        photoLibrary: .shared()
      ) {
        if viewModel.hasUserFetchBeenAttempted {
          Image(systemName: "pencil.circle.fill")
            .symbolRenderingMode(.multicolor)
            .font(.system(size: 30))
            .foregroundColor(.blue)
        }
      }.buttonStyle(.borderless)
    }
  }
}

struct ProfileView: View {
  @StateObject var viewModel = ProfileViewModel()

  var body: some View {
    VStack {
      Form {
        Section {
          HStack {
            Spacer()
            EditableProfilePicture(viewModel: viewModel).redacted(
              reason: !viewModel.hasUserFetchBeenAttempted ? .placeholder : [])
            Spacer()
          }
        }

        Section {
          TextField("First Name", text: $viewModel.firstName, prompt: Text("First Name"))
          TextField("Last Name", text: $viewModel.lastName, prompt: Text("Last Name"))
        }.redacted(reason: !viewModel.hasUserFetchBeenAttempted ? .placeholder : [])

        Section {
          TextField(
            "Biography", text: $viewModel.biography, prompt: Text("Biography"), axis: .vertical
          ).lineLimit(3, reservesSpace: true)
        }.redacted(reason: !viewModel.hasUserFetchBeenAttempted ? .placeholder : [])

        Button {
          var imageURL: URL? = nil
          switch viewModel.imageState {
          case .empty:
            imageURL = nil

          case .loading(_):
            imageURL = nil

          case .success(let data):
            let uiImage = UIImage(data: data)
            if let jpegData = uiImage?.jpegData(compressionQuality: 1.0) {
              let tempFilePath = NSTemporaryDirectory()
                .appending(UUID().uuidString)
                .appending(".jpg")

              let tempFileURL = URL(fileURLWithPath: tempFilePath)
              do {
                try jpegData.write(to: tempFileURL)
                imageURL = tempFileURL
              } catch {
                print("Error writing image to disk: \(error.localizedDescription)")
              }
            }

          case .failure(_):
            imageURL = nil
          }

          let userProfile: UserProfile = UserProfile(
            firstName: viewModel.firstName,
            lastName: viewModel.lastName,
            biography: viewModel.biography,
            profilePicture: imageURL)
          Task {
            await userProfile.saveUserProfile()
          }
        } label: {
          Text("Update profile")
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .font(.title3)
        }.buttonStyle(.borderedProminent)
          .tint(.blue)
          .backgroundStyle(.blue)

      }
    }.onAppear {
      Task {
        await viewModel.fetchUserProfile()
      }
    }
  }
}
