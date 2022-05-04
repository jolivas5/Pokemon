//
//

import XCTest

class WW_Exercise_01UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testSearchForFoodListItem() {
        let app = XCUIApplication()
        XCUIApplication().navigationBars["WW_Exercise_01.LTKListView"].searchFields["Search LTK"].tap()

        func reset() {
            XCUIApplication().navigationBars["WW_Exercise_01.LTKListView"].searchFields["Search LTK"].doubleTap()
            app.keys["delete"].tap()
        }

        XCUIApplication().navigationBars["WW_Exercise_01.LTKListView"].searchFields["Search LTK"].typeText("DI")
        XCTAssertEqual(app.collectionViews.cells.count, 2)
        reset()

        XCUIApplication().navigationBars["WW_Exercise_01.LTKListView"].searchFields["Search LTK"].typeText("AMAZON")
        XCTAssertEqual(app.collectionViews.cells.count, 6)
        reset()
    }
}
