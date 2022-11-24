//
//  UIMap.swift
//  OpenRail
//
//  Created by Karl Beecken on 23.11.22.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

let berlinCoords = CLLocationCoordinate2DMake(52.520, 13.405)

struct CoolMap: UIViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CoolMap

        init(_ parent: CoolMap) {
            self.parent = parent
        }

        func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKTileOverlay {
                let renderer = MKTileOverlayRenderer(overlay: overlay)
                return renderer
            } else {
                return MKTileOverlayRenderer()
            }
        }
    }

    @Binding var overlay: MKTileOverlay
    @Binding var follow: Bool
    @ObservedObject var lm = LocationModel()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()

        let region = MKCoordinateRegion(center: berlinCoords, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)

        lm.requestAuthorisation(always: false)
        mapView.showsUserLocation = true

        mapView.delegate = context.coordinator

        overlay.maximumZ = 19

        mapView.addOverlay(overlay, level: .aboveLabels)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context _: Context) {
        let allOverlays = mapView.overlays
        if !allOverlays.contains(where:  {overlay == $0 as! NSObject}) {
            mapView.removeOverlays(allOverlays)
            mapView.addOverlay(overlay)
        }
        
        if follow {
            let region = MKCoordinateRegion(center: lm.coords, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            print(lm.coords)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
