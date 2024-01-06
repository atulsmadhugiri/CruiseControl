import Foundation
import PhotosUI
import SwiftUI

enum ImageState {
  case empty
  case loading(Progress)
  case success(Data)
  case failure(Error)
}

enum TransferError: Error {
  case importFailed
}

struct TransferableProfileImage: Transferable {
  let image: Data

  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      return TransferableProfileImage(image: data)
    }
  }
}

@MainActor
class ProfileViewModel: ObservableObject {
  @Published var firstName: String = ""
  @Published var lastName: String = ""
  @Published var biography: String = ""

  @Published private(set) var imageState: ImageState = .empty

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
    return imageSelection.loadTransferable(type: TransferableProfileImage.self) { result in

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
