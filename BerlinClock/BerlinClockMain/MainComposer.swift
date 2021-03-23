//
//  MainComposer.swift
//  BerlinClockMain
//
//  Created by ***REMOVED*** on 23/03/2021.
//

import Foundation
import BerlinClock
import BerlinClockUIKit
import UIKit

final class MainComposer {

    func start(using window: UIWindow) {

        let (schema, mapper) = configureColorHandling()

        let berlinClock = BerlinClock.create(colorSchema: schema)
        let interactor = BerlinClockViewModel(clock: berlinClock, colorMapper: mapper)

        guard let clockView = obtainClockView() else {
            fatalError("ViewController is not the expected")
        }

        clockView.connect(interactor: interactor)
        interactor.presenter = ThreadSafeAnimatedClockPresenter(otherPresenter: clockView)

        window.rootViewController = clockView
    }

    private func configureColorHandling() -> (ColorSchema, mapper: (String) -> CGColor) {
        let colors = (yellow: "Y", red: "R", off: "O")

        let colorMap: [String: CGColor] = [
            colors.yellow: CGColor(red: 245/255, green: 229/255, blue: 27/255, alpha: 1),
            colors.red: CGColor(red: 1, green: 0, blue: 0, alpha: 1),
            colors.off: CGColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        ]

        let colorSchema = ColorSchema(
            off: colors.off,
            seconds: colors.yellow,
            minutes: colors.yellow,
            minutesVisualAid: colors.red,
            hours: colors.red
        )

        let mapper: (String) -> CGColor = { colorRepresentation in
            let unexpectedStringColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
            return (colorMap[colorRepresentation] ?? unexpectedStringColor)
        }

        return (colorSchema, mapper)
    }

    private func obtainClockView() -> BerlinClockViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Clock") as? BerlinClockViewController
    }
}
