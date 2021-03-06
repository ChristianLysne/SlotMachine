//
//  SlotColumnViewTests.swift
//  SlotMachine
//
//  Created by Christian Lysne on 26/06/16.
//  Copyright © 2016 Christian Lysne. All rights reserved.
//

import Foundation
import XCTest
@testable import SlotMachine

class SlotColumnViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitializeSlotColumnView() {
        let slotColumnView = SlotColumnView()
        XCTAssertNotNil(slotColumnView)
    }
    
    func testInitializeSlotColumnViewWithDecoder() {
        let coder = NSKeyedUnarchiver(forReadingWithData: NSMutableData())
        let slotColumnView = SlotColumnView(coder: coder)
        XCTAssertNotNil(slotColumnView)
    }
    
    func testConfigureSlotColumnView() {
        let fruitImageName = getFruitImageName()
        let slotElement = SlotElement(imageName: fruitImageName)
        let slotColumn = SlotColumn(slotElements: [slotElement, slotElement, slotElement], numberOfSlotElementsOnScreen: 3)
        
        let slotColumnViewModel = SlotColumnViewModel(slotColumn: slotColumn)
        let slotColumnView = SlotColumnView()
        
        slotColumnView.configureViewWithViewModel(slotColumnViewModel)
        
        XCTAssertTrue(slotColumnView.imageViews.count == slotColumnViewModel.numberOfSlotsOnScreen())
        XCTAssertTrue(slotColumnView.images == slotColumnViewModel.imagesForColumn())
    }
    
    func testConfigureSlotColumnViewWithWrongViewModel() {
        let viewModel = "Just a string"
        let slotColumnView = SlotColumnView()
        
        slotColumnView.configureViewWithViewModel(viewModel)
        
        XCTAssertTrue(slotColumnView.images.count == 0)
        XCTAssertTrue(slotColumnView.imageViews.count == 0)
    }
    
    func testUpdateViewWithSpinState() {
        let slotColumnView = SlotColumnView()
        
        XCTAssertTrue(slotColumnView.spinState == .ReadyToSpin)
        
        slotColumnView.spinState = .Spinning
        
        XCTAssertTrue(slotColumnView.spinState == .Spinning)
        
        slotColumnView.spinState = .Stop
        
        XCTAssertTrue(slotColumnView.spinState == .Stop)
        
        slotColumnView.spinState = .ReadyToSpin
        
        XCTAssertTrue(slotColumnView.spinState == .ReadyToSpin)
    }
    
    func testBlinkAnimation() {
        let fruitImageName = getFruitImageName()
        let slotElement = SlotElement(imageName: fruitImageName)
        let slotColumn = SlotColumn(slotElements: [slotElement, slotElement, slotElement], numberOfSlotElementsOnScreen: 3)
        
        let slotColumnViewModel = SlotColumnViewModel(slotColumn: slotColumn)
        let slotColumnView = SlotColumnView()
        
        slotColumnView.configureViewWithViewModel(slotColumnViewModel)
        
        slotColumnView.spinState = .ReadyToSpin
        
        XCTAssertTrue(slotColumnView.blinkAnimation())
        
        slotColumnView.spinState = .Spinning
        
        XCTAssertFalse(slotColumnView.blinkAnimation())
        
        slotColumnView.spinState = .ReadyToSpin
        
        slotColumnView.imageViews[0].image = nil
        slotColumnView.imageViews[1].image = nil
        slotColumnView.imageViews[2].image = nil
        
        XCTAssertFalse(slotColumnView.blinkAnimation())
    }
}