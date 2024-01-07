import CloudKit
import SwiftUI

struct SocialFeedPostAuthorView: View {
  var creator: CKRecord.ID?
  var body: some View {
    HStack {
      Text("\(creator?.recordName ?? "Unknown")".suffix(10))
      Image(systemName: "checkmark.seal.fill")
        .foregroundColor(.yellow)
        .frame(width: 12)
        .font(.system(size: 14))
    }
  }
}
