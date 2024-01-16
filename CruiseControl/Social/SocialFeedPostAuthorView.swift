import CloudKit
import SwiftUI

struct SocialFeedPostAuthorView: View {
  var creator: CKRecord.ID?
  var endTime: Date
  @State var firstName: String?
  @State var lastName: String?
  @State var profilePicture: URL?

  @State var hasUserFetchBeenAttempted: Bool = false

  var body: some View {

    HStack {
      AsyncImage(url: profilePicture) { image in
        image.resizable()
          .frame(width: 40, height: 40)
          .cornerRadius(8.0).transition(.opacity.animation(.easeIn))
          .transition(.opacity.animation(.snappy))
      } placeholder: {
        Color.gray.opacity(0.3).frame(width: 40, height: 40).cornerRadius(8.0)
      }
      VStack(alignment: .leading) {
        HStack {
          Text("\(firstName ?? "FirstNameLastName")\(lastName.map { " \($0)" } ?? "")")
            .lineLimit(1)
            .redacted(reason: !hasUserFetchBeenAttempted ? .placeholder : [])
            .animation(.snappy, value: hasUserFetchBeenAttempted)

          Image(systemName: "checkmark.seal.fill")
            .foregroundColor(.yellow)
            .frame(width: 12)
            .font(.system(size: 14))
            .animation(.snappy) { content in
              content.opacity(hasUserFetchBeenAttempted ? 1.0 : 0)
            }

        }
        Text(endTime.formatted(date: .abbreviated, time: .shortened))
          .font(.system(size: 12, design: .rounded))
      }
    }.onAppear {
      Task {
        await fetchAuthorProfile()
      }
    }
  }

  func fetchAuthorProfile() async {
    guard let creator else {
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
