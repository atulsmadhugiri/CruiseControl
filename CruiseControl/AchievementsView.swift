import SwiftUI

struct AchievementsView: View {
  var body: some View {
    List {
      HStack {
        RiseAndGrindBadge().padding()
        VStack(alignment: .leading) {
          Text("Rise And Grind").font(.system(size: 20, design: .rounded).weight(.bold))
          Text("Start a drive before 7:00 AM")
        }
        Spacer()
        Image(systemName: "trophy.fill").imageScale(.large).foregroundColor(.yellow)
      }
      HStack {
        GasGuzzlerBadge().padding()
        VStack(alignment: .leading) {
          Text("Gas Guzzler").font(.system(size: 20, design: .rounded).weight(.bold))
          Text("Drive more than PLACEHOLD miles")
        }
        Spacer()
        Image(systemName: "lock.fill").imageScale(.large)
      }
      HStack {
        SlowPokeBadge().padding()
        VStack(alignment: .leading) {
          Text("Slow Poke").font(.system(size: 20, design: .rounded).weight(.bold))
          Text("Stay under 15 MPH for a whole drive")
        }
        Spacer()
        Image(systemName: "lock.fill").imageScale(.large)
      }
    }
  }
}

#Preview {
  AchievementsView()
}
