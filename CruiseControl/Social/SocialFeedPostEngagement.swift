import SwiftUI

struct SocialFeedPostEngagement: View {
  @State var liked: Bool = false
  @State var likeCount: Int = 2
  @State var bounceValue: Bool = false
  let hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)

  var body: some View {
    HStack {
      Button {
        likeCount = liked ? likeCount - 1 : likeCount + 1
        bounceValue = !liked ? !bounceValue : bounceValue
        liked = !liked
        hapticFeedback.impactOccurred()
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
        print("UNIMPLEMENTED")
      } label: {
        HStack {
          Image(systemName: "bubble.fill").frame(height: 20)
          Text("Comment")
        }.frame(maxWidth: .infinity)
      }.buttonStyle(.bordered).tint(.secondary)
    }.onAppear {
      hapticFeedback.prepare()
    }
  }
}

#Preview {
  SocialFeedPostEngagement()
}
