//
//  RandoDetailViewController.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit
import NetworkHandler

class RandoDetailViewController: UIViewController {

	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var emailButton: UIButton!
	@IBOutlet var phoneButton: UIButton!
	@IBOutlet var cellButton: UIButton!
	@IBOutlet var nameLabel: UILabel!

	var randomUserController: RandomUserController?
	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}
//	private var photoFetchOp: PhotoFetchOperation?
	private var photoFetchTask: URLSessionDataTask?

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
		for button in [phoneButton, cellButton, emailButton] {
			button?.roundCorners()
		}
	}

	private func updateViews() {
		photoFetchTask?.cancel()
		guard let user = user else { return }
		loadViewIfNeeded()
		navigationItem.title = user.fullNameWithTitle
		emailButton.setTitle(user.email, for: .normal)
		phoneButton.setTitle(user.phone, for: .normal)
		cellButton.setTitle(user.cell, for: .normal)
		nameLabel.text = user.fullName

		photoFetchTask = NetworkHandler.default.transferMahDatas(with: user.picture.large.request, usingCache: true, completion: { [weak self] (result: Result<Data, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let data = try result.get()
					self?.userImageView.image = UIImage(data: data)
				} catch {
					let alert = UIAlertController(error: error)
					self?.present(alert, animated: true)
				}
			}
		})

	}

	@IBAction func emailButtonPressed(_ sender: UIButton) {
		guard let emailString = sender.titleLabel?.text else { return }
		guard let url = URL(string: "mailto:\(emailString)") else {
			print("user has illegal characters in their email")
			return
		}
		print("(will open on actual device) opening email app via: \(url)")
		UIApplication.shared.open(url)
	}

	@IBAction func phoneButtonPressed(_ sender: UIButton) {
		guard let phoneString = sender.titleLabel?.text else { return }
		guard let url = URL(string: "tel://\(phoneString)") else { return }
		print("(will open on actual device) opening phone app to call via: \(url)")
		UIApplication.shared.open(url)
	}
}


extension UIButton {
	func roundCorners(radius: CGFloat = 10) {
		self.layer.cornerRadius = 10
	}
}
