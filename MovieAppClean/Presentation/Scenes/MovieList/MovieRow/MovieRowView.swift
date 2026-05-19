//
//  MovieRowView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 18.05.26.
//

import Combine
import SwiftUI

protocol MovieRowViewModelProtocol: ObservableObject {
    var posterURL: URL? { get }
    var title: String { get }
    var rating: String { get }
    var releaseYear: String { get }
    var overview: String { get }

    func onTap()
}

struct MovieRowView<ViewModel: MovieRowViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            posterImage
            infoView
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.secondarySystemBackground)))
        .onTapGesture {
            viewModel.onTap()
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var posterImage: some View {
        if let posterURL = viewModel.posterURL {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure:
                    posterPlaceholder
                case .empty:
                    posterPlaceholder.redacted(reason: .placeholder)
                @unknown default:
                    posterPlaceholder
                }
            }
            .frame(width: 70, height: 105)
            .clipped()
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(viewModel.title)
                .font(.headline)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                Text(viewModel.rating)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("·")
                    .foregroundColor(.secondary)
                Text(viewModel.releaseYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text(viewModel.overview)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }

    private var posterPlaceholder: some View {
        Rectangle()
            .fill(Color(.tertiarySystemBackground))
            .overlay(
                Image(systemName: "film")
                    .foregroundColor(.secondary)
                    .font(.title2)
            )
    }
}
