//
//  MarkedMap.swift
//  Created by Mark Renaud (2024).
//

import MapKit
import SwiftUI

/// A view that displays a map centered on a specific coordinate with a single marker.
struct MarkedMap: View {
    @State var region: MKCoordinateRegion
    
    init(latitude: Double, longitude: Double) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: Constants.Map.defaultRegionMeters,
            longitudinalMeters: Constants.Map.defaultRegionMeters
        )
    }
    
    init(latitude: String, longitude: String) {
        let dLatitude = Double(latitude) ?? Constants.Map.Location.applePark.coordinates.latitude
        let dLongitude = Double(longitude) ?? Constants.Map.Location.applePark.coordinates.longitude
        
        let center = CLLocationCoordinate2D(latitude: dLatitude, longitude: dLongitude)
        
        self.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: Constants.Map.defaultRegionMeters,
            longitudinalMeters: Constants.Map.defaultRegionMeters
        )
    }
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: [],
            annotationItems: [Marker(center: region.center)]
        ) { marker in
            MapMarker(coordinate: marker.center, tint: .red)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
}

private struct Marker: Identifiable {
    let id = UUID()
    let center: CLLocationCoordinate2D
}

#Preview {
    Form {
        MarkedMap(
            latitude: Constants.Map.Location.applePark.coordinates.latitude,
            longitude: Constants.Map.Location.applePark.coordinates.longitude
        )
    }
}
