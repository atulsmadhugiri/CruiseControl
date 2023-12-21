import CoreLocation
import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var drives: [AimlessDrive]

  var body: some View {
    NavigationSplitView {
      List {
        ForEach(drives) { drive in
          NavigationLink {
            AimlessDriveDetailView(aimlessDrive: drive)
          } label: {
            Text("Drive completed at \(drive.endTime)")
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
        startTime: Date(), endTime: Date(), route: [])
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
