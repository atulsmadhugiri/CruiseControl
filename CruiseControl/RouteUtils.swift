import Algorithms
import Foundation
import MapKit

func distanceTraveled(route: [CLLocationCoordinate2D]) -> CLLocationDistance {
  guard !route.isEmpty else { return 0 }

  var totalDistance: CLLocationDistance = 0
  for (pointA, pointB) in route.adjacentPairs() {
    let startLocation = CLLocation(coordinate: pointA)
    let endLocation = CLLocation(coordinate: pointB)
    totalDistance += startLocation.distance(from: endLocation)
  }

  return totalDistance
}

func formattedDistanceTraveled(distance: CLLocationDistance) -> String {
  let distanceFormatter = MKDistanceFormatter()
  distanceFormatter.unitStyle = .full
  return distanceFormatter.string(fromDistance: distance)
}
