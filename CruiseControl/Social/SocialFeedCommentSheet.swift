import CloudKit
import SwiftUI

struct SocialFeedCommentSheet: View {
  var drivePostID: CKRecord.ID?
  @State var postComments: [PostComment] = []
  @State private var comment = ""

  let commentFeedback = UIImpactFeedbackGenerator(style: .heavy)

  var body: some View {
    VStack {
      List {
        ForEach(postComments) { comment in
          CommentCell(postComment: comment)
        }
      }.padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0)).backgroundStyle(.blue)
    }.safeAreaInset(edge: .bottom) {
      HStack {
        TextField("Write a comment...", text: $comment).frame(
          width: 300
        ).textFieldStyle(.roundedBorder)
        Button {
          commentFeedback.impactOccurred()

          if let drivePostID {
            let postComment: PostComment = PostComment(drivePostID: drivePostID, content: comment)
            comment = ""
            Task {
              await postComment.saveComment()
              postComments.append(postComment)
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
      Task {
        await fetchPostComments()
      }
    }
  }

  func fetchPostComments() async {
    guard let drivePostID else {
      return
    }

    do {
      let publicDB = CKContainer.default().publicCloudDatabase
      let reference = CKRecord.Reference(recordID: drivePostID, action: .none)
      let predicate = NSPredicate(format: "drivePostRef == %@", reference)
      let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)

      let query = CKQuery(recordType: "PostCommentAlpha", predicate: predicate)
      query.sortDescriptors = [sortDescriptor]

      let (matchResults, _) = try await publicDB.records(matching: query)
      var fetchedComments: [PostComment] = []

      for (_, recordResult) in matchResults {
        switch recordResult {
        case .success(let record):
          if let postComment = PostComment(from: record) {
            fetchedComments.append(postComment)
          }
        case .failure(let error):
          print("Error fetching PostReaction record: \(error.localizedDescription)")
        }
      }

      self.postComments = fetchedComments

    } catch {
      print("Error potentially fetching PostComments: \(error.localizedDescription)")
    }
  }

}

#Preview {
  SocialFeedCommentSheet()
}
