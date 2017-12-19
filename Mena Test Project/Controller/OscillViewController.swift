//
//  ViewController.swift
//  Mena Test Project
//
//  Created by Marc Gelfo on 12/16/17.
//  Copyright © 2017 modacity. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class OscillViewController: UIViewController {
	let oscillator = AKOscillator()
	var mixer = AKMixer()
	let octave = 4
	
	@IBOutlet var noteButtons: [UIButton]!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	
	
	var micMixer: AKMixer!
	var recorder: AKNodeRecorder!
	var player: AKAudioPlayer!
	var tape: AKAudioFile!
	
	var tapes: [AKAudioFile] {
		return Recording.audioFiles
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupButtons()
		mixer = AKMixer(oscillator)
		tape = try! AKAudioFile()
		player = try! AKAudioPlayer(file: tape)
		
		let mainMixer = AKMixer(player, mixer)
		AudioKit.output = mainMixer
		AudioKit.start()
		
		recorder = try! AKNodeRecorder(node: mixer, file: tape)
    }
	
	func setupButtons() {
		for button in noteButtons {
			button.layer.borderWidth = 2.0
			button.layer.borderColor = UIColor.black.cgColor
			button.layer.cornerRadius = button.bounds.width / 2
			button.clipsToBounds = true
		}
	}

	@IBAction func play(sender: UIButton) {
		let note = MDNote(rawValue: sender.tag)!
		
		oscillator.frequency = note.getFrequency(for: octave)
		oscillator.start()
	}
	
	@IBAction func stop() {
		if oscillator.isPlaying { oscillator.stop() }
	}

	
	@IBAction func record(_ sender: UIButton) {
		if recorder.isRecording {
			recorder.stop()
			tape.exportAsynchronously(name: "test", baseDir: .documents, exportFormat: .caf) {
				_, _ in
				self.tableView.reloadData()
			}
		} else {
			try! recorder.record()
		}
	}
	
	@IBAction func playRecord() {
		if player.isPlaying {
			player.stop()
		} else {
			try! player.reloadFile()
			player.play()
		}
	}
}

extension OscillViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tapes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: MDCell.recording, for: indexPath) as? RecordingCell else {
			return UITableViewCell()
		}
		
		tape = tapes[indexPath.row]
		cell.completion = { self.playRecord() }
		
		return cell
	}
}

