//
//  CogwheelTests.swift
//  CogwheelTests
//
//  Created by Artem on 17.10.2024.
//

import XCTest
@testable import Cogwheel

final class CogwheelModuleTests: XCTestCase {

    class MockView: CogwheelViewControllerProtocol {
        var lastError: CogwheelError? = nil
        var lastSuccessImage: UIImage? = nil
        var lastParameters: CogwheelParameters? = nil
        
        func setParameters(_ parameters: CogwheelParameters) {
            lastParameters = parameters
        }
        
        func redrawCogwheel(_ image: UIImage?) {
            lastSuccessImage = image
        }
        
        func showAlert(_ error: CogwheelError) {
            lastError = error
        }
    }
    
    let view = MockView()
    var presenter: CogwheelPresenter? = nil
    let successParameter = CogwheelParameters(linkRadius: 10, innerRadius: 150, outerRadius: 180, numberOfTeeth: 10)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        presenter = CogwheelPresenter(with: view)
    }

    override func tearDownWithError() throws {
        presenter = nil
        try super.tearDownWithError()
    }

    func testIncorrectTeeths() throws {
        presenter?.updateCogwheel(.init(linkRadius: 10, innerRadius: 150, outerRadius: 180, numberOfTeeth: 3))
        XCTAssert(view.lastError == .incorrectTeeth)
    }
    
    
    func testSuccess() throws {
        presenter?.updateCogwheel(successParameter)
        XCTAssertNotNil (view.lastSuccessImage)
    }
    
    func testIncorrectInnerRadius() throws {
        presenter?.updateCogwheel(successParameter)
        XCTAssertNotNil (view.lastSuccessImage)
        presenter?.updateCogwheel(.init(linkRadius: 10, innerRadius: 150, outerRadius: 150, numberOfTeeth: 10))
        XCTAssert(view.lastError == .incorrectInnerRadius)
        XCTAssert(view.lastParameters == successParameter)
        presenter?.updateCogwheel(.init(linkRadius: 10, innerRadius: 150, outerRadius: 149, numberOfTeeth: 10))
        XCTAssert(view.lastError == .incorrectInnerRadius)
        XCTAssert(view.lastParameters == successParameter)
    }

    func testWheelDasntExist() throws {
        presenter?.updateCogwheel(successParameter)
        XCTAssertNotNil (view.lastSuccessImage)
        presenter?.updateCogwheel(.init(linkRadius: 25, innerRadius: 150, outerRadius: 180, numberOfTeeth: 20))
        XCTAssert(view.lastError == .wheelDoestExist)
        XCTAssert(view.lastParameters == successParameter)
        presenter?.updateCogwheel(.init(linkRadius: 27, innerRadius: 150, outerRadius: 180, numberOfTeeth: 15))
        XCTAssert(view.lastError == .wheelDoestExist)
        XCTAssert(view.lastParameters == successParameter)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure(
            metrics: [
              XCTClockMetric(),
              XCTCPUMetric(),
              XCTStorageMetric(),
              XCTMemoryMetric()
            ]
          )  {
            presenter?.updateCogwheel(successParameter)
        }
    }

}
