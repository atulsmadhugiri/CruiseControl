import CloudKit
import SwiftUI

struct SocialFeedCommentSheet: View {
  var drivePostID: CKRecord.ID?
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
      }.padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0)).backgroundStyle(.blue)
    }.safeAreaInset(edge: .bottom) {
      HStack {
        TextField("Write a comment...", text: $comment).frame(
          width: 300
        ).textFieldStyle(.roundedBorder)
        Button {
          commentFeedback.impactOccurred()

          if let drivePostID {
            let comment: PostComment = PostComment(drivePostID: drivePostID, content: comment)
            Task {
              await comment.saveComment()
            }
          }

        } label: {
          Image(systemName: "paperplane.fill").frame(height: 20)
        }.buttonStyle(.bordered).tint(comment.isEmpty ? .secondary : .blue)
      }.frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
    }.onAppear {
      commentFeedback.prepare()
    }
  }
}

#Preview {
  SocialFeedCommentSheet()
}
