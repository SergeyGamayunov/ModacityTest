//
//  MDNote.swift
//  Mena Test Project
//
//  Created by Сергей Гамаюнов on 19.12.17.
//  Copyright © 2017 modacity. All rights reserved.
//

import Foundation
enum MDNote: Int {
	case c = 1, csharp, d, dsharp, e, f, fsharp, g, gsharp, a, asharp, b
	
	func getFrequency(for octave: Int) -> Double {
		let expCoef = Double(12*(octave-1) + rawValue - 1)
		return pow(MDConstant.semitone, expCoef) * MDConstant.c1
	}
}
