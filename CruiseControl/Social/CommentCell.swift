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
          Text(
            "\(firstName ?? "FirstNameLastName")\(lastName.map { $0 != "" ? " \($0)" : "" } ?? "")"
          ).lineLimit(1).font(.caption2).bold().redacted(
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
    guard let creator = postComment.creator else {
      self.hasUserFetchBeenAttempted = true
      return
    }
    let existingRecord = await potentiallyGetUserProfileRecord(userRecordID: creator)
    if let existingRecord {
      if let firstName = existingRecord.value(forKey: "firstName") as? String {
        self.firstName = firstName
      }
      if let lastName = existingRecord.value(forKey: "lastName") as? String {
        self.lastName = lastName
      }

      if let profilePicture = existingRecord.value(forKey: "profilePicture") as? CKAsset {
        let fileURL = profilePicture.fileURL
        if let fileURL {
          self.profilePicture = fileURL
        }
      }
    }
    self.hasUserFetchBeenAttempted = true
  }

}
