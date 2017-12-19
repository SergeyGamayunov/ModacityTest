//
//  RecordingCell.swift
//  Mena Test Project
//
//  Created by Сергей Гамаюнов on 19.12.17.
//  Copyright © 2017 modacity. All rights reserved.
//

import UIKit

class RecordingCell: UITableViewCell {
	var completion: (() -> Void)?

	
	
	@IBAction func playTrigger() {
		completion?()
	}
}
