//
//  MainComposer.swift
//  BerlinClockMain
//
//  Created by Hugo Alonso on 23/03/2021.
//

import Foundation
import BerlinClock
import BerlinClockUIKit
import UIKit

final class MainComposer {

    func start(using window: UIWindow) {
        let colors = (yellow: "Y", red: "R", off: "O")
        let colorMap: [String: RGBA] = [
            colors.yellow: RGBA(red: 245/255, green: 229/255, blue: 27/255),
            colors.red: RGBA(red: 1, green: 0, blue: 0),
            colors.off: RGBA(red: 0, green: 0, blue: 0, alpha: 0.65)
        ]
        let berlinClock = BerlinClock.create(
            colorSchema: ColorSchema(
                off: colors.off,
                seconds: colors.yellow,
                minutes: colors.yellow,
                minutesVisualAid: colors.red,
                hours: colors.red
            )
        )

        let interactor = BerlinClockViewModel(clock: berlinClock) { colorRepresentation in
            let unexpectedStringColor = RGBA(red: 0, green: 0, blue: 0)
            return (colorMap[colorRepresentation] ?? unexpectedStringColor)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clockView = storyboard.instantiateViewController(withIdentifier: "Clock") as? BerlinClockViewController else {
            fatalError("ViewController is not the expected")
        }
        clockView.connect(interactor: interactor)
        interactor.presenter = ThreadSafeAnimatedClockPresenter(otherPresenter: clockView)

        window.rootViewController = clockView
    }
}
