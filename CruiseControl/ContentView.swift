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
            Text("\(drive.name) completed on \(drive.endTime.formatted(date: .abbreviated, time: .shortened))")
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
  ContentView()
    .modelContainer(for: AimlessDrive.self, inMemory: true)
}
