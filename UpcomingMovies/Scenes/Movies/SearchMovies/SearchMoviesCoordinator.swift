//
//  SearchMoviesCoordinator.swift
//  UpcomingMovies
//
//  Created by Alonso on 6/18/20.
//  Copyright © 2020 Alonso. All rights reserved.
//

import UIKit
import UpcomingMoviesDomain

class SearchMoviesCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SearchMoviesViewController.instantiate()
        
        let useCaseProvider = InjectionFactory.useCaseProvider()
        let viewModel = SearchMoviesViewModel(useCaseProvider: useCaseProvider)
        
        viewController.coordinator = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @discardableResult
    func embedSearchOptions(on parentViewController: UIViewController,
                            in containerView: UIView) -> SearchOptionsTableViewController {
        let viewController = SearchOptionsTableViewController.instantiate()
        
        let useCaseProvider = InjectionFactory.useCaseProvider()
        let viewModel = SearchOptionsViewModel(useCaseProvider: useCaseProvider)
        
        viewController.viewModel = viewModel
        
        parentViewController.add(asChildViewController: viewController,
                                 containerView: containerView)
        
        return viewController
    }
    
    @discardableResult
    func embedSearchController(with searchResultDelegate: SearchMoviesResultControllerDelegate?) -> DefaultSearchController {
        guard let viewController = navigationController.topViewController else { fatalError() }
        
        let useCaseProvider = InjectionFactory.useCaseProvider()
        let searchResultViewModel = SearchMoviesResultViewModel(useCaseProvider: useCaseProvider)
        let searchResultController = SearchMoviesResultController(viewModel: searchResultViewModel)
        
        let searchController = DefaultSearchController(searchResultsController: searchResultController)
        
        searchResultController.delegate = searchResultDelegate
        searchResultController.coordinator = self
        
        viewController.navigationItem.searchController = searchController
        viewController.definesPresentationContext = true
        
        return searchController
    }

    func showDetail(for movie: Movie) {
        let coordinator = MovieDetailCoordinator(navigationController: navigationController)
        coordinator.movieInfo = .complete(movie: movie)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showDetail(for movieId: Int, and movieTitle: String) {
        let coordinator = MovieDetailCoordinator(navigationController: navigationController)
        coordinator.movieInfo = .partial(movieId: movieId, movieTitle: movieTitle)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showPopularMovies() {
        let coordinator = PopularMoviesCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showTopRatedMovies() {
        let coordinator = TopRatedMoviesCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showMoviesByGenre(_ genreId: Int, genreName: String) {
        let coordinator = MoviesByGenreCoordinator(navigationController: navigationController)
        coordinator.genreId = genreId
        coordinator.genreName = genreName
        
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
