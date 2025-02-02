//
//  MovieReviewsTests.swift
//  UpcomingMoviesTests
//
//  Created by Alonso on 2/26/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import XCTest
@testable import UpcomingMovies
@testable import UpcomingMoviesDomain
@testable import UpcomingMoviesData
@testable import NetworkInfrastructure

class MovieReviewsTests: XCTestCase {

    private var mockInteractor: MockMovieReviewsInteractor!
    private var viewModelToTest: MovieReviewsViewModelProtocol!

    override func setUp() {
        super.setUp()
        mockInteractor = MockMovieReviewsInteractor()
        viewModelToTest = MovieReviewsViewModel(movieId: 1, movieTitle: "Movie 1",
                                                interactor: mockInteractor)
    }

    override func tearDown() {
        mockInteractor = nil
        viewModelToTest = nil
        super.tearDown()
    }

    func testMovieReviewsTitle() {
        //Act
        let title = viewModelToTest.movieTitle
        //Assert
        XCTAssertEqual(title, "Movie 1")
    }

    func testGetReviewsEmpty() {
        //Arrange
        mockInteractor.getMovieReviewsResult = Result.success([])
        //Act
        viewModelToTest.getMovieReviews()
        //Assert
        XCTAssertEqual(viewModelToTest.viewState.value, .empty)
    }

    func testGetReviewsPopulated() {
        //Arrange
        mockInteractor.getMovieReviewsResult = Result.success([Review.with(id: "1"), Review.with(id: "2")])
        //Act
        viewModelToTest.getMovieReviews()
        mockInteractor.getMovieReviewsResult = Result.success([])
        viewModelToTest.getMovieReviews()
        //Assert
        XCTAssertEqual(viewModelToTest.viewState.value, .populated([Review.with(id: "1"), Review.with(id: "2")]))
    }

    func testGetReviewsPaging() {
        //Arrange
        mockInteractor.getMovieReviewsResult = Result.success([Review.with(id: "1"), Review.with(id: "2")])
        //Act
        viewModelToTest.getMovieReviews()
        //Assert
        XCTAssertEqual(viewModelToTest.viewState.value, .paging([Review.with(id: "1"), Review.with(id: "2")], next: 2))
    }

    func testGetReviewsError() {
        //Arrange
        mockInteractor.getMovieReviewsResult = Result.failure(APIError.badRequest)
        //Act
        viewModelToTest.getMovieReviews()
        //Assert
        XCTAssertEqual(viewModelToTest.viewState.value, .error(APIError.badRequest))
    }

    func testMovieReviewCellAuthorName() {
        // Arrange
        let reviewAuthorNametoTest = "Alonso"
        let cellViewModel = MovieReviewCellViewModel(Review.with(authorName: reviewAuthorNametoTest))
        // Act
        let authorName = cellViewModel.authorName
        // Assert
        XCTAssertEqual(authorName, reviewAuthorNametoTest)
    }

    func testMovieReviewCellContent() {
        // Arrange
        let reviewContenttoTest = "Review content"
        let cellViewModel = MovieReviewCellViewModel(Review.with(content: reviewContenttoTest))
        // Act
        let content = cellViewModel.content
        // Assert
        XCTAssertEqual(content, reviewContenttoTest)
    }

}
