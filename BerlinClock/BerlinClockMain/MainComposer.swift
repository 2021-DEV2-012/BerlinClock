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
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let berlinClock = BerlinClock.create()
        let interactor = BerlinClockViewModel(clock: berlinClock)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clock = storyboard.instantiateViewController(withIdentifier: "Clock") as? BerlinClockViewController else {
            fatalError("ViewController is not the expected")
        }

        clock.connect(interactor: interactor)
        interactor.presenter = clock

        window.rootViewController = clock
    }
}