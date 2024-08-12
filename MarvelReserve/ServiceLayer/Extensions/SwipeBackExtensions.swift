//
//  SwipeBackExtensions.swift
//  MarvelReserve
//
//  Created by Shoxrux Khodjaev on 10/07/24.
//

import SwiftUI

class AppState {
    static let shared = AppState()

    var swipeEnabled = false
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if AppState.shared.swipeEnabled {
            return viewControllers.count > 1
        }
        return false
    }
    
}
