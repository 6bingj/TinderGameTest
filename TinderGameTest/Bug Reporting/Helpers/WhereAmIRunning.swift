//
//  WhereAmIRunning.swift
//  Flyp
//
//  Created by Dani Arnaout on 1/14/20.
//  Copyright © 2020 The Selling Company. All rights reserved.
//

import Foundation

struct WhereAmIRunning {

	// MARK: Public
    
    static let shared: WhereAmIRunning = WhereAmIRunning()

	func isRunningInTestFlightEnvironment() -> Bool {
		if isSimulator() {
			return false
		} else {
			if isAppStoreReceiptSandbox() && !hasEmbeddedMobileProvision() {
				return true
			} else {
				return false
			}
		}
	}

	func isRunningInAppStoreEnvironment() -> Bool {
		if isSimulator() {
			return false
		} else {
			if isAppStoreReceiptSandbox() || hasEmbeddedMobileProvision() {
				return false
			} else {
				return true
			}
		}
	}
    
    func isRunningInSimulator() -> Bool {
        return isSimulator()
    }

	// MARK: Private

	private func hasEmbeddedMobileProvision() -> Bool {
		if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
			return true
		}
		return false
	}

	private func isAppStoreReceiptSandbox() -> Bool {
		if isSimulator() {
			return false
		} else {
			if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
				let appStoreReceiptLastComponent = appStoreReceiptURL.lastPathComponent
				if appStoreReceiptLastComponent == "sandboxReceipt" {
					return true
				}
			}
			return false
		}
	}

	private func isSimulator() -> Bool {
    #if (arch(i386) || targetEnvironment(simulator)) && os(iOS)
		return true
		#else
		return false
		#endif
	}

}
