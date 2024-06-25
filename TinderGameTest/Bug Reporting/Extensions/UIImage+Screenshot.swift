//
//  UIImage+Screenshot.swift
//  Flyp
//
//  Created by Dani Arnaout on 1/13/20.
//  Copyright © 2020 The Selling Company. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: Public
    
	func captureScreenshot() -> UIImage? {
		var screenshotImage: UIImage?
////		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
//        guard let keyWindow = UIApplication.shared.currentUIWindow() else {return nil}
//		let layer = keyWindow.layer
//		let scale = UIScreen.main.scale
//		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
//		guard let context = UIGraphicsGetCurrentContext() else { return nil }
//		layer.render(in: context)
//		screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
//		UIGraphicsEndImageContext()
		return screenshotImage
	}
}
