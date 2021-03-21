//
//  BerlinClockTests.swift
//  BerlinClockTests
//
//  Created by Hugo Alonso on 21/03/2021.
//

import XCTest
@testable import BerlinClock

protocol BerlinClockRepresentation {
    func singleMinuteRow(for date: Date) -> String
    func fiveMinuteRow(for date: Date) -> String
}

final class BerlinClock {

    let calendar: Calendar

    init(calendar: Calendar = .init(identifier: .gregorian)) {
        self.calendar = calendar
    }

    private func fiveMinuteRow(for date: Date) -> [Bool] {
        let minute = calendar.component(.minute, from: date)
        return fiveMinuteRow(for: minute)
    }

    private func fiveMinuteRow(for minute: Int) -> [Bool] {
        let amountOfLights = 11
        let iluminated = minute / 5

        let onLights = Array(repeating: true, count: iluminated)
        let offLights = Array(repeating: false, count: amountOfLights - iluminated)

        return onLights + offLights
    }

    private func singleMinuteRow(for date: Date) -> [Bool] {
        let minute = calendar.component(.minute, from: date)
        return singleMinuteRow(for: minute)
    }

    private func singleMinuteRow(for minute: Int) -> [Bool] {
        let amountOfLights = 4
        let iluminated = minute % 5

        let onLights = Array(repeating: true, count: iluminated)
        let offLights = Array(repeating: false, count: amountOfLights - iluminated)

        return onLights + offLights
    }
}

extension BerlinClock: BerlinClockRepresentation {
    func singleMinuteRow(for date: Date) -> String {
        singleMinuteRow(for: date).map { $0 ? "Y" : "0" }.joined()
    }

    func fiveMinuteRow(for date: Date) -> String {
        fiveMinuteRow(for: date)
            .map { $0 ? "Y" : "0" }
            .joined()
            .replacingOccurrences(of: "YYY", with: "YYR")
    }
}

final class BerlinClockTests: XCTestCase {

    // MARK: - Single Minutes Row
    
    func test_singleMinuteRow_returnsExpectedOutput() {
        assertSingleMinuteRow(every5MinutesAfter: 0, returns: "0000")
        assertSingleMinuteRow(every5MinutesAfter: 1, returns: "Y000")
        assertSingleMinuteRow(every5MinutesAfter: 2, returns: "YY00")
        assertSingleMinuteRow(every5MinutesAfter: 3, returns: "YYY0")
        assertSingleMinuteRow(every5MinutesAfter: 4, returns: "YYYY")
    }

    // MARK: - Five Minutes Row

    func test_fiveMinuteRow_returnsExpectedOutput() {
        assertFiveMinuteRow(inTheNext4minutesAfter: 00, returns: "00000000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 05, returns: "Y0000000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 10, returns: "YY000000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 15, returns: "YYR00000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 20, returns: "YYRY0000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 25, returns: "YYRYY000000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 30, returns: "YYRYYR00000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 35, returns: "YYRYYRY0000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 40, returns: "YYRYYRYY000")
        assertFiveMinuteRow(inTheNext4minutesAfter: 45, returns: "YYRYYRYYR00")
        assertFiveMinuteRow(inTheNext4minutesAfter: 50, returns: "YYRYYRYYRY0")
        assertFiveMinuteRow(inTheNext4minutesAfter: 55, returns: "YYRYYRYYRYY")
    }
}

//MARK - Helpers
extension BerlinClockTests {

    func createSut(minute: Int, originalDate: Date = Date()) -> (BerlinClockRepresentation, Date) {
        let calendar = Calendar.init(identifier: .gregorian)
        let sut = BerlinClock(calendar: calendar)

        let time = calendar.date(bySettingHour: 0, minute: minute, second: 0, of: originalDate)!

        return (sut, time)
    }

}
