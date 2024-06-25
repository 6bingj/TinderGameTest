//
//  UIViewController+Motion.swift
//  BugReporting
//
//  Created by Dani Arnaout on 1/13/20.
//  Copyright © 2020 The Selling Company. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Public
    
	override open func becomeFirstResponder() -> Bool {
		return true
	}

	override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard BugReporting.shared.enabled == true else { return }
        guard WhereAmIRunning.shared.isRunningInAppStoreEnvironment() == false else { return }

		if motion == .motionShake {
			if let image = UIImage().captureScreenshot() {
				let controller = BugReportingViewController.make(image: image)
				let navigationController = UINavigationController(rootViewController: controller)
				navigationController.modalPresentationStyle = .overFullScreen
				self.present(navigationController, animated: true, completion: nil)
			}
		}
	}
}
