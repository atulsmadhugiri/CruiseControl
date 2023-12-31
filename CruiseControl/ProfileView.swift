import PhotosUI
import SwiftUI

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
