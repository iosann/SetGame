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
	let shading: Shading

	enum TypeCard: String {
		case shapeOne = "▲"
		case shapeTwo = "●"
		case shapeThree = "■"

		static let all = [TypeCard.shapeOne, .shapeTwo, .shapeThree]
	}

	enum Quantity: Int, CaseIterable {
		case one = 1, two, three

		static let all = [Quantity.one, .two, .three]
	}

	enum Color: String {
		case colorOne = "#FF0000FF"
		case colorTwo = "#00FF00FF"
		case colorThree = "#0000FFFF"

		static let all = [Color.colorOne, .colorTwo, .colorThree]
	}

	enum Shading {
		case shadingOne, shadingTwo, shadingThree

		static let all = [Shading.shadingOne, .shadingTwo, .shadingThree]
	}
}

extension Card: Equatable {
	static func ==(lhs: Card, rhs: Card) -> Bool {
		return lhs.type == rhs.type && lhs.quantity == rhs.quantity && lhs.color == rhs.color && lhs.shading == rhs.shading
	}
}
