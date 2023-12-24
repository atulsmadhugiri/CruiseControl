import CoreLocation
import MapKit
import SwiftData
import SwiftUI

struct AimlessDriveList: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \AimlessDrive.endTime, order: .reverse) private var drives: [AimlessDrive]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(drives) { drive in
          NavigationLink {
            AimlessDriveDetailView(aimlessDrive: drive)
          } label: {
            HStack {
              Map(interactionModes: []) {
                MapPolyline(coordinates: drive.route)
                  .stroke(
                    .blue,
                    style: StrokeStyle(
                      lineWidth: 6,
                      lineCap: .round,
                      lineJoin: .round
                    )
                  )
              }.frame(width: 120, height: 90)
                .allowsHitTesting(false)
                .cornerRadius(8.0)
                .shadow(radius: 1.0)

              VStack(alignment: .leading) {
                Text(drive.name).font(.system(size: 20, design: .rounded).weight(.bold))
                Text(formattedDistanceTraveled(route: drive.route))
                Text(drive.endTime.formatted(date: .abbreviated, time: .shortened))
                  .font(.system(size: 12, design: .rounded))
                Spacer()
              }.padding()
            }.padding(EdgeInsets(top: 8.0, leading: 0, bottom: 8.0, trailing: 0))
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }
    } detail: {
      Text("Select an item")
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(drives[index])
      }
    }
  }
}

#Preview {
  AimlessDriveList()
    .modelContainer(for: AimlessDrive.self, inMemory: true)
}
