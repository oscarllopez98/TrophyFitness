//
//  ExerciseAPIManagerTests.swift
//  TrophyFitnessTests
//
//  Created by Oscar Lopez on 1/6/25.
//

import XCTest
@testable import TrophyFitness

final class ExerciseAPIManagerTests: XCTestCase {
    
    // Base URL for tests

    var baseURL: String!

    override func setUp() {
        super.setUp()

        // Access the BASE_URL_TEST from Info.plist
        baseURL = Bundle(for: type(of: self)).object(forInfoDictionaryKey: "BASE_URL_TEST") as? String

        XCTAssertNotNil(baseURL, "BASE_URL_TEST should not be nil. Check your Info.plist file.")
    }

    func testBaseURLInTests() {
        XCTAssertNotNil(baseURL, "BASE_URL_TEST should not be nil. Check your Info.plist file.")
    }

    func testCreateExercise_Success() {
        let expectation = self.expectation(description: "Create exercise successfully")

        // Assuming you have a valid ExerciseAPIManager setup
        let exercise = CreateExerciseRequestModel(name: "Push-Up", category: "Strength", sets: 3, reps: 12, duration: nil)
        
        ExerciseAPIManager.shared.createExercise(exercise) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error.message)")
            }
        }

        waitForExpectations(timeout: 10)
    }
}
