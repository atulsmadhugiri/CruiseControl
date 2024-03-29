import MapKit
import SwiftUI

struct SocialFeed: View {
  @StateObject var viewModel = SocialFeedViewModel()
  var body: some View {

    List {
      ForEach(viewModel.drivePosts) { drive in
        VStack(alignment: .leading) {

          SocialFeedPostAuthorView(creator: drive.creator, endTime: drive.endTime)
          Text(drive.name).font(.title3).fontWeight(.semibold)
          if !drive.description.isEmpty {
            Text(potentiallyRenderMarkdown(string: drive.description)).font(.footnote)
          }

          // Extremely hacky way to get the spacing I want.
          // TODO: Any other approach.
          Text("").font(.footnote)

          HStack {
            VStack(alignment: .leading) {
              Text(formattedDistanceTraveled(distance: drive.distanceTraveled))
              Text("Distance Traveled")
                .font(.caption2)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
              Text(formatTimeInterval(interval: drive.endTime.timeIntervalSince(drive.startTime)))
              Text("Time Elapsed")
                .font(.caption2)
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
            }
          }

          Map(interactionModes: []) {
            MapPolyline(coordinates: drive.route)
              .stroke(
                .blue,
                style: StrokeStyle(
                  lineWidth: 6,
                  lineCap: .round,
                  lineJoin: .round
                )
              )
            if let startingLocation = drive.route.first {
              Annotation("Start", coordinate: startingLocation, anchor: .bottom) {
                Image(systemName: "flag.fill")
                  .padding(8)
                  .foregroundStyle(.white)
                  .background(Color.indigo)
                  .cornerRadius(4)
              }
            }

            if let endingLocation = drive.route.last {
              Annotation("End", coordinate: endingLocation, anchor: .bottom) {
                Image(systemName: "flag.checkered")
                  .padding(8)
                  .foregroundStyle(.white)
                  .background(Color.orange)
                  .cornerRadius(4)
              }
            }
          }.frame(height: 200)
            .allowsHitTesting(false)
            .cornerRadius(8.0)

          SocialFeedPostEngagement(drivePostID: drive.recordID)

        }

      }
    }.listStyle(.plain).onAppear {
      Task {
        await viewModel.fetchDrivePosts()
        await viewModel.fetchCurrentUserID()
      }
    }.refreshable {
      await viewModel.fetchDrivePosts()
    }.environment(\.currentUserID, viewModel.currentUserID)
  }

  func formatTimeInterval(interval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    let formatted = formatter.string(from: interval) ?? ""
    return formatted
  }
}

#Preview {
  SocialFeed()
}
