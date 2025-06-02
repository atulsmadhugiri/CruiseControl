import Foundation
import CloudKit

func potentiallyRenderMarkdown(string: String) -> AttributedString {
  do {
    return try AttributedString(
      markdown: string,
      options: AttributedString.MarkdownParsingOptions(
        interpretedSyntax: .inlineOnlyPreservingWhitespace))
  } catch {
    return AttributedString(stringLiteral: string)
  }
}

func formattedDisplayName(firstName: String?, lastName: String?) -> String {
  let first = firstName ?? "FirstNameLastName"
  guard let lastName, !lastName.isEmpty else {
    return first
  }
  return "\(first) \(lastName)"
}

func fetchUserProfileInfo(userRecordID: CKRecord.ID?) async -> (
  firstName: String?,
  lastName: String?,
  profilePicture: URL?
) {
  guard let userRecordID else { return (nil, nil, nil) }
  guard let record = await potentiallyGetUserProfileRecord(userRecordID: userRecordID) else {
    return (nil, nil, nil)
  }
  let firstName = record.value(forKey: "firstName") as? String
  let lastName = record.value(forKey: "lastName") as? String
  var pictureURL: URL? = nil
  if let profilePicture = record.value(forKey: "profilePicture") as? CKAsset,
     let url = profilePicture.fileURL {
    pictureURL = url
  }
  return (firstName, lastName, pictureURL)
}
