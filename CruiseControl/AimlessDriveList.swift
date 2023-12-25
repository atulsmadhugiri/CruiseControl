import CoreLocation
import MapKit
import SwiftData
import SwiftUI

struct AimlessDriveList: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \AimlessDrive.endTime, order: .reverse) private var drives: [AimlessDrive]

  var body: some View {
    NavigationStack {
      List {
        ForEach(drives) { drive in
          NavigationLink {
            AimlessDriveDetailView(aimlessDrive: drive)
              .navigationTitle(drive.name)
              .navigationBarTitleDisplayMode(.inline)
          } label: {
            AimlessDriveListCell(drive: drive)
          }
        }
        .onDelete(perform: deleteItems)
      }.navigationTitle("Drives")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
          }
        }
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
