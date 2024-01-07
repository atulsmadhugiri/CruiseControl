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
          Text(drive.description).font(.footnote)

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
            .shadow(radius: 1.0)

          SocialFeedPostEngagement()

        }

      }
    }.listStyle(.plain).onAppear {
      Task {
        await viewModel.fetchDrivePosts()
      }
    }
  }
}

#Preview {
  SocialFeed()
}
