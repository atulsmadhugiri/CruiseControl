import CloudKit
import SwiftUI

struct SocialFeedPostEngagement: View {
  var drivePostID: CKRecord.ID?
  @State var liked: Bool = false
  @State var likeCount: Int = 0
  @State var bounceValue: Bool = false
  @State var showingCommentSheet: Bool = false

  let likeFeedback = UIImpactFeedbackGenerator(style: .heavy)
  let unlikeFeedback = UIImpactFeedbackGenerator(style: .light)

  var body: some View {
    HStack {
      Button {

        if let drivePostID {
          let reaction: PostReaction = PostReaction(drivePostID: drivePostID, liked: !liked)
          Task {
            await reaction.saveReaction()
          }
        }

        likeCount = liked ? likeCount - 1 : likeCount + 1
        bounceValue = !liked ? !bounceValue : bounceValue
        liked = !liked
        if liked {
          likeFeedback.impactOccurred()
        } else {
          unlikeFeedback.impactOccurred()
        }
      } label: {
        Image(systemName: "heart.fill")
          .frame(height: 20)
          .foregroundColor(liked ? .pink : .none)
          .symbolEffect(.bounce, value: bounceValue)
        Text("\(likeCount)")
          .foregroundColor(liked ? .pink : .none)
          .contentTransition(.numericText(countsDown: liked))
      }.buttonStyle(.bordered).tint(liked ? .pink : .secondary)
      Button {
        showingCommentSheet = true
      } label: {
        HStack {
          Image(systemName: "bubble.fill").frame(height: 20)
          Text("Comment")
        }.frame(maxWidth: .infinity)
      }.buttonStyle(.bordered).tint(.secondary)
        .sheet(isPresented: $showingCommentSheet) {
          SocialFeedCommentSheet()
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }

    }.onAppear {
      likeFeedback.prepare()
      unlikeFeedback.prepare()
      Task {
        await fetchPostReactions()
      }
    }
  }

  func fetchPostReactions() async {
    guard let drivePostID else {
      return
    }

    do {
      let publicDB = CKContainer.default().publicCloudDatabase
      let reference = CKRecord.Reference(recordID: drivePostID, action: .none)
      let predicate = NSPredicate(format: "drivePostRef == %@", reference)
      let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)

      let query = CKQuery(recordType: "PostReactionAlpha", predicate: predicate)
      query.sortDescriptors = [sortDescriptor]

      let (matchResults, _) = try await publicDB.records(matching: query)
      var postReactions: [PostReaction] = []

      for (_, recordResult) in matchResults {
        switch recordResult {
        case .success(let record):
          if let postReaction = PostReaction(from: record) {
            postReactions.append(postReaction)
          }
        case .failure(let error):
          print("Error fetching PostReaction record: \(error.localizedDescription)")
        }
      }

      // TODO: This is extremely hacky and inefficient.
      // Will get the UI right and then handle this properly.
      let currentUserRecord = await potentiallyGetCurrentUserProfileRecord()
      let currentUserRecordID = currentUserRecord?.creatorUserRecordID
      let currentUserReaction = postReactions.first(where: { $0.creator == currentUserRecordID })
      if let currentUserReaction {
        self.liked = currentUserReaction.liked
      }

      let uniqueReactions = PostReaction.computeUniqueReactions(unfilteredReactions: postReactions)
      self.likeCount = uniqueReactions

    } catch {
      print("Error potentially fetching PostReactions: \(error.localizedDescription)")
      return
    }
  }

}

#Preview {
  SocialFeedPostEngagement()
}
