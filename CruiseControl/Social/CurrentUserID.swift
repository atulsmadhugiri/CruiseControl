import SwiftUI

private struct CurrentUserID: EnvironmentKey {
  static let defaultValue: String? = nil
}

extension EnvironmentValues {
  var currentUserID: String? {
    get { self[CurrentUserID.self] }
    set { self[CurrentUserID.self] = newValue }
  }
}
