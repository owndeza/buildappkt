import XCTest

final class ActivityLifecycleReducerTests: XCTestCase {
    func testRestoreFindsExistingActivity() {
        XCTAssertEqual(
            ActivityLifecycleReducer.restored(hasActivity: true, authorizationEnabled: true),
            .active
        )
    }

    func testRestoreReportsUnsupportedWhenDisabled() {
        XCTAssertEqual(
            ActivityLifecycleReducer.restored(hasActivity: false, authorizationEnabled: false),
            .unsupported
        )
    }

    func testDuplicateStartIsPrevented() {
        XCTAssertFalse(ActivityLifecycleReducer.canStart(from: .active, hasActivity: true))
        XCTAssertFalse(ActivityLifecycleReducer.canStart(from: .starting, hasActivity: false))
    }

    func testStartAllowedAfterEnd() {
        XCTAssertTrue(ActivityLifecycleReducer.canStart(from: .ended, hasActivity: false))
        XCTAssertTrue(ActivityLifecycleReducer.canStart(from: .error, hasActivity: false))
    }
}

