//
//  EmptyStateView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import SwiftUI

struct EmptyStateView: View {
    var icon: String = "film.stack"
    var title: String = "No Movies Yet"
    var message: String = "Pull down to load movies from the network."

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundColor(.secondary)

            Text(title)
                .font(.title3.bold())

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
