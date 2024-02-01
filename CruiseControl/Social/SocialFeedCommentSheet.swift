import SwiftUI

struct SocialFeedCommentSheet: View {
  @State private var comment = ""

  let commentFeedback = UIImpactFeedbackGenerator(style: .heavy)

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
          commentFeedback.impactOccurred()
        } label: {
          Image(systemName: "paperplane.fill").frame(height: 20)
        }.buttonStyle(.bordered).tint(comment.isEmpty ? .secondary : .blue)
      }.padding()
    }.onAppear {
      commentFeedback.prepare()
    }
  }
}

#Preview {
  SocialFeedCommentSheet()
}
