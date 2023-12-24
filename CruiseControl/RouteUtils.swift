import Foundation
import MapKit

func distanceTraveled(route: [CLLocationCoordinate2D]) -> CLLocationDistance {
  guard !route.isEmpty else { return 0 }

  var distance: CLLocationDistance = 0
  var pointA = CLLocation(coordinate: route[0])

  for idx in 1..<route.count {
    let pointB = CLLocation(coordinate: route[idx])
    distance += pointA.distance(from: pointB)
    pointA = pointB
  }

  return distance
}

func formattedDistanceTraveled(route: [CLLocationCoordinate2D]) -> String {
  let distance = distanceTraveled(route: route)
  let distanceFormatter = MKDistanceFormatter()
  distanceFormatter.unitStyle = .full
  return distanceFormatter.string(fromDistance: distance)
}
