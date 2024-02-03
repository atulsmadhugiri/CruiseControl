import SwiftUI

struct CommentCell: View {
  var postComment: PostComment
  var body: some View {
    HStack(alignment: .top) {
      AsyncImage(url: URL(string: "https://blob.sh/atul.png")) { image in
        image.resizable()
          .frame(width: 40, height: 40)
          .cornerRadius(8.0)
      } placeholder: {
        Color.gray.opacity(0.3).frame(width: 40, height: 40).cornerRadius(8.0)
      }

      VStack(alignment: .leading) {
        HStack {
          Text("Atul Madhugiri").lineLimit(1).font(.caption2).bold()
          Text(postComment.createdAt.formatted()).font(.caption2).foregroundStyle(.secondary)
        }
        Text(postComment.content).font(.caption)
      }
    }
  }
}
