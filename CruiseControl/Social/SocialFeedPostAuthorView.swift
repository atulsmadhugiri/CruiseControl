import CloudKit
import SwiftUI

struct SocialFeedPostAuthorView: View {
  var creator: CKRecord.ID?
  var endTime: Date
  @State var firstName: String?
  @State var lastName: String?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("\(firstName ?? "Anonymous") \(lastName ?? "")")
        Image(systemName: "checkmark.seal.fill")
          .foregroundColor(.yellow)
          .frame(width: 12)
          .font(.system(size: 14))
      }
      Text(endTime.formatted(date: .abbreviated, time: .shortened))
        .font(.system(size: 12, design: .rounded))
    }.onAppear {
      Task {
        await fetchAuthorProfile()
      }
    }
  }

  func fetchAuthorProfile() async {
    guard let creator else { return }
    let existingRecord = await potentiallyGetUserProfileRecord(userRecordID: creator)
    if let existingRecord {
      if let firstName = existingRecord.value(forKey: "firstName") as? String {
        self.firstName = firstName
      }
      if let lastName = existingRecord.value(forKey: "lastName") as? String {
        self.lastName = lastName
      }
    }
  }

}