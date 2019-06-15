//
//  RandoTableViewCell.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit
import NetworkHandler

class RandoTableViewCell: UITableViewCell {

	var randomUserController: RandomUserController?
	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}
//	private var imageFetchOp: PhotoFetchOperation?
	private var photoFetchTask: URLSessionDataTask?

	private func updateViews() {
		photoFetchTask?.cancel()
		resetToPlaceholderImage()
		guard let user = user else { return }
		textLabel?.text = user.fullName

		photoFetchTask = NetworkHandler.default.transferMahDatas(with: user.picture.medium.request, usingCache: true, completion: { [weak self] (result: Result<Data, NetworkError>) in
			DispatchQueue.main.async {
				do {
					let data = try result.get()
					self?.imageView?.image = UIImage(data: data)
				} catch {
					NSLog("Error loading image: \(user.picture.medium): \(error)")
				}
			}
		})
	}

	override func prepareForReuse() {
		resetToPlaceholderImage()
	}

	private func resetToPlaceholderImage() {
		imageView?.image = #imageLiteral(resourceName: "skate")
	}
}
