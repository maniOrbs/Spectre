import XCTest
@testable import Spectre

final class SpectreTests: XCTestCase {
    
    func testSpectre() {
        describe("Failure", testFailure)
        describe("Expectation", testExpectation)
    }
}
