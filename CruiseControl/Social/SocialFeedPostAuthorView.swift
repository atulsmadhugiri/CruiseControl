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
          .cornerRadius(8.0)
      } placeholder: {
        Color.gray.opacity(0.3).frame(width: 40, height: 40).cornerRadius(8.0)
      }
      VStack(alignment: .leading) {
        HStack {
          Text(formattedDisplayName(firstName: firstName, lastName: lastName))
            .lineLimit(1)
            .redacted(reason: !hasUserFetchBeenAttempted ? .placeholder : [])
          Image(systemName: "checkmark.seal.fill")
            .foregroundColor(.yellow)
            .frame(width: 12)
            .font(.system(size: 14))

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
    let info = await fetchUserProfileInfo(userRecordID: creator)
    self.firstName = info.firstName
    self.lastName = info.lastName
    self.profilePicture = info.profilePicture
    self.hasUserFetchBeenAttempted = true
  }

}
