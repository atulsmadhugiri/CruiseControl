import SwiftUI

struct SpeedRacerBadge: View {
  var body: some View {
    ZStack {
      Rectangle()
        .frame(width: 80, height: 80)
        .cornerRadius(8.0)
        .foregroundStyle(.primary)

      Image(systemName: "gauge.open.with.lines.needle.84percent.exclamation")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50)
        .symbolRenderingMode(.palette)
        .foregroundStyle(.red, .background)
    }
  }
}

#Preview {
  SpeedRacerBadge()
}
