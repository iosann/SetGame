//
//  Deck.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit

struct Deck {

	private(set) var cards = [Card]()
	var isEmpty: Bool {
		return cards.count >= 3 ? false : true
	}
	private enum Points: Int {
		case bonus = 10
		case fine = -10
	}
	private(set) var score = 0

	init() {
		for type in Card.TypeCard.all {
			for quantity in Card.Quantity.all {
				for color in Card.Color.all {
					for shading in Card.Shading.all {
						cards.append(Card(type: type, quantity: quantity, color: color, shading: shading))
					}
				}
			}
		}
		cards.shuffle()
	}

	mutating func dealInitialCards() -> [Card] {
		let initialCards = Array(cards.prefix(12))
		cards.removeFirst(12)
		return initialCards
	}

	mutating func dealThreeCards() -> [Card] {
		guard isEmpty == false else { return [] }
			let threeMoreCards = Array(cards.prefix(3))
			cards.removeFirst(3)
			return threeMoreCards
	}

	mutating func threeCardsAreSelected(_ cards: [Card]) -> Bool {
		var threeCardsAreMatched = false
		if cards.count == 3 {
			let types = Set([cards[0].type, cards[1].type, cards[2].type]).count
			let quantyties = Set([cards[0].quantity, cards[1].quantity, cards[2].quantity]).count
			let colors = Set([cards[0].color, cards[1].color, cards[2].color]).count
			let shadings = Set([cards[0].shading, cards[1].shading, cards[2].shading]).count
			let setIsSelected: Set<Int> = [types, quantyties, colors, shadings]

			let rightSet: Set<Set> = [[1, 1, 1, 3], [1, 1, 3, 3], [1, 3, 3, 3], [3, 3, 3, 3]]
			threeCardsAreMatched = rightSet.contains(setIsSelected)
			score += threeCardsAreMatched ? Points.bonus.rawValue : Points.fine.rawValue
		}
		return threeCardsAreMatched
	}
}
