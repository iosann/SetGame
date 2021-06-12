//
//  ViewController.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit
import Lottie

class SetViewController: UIViewController {

	
	@IBOutlet private var cardButtons: [UIButton]!
	@IBOutlet private var deal3Button: UIButton!
	private var deck = Deck()
	private var cardsOnScreen = [Card]()
	private var cardsAreMatched = false
	private var buttonsAreSelectedArray = [UIButton]()
	private let successAnimation = AnimationView(name: "success-animation")
	private let failAnimation = AnimationView(name: "fail-animation")
	private let darkenedBackground = UIView()
	private var verticalSpacing: CGFloat {
		let cardsSortedByQuantity = cardsOnScreen.sorted { (a, b) -> Bool in
			a.quantity.rawValue > b.quantity.rawValue
		}
		guard let maxQuantity = cardsSortedByQuantity.first?.quantity.rawValue else { return 3 }
		return cardButtons[0].bounds.insetBy(dx: 0, dy: Constants.verticalOffsetInsideButton).size.height / CGFloat(maxQuantity)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cardsOnScreen = deck.dealInitialCards()
		customizeUI()
		addAnimation()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		successAnimation.frame = view.bounds.size.width < view.bounds.size.height
								 ? CGRect(x: 0, y: 0, width: view.bounds.size.width/2, height: view.bounds.size.width/2)
								 : CGRect(x: 0, y: 0, width: view.bounds.size.height/2, height: view.bounds.size.height/2)
		successAnimation.center = view.center
		successAnimation.contentMode = .scaleAspectFit
		failAnimation.frame = view.bounds.size.width < view.bounds.size.height
								 ? CGRect(x: 0, y: 0, width: view.bounds.size.width/2, height: view.bounds.size.width/2)
								 : CGRect(x: 0, y: 0, width: view.bounds.size.height/2, height: view.bounds.size.height/2)
		failAnimation.center = view.center
		failAnimation.contentMode = .scaleAspectFit
	}

	private func customizeUI() {
		for button in cardButtons {
			button.layer.cornerRadius = Constants.cornerRadius
			button.titleLabel?.numberOfLines = 0
			buttonIsDeselectedUI(button)
		}
		for (index, button) in cardButtons.enumerated() {
			if index > 11 {
				button.isHidden = true
			} else {
				cardButtons[index].setAttributedTitle(createTitle(from: cardsOnScreen[index]), for: .normal)
			}
		}
		deal3Button.layer.cornerRadius = Constants.cornerRadius
		deal3Button.layer.borderWidth = Constants.borderWidth
		deal3Button.layer.borderColor = Constants.borderColor
	}

	private func buttonIsSelectedUI(_ sender: UIButton) {
		sender.layer.borderWidth = Constants.borderWidthButtonIsSelected
		sender.layer.borderColor = Constants.borderColorButtonIsSelected
		sender.backgroundColor = Constants.backgroundColorButtonIsSelected
	}

	private func buttonIsDeselectedUI(_ sender: UIButton) {
		sender.layer.borderWidth = Constants.borderWidth
		sender.layer.borderColor = Constants.borderColor
		sender.backgroundColor = .white
	}

	private func createTitle(from card: Card) -> NSAttributedString {

		func createStringWithBreaks(from card: Card) -> String {
			switch card.quantity {
			case .one:
				return card.type.rawValue
			case .two:
				return card.type.rawValue + "\n" + card.type.rawValue
			case .three:
				return card.type.rawValue + "\n" + card.type.rawValue + "\n" + card.type.rawValue
			}
		}

		let attemptedString = createAttributedString(string: card.type.rawValue, fontSize: verticalSpacing, card: card)
		let probablyOkayStringFontSize = verticalSpacing / (attemptedString.size().height / verticalSpacing)
		let probablyOkayString = createAttributedString(string: createStringWithBreaks(from: card), fontSize: probablyOkayStringFontSize, card: card)
		return probablyOkayString
	}

