//
//  QuakeDetail.swift
//  Earthquakes-iOS
//
//  Created by Serhii Sachuk on 23.01.2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct QuakeDetail: View {
    var quake: Quake
    @EnvironmentObject private var quakesProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil

    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMap(location: location,
                               tintColor: quake.color)
                .ignoresSafeArea(.container)
            }
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
            Text("\(quake.time.formatted(date: .long, time: .standard))")
                .foregroundStyle(Color.secondary)
            if let location {
                Text("Latitude: \(location.latitude.formatted(.number.precision(.fractionLength(3))))")
                Text("Longtitude: \(location.longitude.formatted(.number.precision(.fractionLength(3))))")
            }
        }
        .task {
            if self.location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    self.location = try? await quakesProvider.location(for: quake)
                }
            }
        }
    }
}

struct QuakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        QuakeDetail(quake: Quake.preview)
    }
}
