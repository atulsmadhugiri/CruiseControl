import SwiftUI

struct EarlyBirdBadge: View {
  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 80, height: 80)
        .cornerRadius(8.0)
        .foregroundStyle(.orange)

      Image(systemName: "sun.horizon.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50)
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  EarlyBirdBadge()
}
