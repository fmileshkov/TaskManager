//
//  UIViewController+Storyboard.swift
//  Buddyger
//
//  Created by Filip Mileshkov on 6.12.24.
//

import UIKit

extension UIViewController {
    
    /// instanciateFromStoryBoard
    /// - Parameter name: Name of the storyboard
    /// - Returns: Storyboard
    static func initFromStoryBoard(_ storyBoardName: String = "Main") -> Self? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let controller =
        storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return controller as? Self
    }

}
