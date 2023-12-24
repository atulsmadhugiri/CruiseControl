import SwiftUI

struct SlowPokeBadge: View {
  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 80, height: 80)
        .cornerRadius(8.0)
        .foregroundStyle(.green)

      Image(systemName: "tortoise.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50)
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  SlowPokeBadge()
}
