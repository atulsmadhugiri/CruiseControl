import SwiftUI

struct SocialFeedPostEngagement: View {
  var body: some View {
    HStack {
      Button {
        print("UNIMPLEMENTED")
      } label: {
        Image(systemName: "heart.fill").frame(height: 20).foregroundColor(.pink)
        Text("3").foregroundColor(.pink)
      }.buttonStyle(.bordered).tint(.secondary)
      Button {
        print("UNIMPLEMENTED")
      } label: {
        HStack {
          Image(systemName: "bubble.fill").frame(height: 20)
          Text("Comment")
        }.frame(maxWidth: .infinity)
      }.buttonStyle(.bordered).tint(.secondary)
    }
  }
}

#Preview {
  SocialFeedPostEngagement()
}
