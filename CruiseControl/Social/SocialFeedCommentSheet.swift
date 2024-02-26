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
        TextField("Write a comment...", text: $comment, axis: .vertical).frame(
          width: 300
        ).textFieldStyle(.roundedBorder)
        Button {
          if comment.isEmpty {
            return
          }
          commentFeedback.impactOccurred()
          if let drivePostID {
            Task {
              let currentUserRecord = await potentiallyGetCurrentUserProfileRecord()
              let currentUserRecordID = currentUserRecord?.creatorUserRecordID
              let postComment: PostComment = PostComment(
                drivePostID: drivePostID,
                content: comment,
                creator: currentUserRecordID)
              comment = ""
              await postComment.saveComment()
              withAnimation {
                postComments.append(postComment)
              }
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

    let publicDB = CKContainer.default().publicCloudDatabase
    let reference = CKRecord.Reference(recordID: drivePostID, action: .none)
    let predicate = NSPredicate(format: "drivePostRef == %@", reference)
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)

    let query = CKQuery(recordType: "PostCommentAlpha", predicate: predicate)
    query.sortDescriptors = [sortDescriptor]

    do {
      let (matchResults, _) = try await publicDB.records(matching: query)
      self.postComments = try matchResults.compactMap { (_, recordResult) in
        let record = try recordResult.get()
        return PostComment(from: record)
      }
    } catch {
      print("Error potentially fetching PostComments: \(error.localizedDescription)")
    }
  }

}

#Preview {
  SocialFeedCommentSheet()
}
