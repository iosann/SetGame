//
//  Card.swift
//  Set
//
//  Created by Anna Belousova on 03.06.2021.
//

import Foundation

struct Card {
	let type: TypeCard
	let quantity: Quantity
	let color: Color
	let filling: Filling

	enum TypeCard: String {
		case triangle = "△"
		case circle = "○"
		case square = "□"

		static let all = [TypeCard.triangle, .circle, .square]
	}

	enum Quantity: Int {
		case one = 1
		case two = 2
		case three = 3

		static let all = [Quantity.one, .two, .three]
	}

	enum Color {
		case red, green, violet

		static let all = [Color.red, .green, .violet]
	}

	enum Filling {
		case empty, shaded, paintedOver

		static let all = [Filling.empty, .shaded, .paintedOver]
	}
}