	private func createAttributedString(string: String, fontSize: CGFloat, card: Card) -> NSAttributedString {
		let color: UIColor
		let strokeWidth: CGFloat
		var strokeColor: UIColor? = nil
		switch card.shading {
		case .shadingOne:
			color = UIColor(hex: card.color.rawValue) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = -6.0
		case .shadingTwo:
			color = UIColor(hex: card.color.rawValue)?.withAlphaComponent(0.15) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = -4.0
			strokeColor = UIColor(hex: card.color.rawValue)
		case .shadingThree:
			color = UIColor(hex: card.color.rawValue) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			strokeWidth = 6.0
		}
		var font = UIFont.systemFont(ofSize: fontSize)
		font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
		return NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color, .strokeWidth: strokeWidth, .strokeColor: strokeColor as Any])
	}

	private func addAnimation() {
		view.addSubview(darkenedBackground)
		darkenedBackground.frame = view.bounds
		darkenedBackground.isHidden = true
		darkenedBackground.addSubview(successAnimation)
		darkenedBackground.addSubview(failAnimation)
	}

	@IBAction private func cardTapped(_ sender: UIButton) {
		if !buttonsAreSelectedArray.contains(sender), buttonsAreSelectedArray.count < 3 {
			buttonsAreSelectedArray.append(sender)
		} else if !buttonsAreSelectedArray.contains(sender), buttonsAreSelectedArray.count == 3 {
			buttonsAreSelectedArray.forEach { buttonIsDeselectedUI($0) }
			buttonsAreSelectedArray = []
			buttonsAreSelectedArray.append(sender)
		} else if buttonsAreSelectedArray.contains(sender), buttonsAreSelectedArray.count == 3 {
			buttonsAreSelectedArray.forEach { buttonIsDeselectedUI($0) }
			buttonsAreSelectedArray = []
		} else {
			guard let index = buttonsAreSelectedArray.firstIndex(of: sender) else { return }
			buttonsAreSelectedArray.remove(at: index)
		}
		if buttonsAreSelectedArray.contains(sender) { buttonIsSelectedUI(sender) }
		else { buttonIsDeselectedUI(sender)	}

		if buttonsAreSelectedArray.count == 3 {
			var cards = [Card]()
			for button in buttonsAreSelectedArray {
				for (index, cardButton) in cardButtons.enumerated() where cardButton == button {
					cards.append(cardsOnScreen[index])
				}
			}
			cardsAreMatched = deck.threeCardsAreSelected(cards)

			darkenedBackground.isHidden = false
			if cardsAreMatched == true {
				darkenedBackground.backgroundColor = UIColor.green.withAlphaComponent(0.1)
				successAnimation.play()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
					successAnimation.stop()
					darkenedBackground.isHidden = true
				}
			} else {
				darkenedBackground.backgroundColor = UIColor.red.withAlphaComponent(0.1)
				failAnimation.play()
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
					failAnimation.stop()
					darkenedBackground.isHidden = true
				}
			}
		}
	}

	@IBAction private func deal3MoreCardsTapped(_ sender: UIButton) {
		if deck.isEmpty == true, buttonsAreSelectedArray.count == 3, cardsAreMatched == true {
			buttonsAreSelectedArray.forEach { $0.isHidden = true; buttonIsDeselectedUI($0) }
			buttonsAreSelectedArray = []
			cardsAreMatched = false
		}

		let newCards = deck.dealThreeCards()
		if buttonsAreSelectedArray.count == 3, cardsAreMatched == true {
			for (button, card) in zip(buttonsAreSelectedArray, newCards) {
				for (index, cardButton) in cardButtons.enumerated() where cardButton == button {
					button.setAttributedTitle(createTitle(from: card), for: .normal)
					cardsOnScreen[index] = card
				}
			}
		} else {
			var indicesOfHiddenButtons = [Int]()
			for (index, button) in cardButtons.enumerated() where button.isHidden == true {
				indicesOfHiddenButtons.append(index)
			}
			for (index, card) in zip(Array(indicesOfHiddenButtons.prefix(3)), newCards) {
				cardButtons[index].setAttributedTitle(createTitle(from: card), for: .normal)
				cardButtons[index].isHidden = false
				cardsOnScreen.insert(card, at: index)
			}
		}
		buttonsAreSelectedArray.forEach { buttonIsDeselectedUI($0) }
		buttonsAreSelectedArray = []
		cardsAreMatched = false
	}
}

