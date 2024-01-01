import Foundation
import PhotosUI
import SwiftUI

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