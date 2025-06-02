import CloudKit
import SwiftUI

struct CommentCell: View {
  var postComment: PostComment

  @State var firstName: String?
  @State var lastName: String?
  @State var profilePicture: URL?
  @State var hasUserFetchBeenAttempted: Bool = false

  var body: some View {
    HStack(alignment: .top) {
      AsyncImage(url: profilePicture) { image in
        image.resizable()
          .frame(width: 40, height: 40)
          .cornerRadius(8.0)
      } placeholder: {
        Color.gray.opacity(0.3).frame(width: 40, height: 40).cornerRadius(8.0)
      }

      VStack(alignment: .leading) {
        HStack {
          Text(formattedDisplayName(firstName: firstName, lastName: lastName)).lineLimit(1).font(.caption2).bold().redacted(
            reason: !hasUserFetchBeenAttempted ? .placeholder : [])
          Text(postComment.createdAt.formatted()).font(.caption2).foregroundStyle(.secondary)
        }
        Text(potentiallyRenderMarkdown(string: postComment.content.trimmingCharacters(in: .whitespaces))).font(.caption)
      }
    }.onAppear {
      Task {
        await fetchAuthorProfile()
      }
    }
  }

  func fetchAuthorProfile() async {
    let info = await fetchUserProfileInfo(userRecordID: postComment.creator)
    self.firstName = info.firstName
    self.lastName = info.lastName
    self.profilePicture = info.profilePicture
    self.hasUserFetchBeenAttempted = true
  }

}
