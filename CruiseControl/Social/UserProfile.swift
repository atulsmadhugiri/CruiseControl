import CloudKit

struct UserProfile {
  var firstName: String
  var lastName: String
  var biography: String
  var profilePicture: URL?

  init(
    firstName: String,
    lastName: String,
    biography: String,
    profilePicture: URL? = nil
  ) {
    self.firstName = firstName
    self.lastName = lastName
    self.biography = biography
    self.profilePicture = profilePicture
  }
}
