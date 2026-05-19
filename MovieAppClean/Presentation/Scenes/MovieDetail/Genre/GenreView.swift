//
//  GenreView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import SwiftUI

@MainActor
protocol GenreViewModelProtocol: ObservableObject {
    var genreNames: [String] { get }
}

struct GenreView<ViewModel: GenreViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(viewModel.genreNames, id: \.self) { genre in
                Text(genre)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(Capsule().fill(.blue))
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }
}
