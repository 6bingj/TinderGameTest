//
//  BugReportingViewController.swift
//  Flyp
//
//  Created by Dani Arnaout on 1/13/20.
//  Copyright © 2020 The Selling Company. All rights reserved.
//

import UIKit

class BugReportingViewController: UIViewController {

	// MARK: Properties

	fileprivate var screenshotImage: UIImage?
	fileprivate let rest = RestManager()
	@IBOutlet var screenshotImageView: DrawnImageView!
	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet weak var colorImageView: UIImageView!
	@IBOutlet weak var textViewPlaceholder: UILabel!

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		screenshotImageView.image = screenshotImage

		screenshotImageView.changedColor = { color in
			self.colorImageView.backgroundColor = color
		}
	}

	// MARK: Actions

	@IBAction func didTapCancelButton(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func didTapColorButton(_ sender: Any) {
		screenshotImageView.changeColor()
	}

	@IBAction func didTapBackButton(_ sender: Any) {
		screenshotImageView.back()
	}

	@IBAction func didTapResetButton(_ sender: Any) {
		screenshotImageView.reset()
	}

	@IBAction func didTapSubmitButton(_ sender: Any) {
		//self.showShareSheet()
		self.shareOnTrello()
	}

	// MARK: Private

	fileprivate func showShareSheet() {
		let textToShare: String = descriptionTextView.text
		var objectsToShare = [textToShare] as [Any]
		if let image = screenshotImageView.screenShot {
			objectsToShare.append(image)
		}
		let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		activityVC.excludedActivityTypes = [UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.print, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.copyToPasteboard]
		activityVC.popoverPresentationController?.sourceView = self.view
		self.present(activityVC, animated: true, completion: nil)
	}

	fileprivate func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}

	fileprivate func getDeviceInfo() -> String {
		return """
Device Type: \(UIDevice.modelName.components(separatedBy: " "))
App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0")
iOS Version: \(UIDevice.current.systemVersion)
Language: \(Locale.current.languageCode ?? "")
Timezone: \(TimeZone.current.abbreviation() ?? "")
"""
	}

	fileprivate func shareOnTrello() {
		self.view.startLoading()

		if let image = screenshotImageView.screenShot {
			if let data = image.pngData() {
				let filename = getDocumentsDirectory().appendingPathComponent("image.png")
				try? data.write(to: filename)
				let fileInfo = RestManager.FileInfo(withFileURL: filename, filename: "image.png", name: "fileSource", mimetype: "text/plain")

				rest.httpBodyParameters.add(value: "f5e3cfd1d9351f1ba6455066546acde3", forKey: "key")
				rest.httpBodyParameters.add(value: "271ad62919d8c81f51b3d3b591545532c07a30fb60f658f631917a848a14216f", forKey: "token")
				rest.httpBodyParameters.add(value: "6175cd54e8dbbc4004046b9e", forKey: "idList")
				rest.httpBodyParameters.add(value: self.descriptionTextView.text!, forKey: "name")
				rest.httpBodyParameters.add(value: getDeviceInfo(), forKey: "desc")

				rest.upload(files: [fileInfo], toURL: URL(string: "https://api.trello.com/1/cards")!, withHttpMethod: .post) { (_, _) in
					DispatchQueue.main.async {
						self.view.stopLoading()
						self.dismiss(animated: true, completion: nil)
					}
				}
			}
		}
	}
}

extension UIView{

	func startLoading() {
		let backgroundView = UIView()
		backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
		backgroundView.backgroundColor = .black
		backgroundView.alpha = 0.3
		backgroundView.tag = 475647

		var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
		activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
		activityIndicator.center = self.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.style = .large
		activityIndicator.color = .white
		activityIndicator.startAnimating()
		self.isUserInteractionEnabled = false

		backgroundView.addSubview(activityIndicator)

		self.addSubview(backgroundView)
	}

	func stopLoading() {
		if let background = viewWithTag(475647){
			background.removeFromSuperview()
		}
		self.isUserInteractionEnabled = true
	}
}

extension BugReportingViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currentText = textView.text ?? ""
		guard let stringRange = Range(range, in: currentText) else { return false }
		let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
		textViewPlaceholder.isHidden = (updatedText.count > 0)
		return true
	}
}

extension BugReportingViewController {
	static func make(image: UIImage) -> BugReportingViewController {
		let podBundle = Bundle(for: BugReportingViewController.self)
		guard let controller = UIStoryboard(name: String(describing: BugReportingViewController.self), bundle: podBundle)
						.instantiateInitialViewController() as? BugReportingViewController else { fatalError(); }
		controller.screenshotImage = image
		return controller
	}
}
