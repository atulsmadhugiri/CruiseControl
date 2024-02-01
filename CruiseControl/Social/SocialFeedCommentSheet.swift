import SwiftUI

struct SocialFeedCommentSheet: View {
  @State private var comment = ""

  var body: some View {
    VStack {
      Spacer()
      HStack {
      }
    }.safeAreaInset(edge: .bottom) {
      HStack {
        TextField("Write a comment...", text: $comment).frame(
          width: 300
        ).textFieldStyle(.roundedBorder)
        Button {
        } label: {
          Image(systemName: "paperplane.fill").frame(height: 20)
        }.buttonStyle(.bordered).tint(.secondary)
      }.padding()
    }
  }
}

#Preview {
  SocialFeedCommentSheet()
}
