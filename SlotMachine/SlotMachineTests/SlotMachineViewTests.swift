//
//  SlotMachineViewTests.swift
//  SlotMachine
//
//  Created by Christian Lysne on 26/06/16.
//  Copyright © 2016 Christian Lysne. All rights reserved.
//

import Foundation
import XCTest
@testable import SlotMachine

class SlotMachineViewTests: XCTestCase {
    
    let numberOfSlotElementsOnScreen = 2
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializeSlotMachineView() {
        let slotMachineView = SlotMachineView(frame: CGRectZero)
        XCTAssertNotNil(slotMachineView)
    }
    
    func testInitializeSlotMachineViewWithDecoder() {
        let coder = NSKeyedUnarchiver(forReadingWithData: NSMutableData())
        let slotMachineView = SlotMachineView(coder: coder)
        XCTAssertNotNil(slotMachineView)
    }
    
    func testConfigureSlotMachineView() {
        let fruitImageName = getFruitImageName()
        let slotElement = SlotElement(imageName: fruitImageName)
        let slotColumn = SlotColumn(slotElements: [slotElement],
                                    numberOfSlotElementsOnScreen: numberOfSlotElementsOnScreen)
        let slotMachine = SlotMachine(slotColumns: [slotColumn])
        
        let slotMachineViewModel = SlotMachineViewModel(slotMachine: slotMachine)
        let slotMachineView = SlotMachineView()
        
        XCTAssertTrue(slotMachineView.slotColumnViews.first?.images.count == 0)
        
        slotMachineView.configureViewWithViewModel(slotMachineViewModel)
        
        XCTAssertTrue(slotMachineView.slotColumnViews.first?.images.count == 1)
    }
    
    func testConfigureSlotMachineViewWithWrongViewModel() {
        let viewModel = "Just a string"
        let slotMachineView = SlotMachineView()
        
        XCTAssertTrue(slotMachineView.slotColumnViews.first?.images.count == 0)
        
        slotMachineView.configureViewWithViewModel(viewModel)
        
        XCTAssertTrue(slotMachineView.slotColumnViews.first?.images.count == 0)
    }
    
    func testSlotMachineDelegate() {
        let slotMachineView = SlotMachineView()
        
        let slotMachineDelegateMock = SlotMachineDelegateMock()
        slotMachineView.slotMachineDelegate = slotMachineDelegateMock
        
        XCTAssertFalse(slotMachineDelegateMock.newSpinResultCalled)
        XCTAssertFalse(slotMachineDelegateMock.prizeWonWithImageCalled)
        
        let image = UIImage(named: "Apple")!
        slotMachineView.stoppedOnImage(image, itemName: "Apple", columnIndex: 0)
        slotMachineView.stoppedOnImage(image, itemName: "Apple", columnIndex: 1)
        slotMachineView.stoppedOnImage(image, itemName: "Apple", columnIndex: 2)
        
        XCTAssertTrue(slotMachineDelegateMock.newSpinResultCalled)
        XCTAssertTrue(slotMachineDelegateMock.prizeWonWithImageCalled)
    }
}

class SlotMachineDelegateMock: SlotMachineDelegate {
    var newSpinResultCalled = false
    var prizeWonWithImageCalled = false
    
    func newSpinResult(spinResult: SpinResult) {
        newSpinResultCalled = true
    }
    
    func prizeWonWithImage(image: UIImage, itemName: String) {
        prizeWonWithImageCalled = true
    }
}