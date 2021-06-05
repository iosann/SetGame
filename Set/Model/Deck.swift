//
//  Deck.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import UIKit

struct Deck {

	private(set) var cards = [Card]()

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
}
