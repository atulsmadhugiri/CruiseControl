import Foundation

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
