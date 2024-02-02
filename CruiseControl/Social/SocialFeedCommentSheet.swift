import SwiftUI

struct SocialFeedCommentSheet: View {
  @State private var comment = ""

  let commentFeedback = UIImpactFeedbackGenerator(style: .heavy)

  var body: some View {
    VStack {
      List {
        CommentCell()
        CommentCell()
        CommentCell()
        CommentCell()
        CommentCell()
      }.padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
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
      }.padding().background(.thinMaterial)
    }.onAppear {
      commentFeedback.prepare()
    }
  }
}

#Preview {
  SocialFeedCommentSheet()
}
