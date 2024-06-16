//
//  ScrabbleGameTests.swift
//  ScrabbleGameTests
//
//  Created by Илья on 13.06.2024.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import ScrabbleGame

extension CreateRoomView: Inspectable {}
extension ChooseRoomView: Inspectable {}
extension GameRoomView: Inspectable {}
extension GameRoomSettingsView: Inspectable {}

final class IntegrationTests: XCTestCase {

    func testCreateRoomButtonNavigation() throws {
        let view = CreateRoomView()
        let sut = try view.inspect()
        
        let button = try sut.find(button: "Создать комнату")
        XCTAssertEqual(try button.labelView().text().string(), "Создать комнату")
        
        try button.tap()
        
        XCTAssertTrue(try sut.navigationLink(0).isActive())
    }

//    func testChooseRoomView_CreateRoomNavigation() throws {
//        let view = ChooseRoomView()
//        let sut = try view.inspect()
//        
//        let button = try sut.find(button: "Создать комнату")
//        XCTAssertEqual(try button.labelView().text().string(), "Создать комнату")
//
//        try button.tap()
//        
//        XCTAssertTrue(try sut.navigationLink(0).isActive())
//    }

    func testChooseRoomView_JoinRoomAlert() throws {
        let view = ChooseRoomView()
        let sut = try view.inspect()

        let button = try sut.find(button: "Войти в комнату")
        XCTAssertEqual(try button.labelView().text().string(), "Войти в комнату")
        
        try button.tap()
        
        XCTAssertTrue(try sut.view(ChooseRoomView.self).actualView().viewModel.isJoinRoomAlertPresented)
    }

    func testGameRoomSettingsView_AdminControls() throws {
        let viewModel = RoomViewModel()
        let view = GameRoomSettingsView(viewModel: viewModel, roomId: UUID())
        let sut = try view.inspect()
        
        viewModel.userRole = "admin"
        
        let button = try sut.find(button: "Пауза")
        XCTAssertNoThrow(try button.tap())
        try button.tap()
        
        XCTAssertEqual(viewModel.roomStatus, "Pause")
    }
}
