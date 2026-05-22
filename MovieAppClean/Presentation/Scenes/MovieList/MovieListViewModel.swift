//
//  MovieListViewModel.swift
//  MovieAppClean
//
//  Created by Bisma Saeed on 17.05.26.
//

import Combine
import Foundation

@MainActor
final class MovieListViewModel: MovieListViewModelProtocol {
    private let didTapSubject: PassthroughSubject<Int, Never>
    let navigationTitle: String

    @Published private(set) var movieRowVMs: [MovieRowViewModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasMorePages: Bool = false
    @Published private(set) var nextPageTitle: String = ""

    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    private let refreshMoviesUseCase: RefreshMoviesUseCaseProtocol
    private var currentPage: Int = 1

    init(fetchMoviesUseCase: FetchMoviesUseCaseProtocol,
         refreshMoviesUseCase: RefreshMoviesUseCaseProtocol,
         didTapSubject: PassthroughSubject<Int, Never>) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.refreshMoviesUseCase = refreshMoviesUseCase
        self.didTapSubject = didTapSubject
        navigationTitle = "Movies"
    }

    func onAppear() async {
        await loadMovies(page: currentPage)
    }

    func refresh() async {
        currentPage = 1
        await performAction { try await self.refreshMoviesUseCase.execute() }
    }

    func loadNextPage() async {
        currentPage += 1
        await loadMovies(page: currentPage)
    }

    // MARK: - Private

    private func loadMovies(page: Int) async {
        await performAction { try await self.fetchMoviesUseCase.execute(page: page) }
    }

    private func performAction(_ action: () async throws -> PaginatedMovies) async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await action()
            movieRowVMs = result.movies.map {
                MovieRowViewModel(movie: $0, didTapSubject: didTapSubject)
            }
            currentPage = result.currentPage
            hasMorePages = result.hasMorePages
            nextPageTitle = "Next Page: \(result.currentPage + 1) out of \(result.totalPages)"
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
