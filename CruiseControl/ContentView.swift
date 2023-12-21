import CoreLocation
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var drives: [AimlessDrive]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(drives) { item in
          NavigationLink {
            Text(
              "Start Time: \(item.startTime, format: Date.FormatStyle(date: .numeric, time: .standard))"
            )
            Text(
              "End Time: \(item.endTime, format: Date.FormatStyle(date: .numeric, time: .standard))"
            )
            Text(
              "Start Location: \(item.startLocation.latitude.description), \(item.startLocation.longitude.description)"
            )
            Text(
              "End Location: \(item.endLocation.latitude.description), \(item.endLocation.longitude.description)"
            )
          } label: {
            Text("Drive completed at \(item.endTime)")
          }
        }
        .onDelete(perform: deleteItems)
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    } detail: {
      Text("Select an item")
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = AimlessDrive(
        startTime: Date(), endTime: Date(),
        startLocation: CLLocationCoordinate2D(latitude: 47.62732, longitude: 122.06952),
        endLocation: CLLocationCoordinate2D(latitude: 47.62732, longitude: 122.06952), route: [])
      modelContext.insert(newItem)
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
  ContentView()
    .modelContainer(for: AimlessDrive.self, inMemory: true)
}
