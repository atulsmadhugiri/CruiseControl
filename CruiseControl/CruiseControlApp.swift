import SwiftData
import SwiftUI

@main
struct CruiseControlApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([AimlessDrive.self])

    let persistentConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(
        for: schema,
        configurations: [persistentConfiguration])
    } catch {
      print("Could not create persistent ModelContainer: \(error). Falling back to in-memory store.")
      let memoryConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: true)
      return try! ModelContainer(
        for: schema,
        configurations: [memoryConfiguration])
    }
  }()

  var body: some Scene {
    WindowGroup {
      RootView()
    }
    .modelContainer(sharedModelContainer)
  }
}
