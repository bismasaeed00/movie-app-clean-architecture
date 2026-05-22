//
//  MovieTileView.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import SwiftUI

struct MovieTileView: View {
    let movie: Movie

    private var posterURL: URL? {
        movie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500\($0)") }
    }

    private var formattedRating: String {
        String(format: "%.1f", movie.voteAverage)
    }

    private var formattedYear: String {
        guard let date = movie.releaseDate, date.count >= 4 else { return "N/A" }
        return String(date.prefix(4))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            posterImage
            infoView
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: - Subviews

    private var posterImage: some View {
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

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                Text(formattedRating)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("·")
                    .foregroundColor(.secondary)
                Text(formattedYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Text(movie.overview)
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
