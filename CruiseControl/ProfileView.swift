import CoreTransferable
import PhotosUI
import SwiftUI

struct ProfilePictureContent: View {
  let imageState: ProfileViewModel.ImageState

  var body: some View {
    switch imageState {

    case .empty:
      Image(systemName: "person.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)

    case .failure(_):
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)

    case .loading(_):
      ProgressView()

    case .success(let image):
      image.resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 100, height: 100)
        .clipped()
    }
  }
}

struct ProfilePicture: View {
  let imageState: ProfileViewModel.ImageState

  var body: some View {
    ProfilePictureContent(imageState: imageState)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .frame(width: 100, height: 100)
      .background {
        RoundedRectangle(cornerRadius: 8)
          .fill(.mint)
      }
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
        Image(systemName: "pencil.circle.fill").symbolRenderingMode(.multicolor).font(
          .system(size: 30)
        ).foregroundColor(.blue)
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
            EditableProfilePicture(viewModel: viewModel)
            Spacer()
          }
        }

        Section {
          TextField("First Name", text: $viewModel.firstName, prompt: Text("First Name"))
          TextField("Last Name", text: $viewModel.lastName, prompt: Text("Last Name"))
        }

        Section {
          TextField(
            "Biography", text: $viewModel.biography, prompt: Text("Biography"), axis: .vertical
          ).lineLimit(3, reservesSpace: true)
        }

        Button {
          let userProfile: UserProfile = UserProfile(
            firstName: viewModel.firstName,
            lastName: viewModel.lastName,
            biography: viewModel.biography)
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
    }
  }
}
