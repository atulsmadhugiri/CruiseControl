import SwiftUI

struct SocialFeedPostProfileView: View {
  var body: some View {
    HStack {
      Text("Atul Madhugiri")
      Image(systemName: "checkmark.seal.fill")
        .foregroundColor(.yellow)
        .frame(width: 12)
        .font(.system(size: 14))
    }
  }
}

#Preview {
  SocialFeedPostProfileView()
}
