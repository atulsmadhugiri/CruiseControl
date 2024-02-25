import CloudKit
import SwiftUI

private struct CurrentUserID: EnvironmentKey {
  static let defaultValue: CKRecord.ID? = nil
}

extension EnvironmentValues {
  var currentUserID: CKRecord.ID? {
    get { self[CurrentUserID.self] }
    set { self[CurrentUserID.self] = newValue }
  }
}
