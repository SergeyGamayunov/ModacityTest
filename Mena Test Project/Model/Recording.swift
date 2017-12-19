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
    let name: String
    let date: Date
    let fileName: String

	static var all: [Recording] {
		let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let directoryContents = try! FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
		let cafFiles = directoryContents.filter { $0.pathExtension == "caf" }
        
        var result: [Recording] = []
        for url in cafFiles {
            let properties = url.lastPathComponent.components(separatedBy: "@@@")
            let unixTime = Double(properties.first!)! as TimeInterval
            let date = Date(timeIntervalSince1970: unixTime)
            let name = properties[1]
            let recording = Recording(name: name, date: date, fileName: url.lastPathComponent)
            
            result.append(recording)
        }
		
        return result
	}
}
