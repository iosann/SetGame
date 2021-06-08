//
//  Collection.swift
//  Set
//
//  Created by Anna Belousova on 08.06.2021.
//

import Foundation

extension Collection {
	var maxRawValue: Int? {
		var arrayOfRawValues = [Int]()
		for value in Card.Quantity.allCases {
			arrayOfRawValues.append(value.rawValue)
		}
		return arrayOfRawValues.max()
	}
}
