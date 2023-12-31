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

    }
  }
}

struct ProfilePicture: View {
  let imageState: ProfileViewModel.ImageState

  var body: some View {
    ProfilePictureContent(imageState: imageState)
      .scaledToFill()
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .frame(width: 100, height: 100)
      .background {
        RoundedRectangle(cornerRadius: 8)
          .fill(
            LinearGradient(
              colors: [.blue, .gray],
              startPoint: .top,
              endPoint: .bottom))
      }
  }
}

struct ProfileView: View {
  @State private var avatarSelection: PhotosPickerItem?
  @State private var avatarImage: Image?

  var body: some View {
    VStack {
      PhotosPicker(
        "Select profile picture", selection: $avatarSelection,
        matching: .all(of: [.images, .not(.livePhotos)]))

      avatarImage?.resizable().scaledToFit().frame(width: 300, height: 300)

    }.task(id: avatarSelection) {
      avatarImage = try? await avatarSelection?.loadTransferable(type: Image.self)
    }
  }
}
