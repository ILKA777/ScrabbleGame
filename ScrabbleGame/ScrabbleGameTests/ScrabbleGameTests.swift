//
//  ScrabbleGameTests.swift
//  ScrabbleGameTests
//
//  Created by Илья on 13.06.2024.
//

import XCTest

final class ScrabbleGameTests: XCTestCase {

    func testChooseRoomView_to_GameRoomView() {
        let app = XCUIApplication()
        app.launch()
        
        // Открыть ChooseRoomView
        app.buttons["Войти в комнату"].tap()
        
        // Ввести корректный ID комнаты
        let roomIDTextField = app.textFields["ID комнаты"]
        roomIDTextField.tap()
        roomIDTextField.typeText("correct-room-id") // замените "correct-room-id" на корректный ID
        
        // Нажать кнопку "Войти"
        app.buttons["Войти"].tap()
        
        // Проверить, что мы перешли на GameRoomView
        XCTAssertTrue(app.staticTexts["Игровая комната"].exists)
    }

    func testCreateRoomView_display() {
        let app = XCUIApplication()
        app.launch()
        
        // Открыть CreateRoomView
        app.buttons["Создать комнату"].tap()
        
        // Проверить, что CreateRoomView отображается
        XCTAssertTrue(app.staticTexts["Create Room"].exists) // замените "Create Room" на соответствующий текст в CreateRoomView
    }

    func testGameRoomView_to_MainView() {
        let app = XCUIApplication()
        app.launch()
        
        // Предположим, что мы уже находимся на GameRoomView
        // Нажать кнопку для перехода на MainView
        app.navigationBars["Игровая комната"].buttons["line.horizontal.3"].tap()
        
        // Проверить, что мы перешли на MainView
        XCTAssertTrue(app.staticTexts["Game Room"].exists)
    }

    func testPauseButton_on_MainView() {
        let app = XCUIApplication()
        app.launch()
        
        // Предположим, что мы уже находимся на MainView
        // Нажать кнопку паузы
        app.buttons["Пауза"].tap()
        
        // Проверить, что действие выполнено (например, появление алерта или изменения состояния)
        // Это зависит от конкретной логики вашего приложения
    }

    func testRemoveUser_from_MainView() {
        let app = XCUIApplication()
        app.launch()
        
        // Предположим, что мы уже находимся на MainView
        // Предположим, что есть хотя бы один пользователь в списке
        let firstUserCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstUserCell.exists)
        
        // Нажать кнопку удаления для первого пользователя
        firstUserCell.buttons["Remove"].tap() // Замените "Remove" на точное название кнопки
        
        // Проверить, что пользователь удален (например, количество ячеек уменьшилось)
        XCTAssertEqual(app.cells.count, expectedCountAfterRemoval) // замените expectedCountAfterRemoval на ожидаемое значение
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
