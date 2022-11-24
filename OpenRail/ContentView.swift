//
//  ContentView.swift
//  OpenRail
//
//  Created by Karl Beecken on 23.11.22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var overlay = MKTileOverlay(urlTemplate: "https://a.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png")

    @State private var follow: Bool = false

    func switchOverlay(target: String) {
        print(target)
        self.overlay = MKTileOverlay(urlTemplate: "https://b.tiles.openrailwaymap.org/\(target)/{z}/{x}/{y}.png")
        self.currentOverlayTarget = target
    }

    @State var currentOverlayTarget = "standard"
    let overlayTargets: [String] = ["standard", "maxspeed", "signals", "electrified", "gauge"]
    let overlayTargetLabels: [String] = ["Infrastructure", "Max Speeds", "Signals", "Electrification", "Track Gauge"]

    var body: some View {
        NavigationView {
            VStack {
                CoolMap(overlay: $overlay, follow: $follow)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("Map © [OpenStreetMap Contributors](https://www.openstreetmap.org/copyright), Style [CC BY-SA 2.0](http://creativecommons.org/licenses/by-sa/2.0/) [OpenRailwayMap](https://openrailwaymap.org/)")
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 1, leading: 2, bottom: 2, trailing: 2))
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 0, style: .continuous)
                    )
                    .padding(EdgeInsets(top: -15, leading: 0, bottom: 0, trailing: 0))

                    .frame(maxWidth: .infinity, maxHeight: 0)
            }
            .navigationTitle("OpenRail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(Array(overlayTargets.enumerated()), id: \.element) { index, element in
                            Button(action: {
                                switchOverlay(target: element)
                            }) {
                                if element == currentOverlayTarget {
                                    Label(overlayTargetLabels[index], systemImage: "checkmark")
                                } else {
                                    Text(overlayTargetLabels[index])
                                }
                            }
                        }

                    } label: {
                        Label("Switch Layers", systemImage: "square.3.layers.3d")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        follow.toggle()
                    } label: {
                        if follow {
                            Label("Center to current position", systemImage: "location.fill")
                        } else {
                            Label("Center to current position", systemImage: "location")
                        }
                    } 
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
