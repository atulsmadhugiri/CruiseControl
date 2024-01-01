import CoreTransferable
import PhotosUI
import SwiftUI

// Adapted from https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app
@MainActor
class ProfileViewModel: ObservableObject {
  @Published var firstName: String = ""
  @Published var lastName: String = ""
  @Published var biography: String = ""

  enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
  }

  @Published private(set) var imageState: ImageState = .empty

  enum TransferError: Error {
    case importFailed
  }

  struct ProfileImage: Transferable {
    let image: Image

    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in

        guard let uiImage = UIImage(data: data) else {
          throw TransferError.importFailed
        }

        let image = Image(uiImage: uiImage)
        return ProfileImage(image: image)

      }
    }
  }

  @Published var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
        let progress = loadTransferable(from: imageSelection)
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }

  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: ProfileImage.self) { result in

      DispatchQueue.main.async {
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected item.")
          return
        }
        switch result {
        case .success(let profileImage?):
          self.imageState = .success(profileImage.image)
        case .success(.none):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }

    }
  }
}

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

    }
  }
}
