//
//  ViewController.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit

class SetViewController: UIViewController {

	
	@IBOutlet var cardButtons: [UIButton]!
	@IBOutlet var deal3Button: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		customizeUI()
	}

	func customizeUI() {
		for button in cardButtons {
			button.layer.cornerRadius = Constants.cardCornerRadius
		}
		deal3Button.layer.cornerRadius = Constants.cardCornerRadius
	}

	@IBAction func cardTapped(_ sender: UIButton) {
	}
	
	@IBAction func deal3MoreCardsTapped(_ sender: UIButton) {
	}
}

