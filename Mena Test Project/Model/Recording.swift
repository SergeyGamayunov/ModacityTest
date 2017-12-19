//
//  Recording.swift
//  Mena Test Project
//
//  Created by Сергей Гамаюнов on 19.12.17.
//  Copyright © 2017 modacity. All rights reserved.
//

import Foundation
import AudioKit

struct Recording {
	static var count: Int {
		let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		let directoryContents = try! FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
		print(directoryContents)

		let cafFiles = directoryContents.filter{ $0.pathExtension == "caf" }
		
		return cafFiles.count
	}
	
	static var audioFiles: [AKAudioFile] {
		let documentsUrl =  FileManager.default.temporaryDirectory
		
		let directoryContents = try! FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
		print(directoryContents)
		
		let cafFiles = directoryContents.filter{ $0.pathExtension == "caf" }
		
		return cafFiles.map { try! AKAudioFile(forReading: $0) }
	}
	
}
