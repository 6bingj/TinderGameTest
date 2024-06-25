//
//  DrawnImageView.swift
//  Flyp
//
//  Created by Dani Arnaout on 1/13/20.
//  Copyright © 2020 The Selling Company. All rights reserved.
//

import UIKit

// https://stackoverflow.com/a/41009006/4488252
class DrawnImageView: UIImageView {
    
    // MARK: Properties
    
	private lazy var path = UIBezierPath()
	private lazy var previousTouchPoint = CGPoint.zero
	private lazy var shapeLayer = CAShapeLayer()
	private lazy var allShapeLayers: [CAShapeLayer] = []
	private lazy var color: CGColor = UIColor.systemPink.cgColor
	private lazy var allColors: [CGColor] = [UIColor.systemPink.cgColor, UIColor.systemBlue.cgColor, UIColor.white.cgColor, UIColor.black.cgColor]
	public var changedColor: ((UIColor) -> Void)?

    // MARK: Lifecycle
    
	override func awakeFromNib() {
		super.awakeFromNib()
		setupView()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

    // MARK: Gestures
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		if let location = touches.first?.location(in: self) { previousTouchPoint = location }
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		if let location = touches.first?.location(in: self) {
			path.move(to: location)
			path.addLine(to: previousTouchPoint)
			previousTouchPoint = location
			shapeLayer.path = path.cgPath
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		allShapeLayers.append(shapeLayer)
		setupView()
	}

    // MARK: Private
    
    private func setupView() {
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 4
        shapeLayer.strokeColor = color
        path = UIBezierPath()
        shapeLayer.path = nil
        previousTouchPoint = CGPoint.zero
        isUserInteractionEnabled = true
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: Public
    
	func changeColor() {
		let previousColor = allColors.removeFirst()
		allColors.append(previousColor)

		color = allColors.first!
		shapeLayer.strokeColor = color
		self.changedColor?(UIColor(cgColor: color))
	}

	func back() {
		allShapeLayers.last?.removeFromSuperlayer()
		if !allShapeLayers.isEmpty { allShapeLayers.removeLast() }
	}

	func reset() {
		path = UIBezierPath()
		shapeLayer.path = nil
		allShapeLayers.forEach { (sublayer) in
			sublayer.removeFromSuperlayer()
		}
		allShapeLayers = []
	}
}

// https://stackoverflow.com/a/40953026/4488252
extension UIView {
	var screenShot: UIImage? {
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
		if let context = UIGraphicsGetCurrentContext() {
			layer.render(in: context)
			let screenshot = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return screenshot
		}
		return nil
	}
}
