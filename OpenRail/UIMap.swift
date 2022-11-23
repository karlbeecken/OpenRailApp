//
//  UIMap.swift
//  OpenRail
//
//  Created by Karl Beecken on 23.11.22.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

let berlinCoords = CLLocationCoordinate2DMake(52.520, 13.405)



struct CoolMap: UIViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CoolMap
        
        init(_ parent: CoolMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKTileOverlay {
                let renderer = MKTileOverlayRenderer(overlay: overlay)
                return renderer
            } else {
                return MKTileOverlayRenderer()
            }
        }
    }
    
    @Binding var overlay: MKTileOverlay
    
    func makeUIView(context: Context) -> MKMapView {

        let mapView = MKMapView();
        
        let region = MKCoordinateRegion(center: berlinCoords, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = context.coordinator;
        
        mapView.addOverlay(overlay);
        
        return mapView;
        
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let allOverlays = mapView.overlays
        mapView.removeOverlays(allOverlays)
        mapView.addOverlay(overlay)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
