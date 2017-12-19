//
//  MDConstant.swift
//  Mena Test Project
//
//  Created by Сергей Гамаюнов on 19.12.17.
//  Copyright © 2017 modacity. All rights reserved.
//

import Foundation

struct MDConstant {
	static let semitone = 1.0594630943593 // 12-root of 2
	static let a0 = 27.5 // first note in scale
	static let c1 = 32.703195662575268
	
	static var numberOfRecords: Int {
		get {
			return UserDefaults.standard.integer(forKey: "NumberOfRecords")
		} set {
			UserDefaults.standard.set(newValue, forKey: "NumberOfRecords")
		}
	}
}

struct MDCell {
	static let recording = "RecordingCell"
}
