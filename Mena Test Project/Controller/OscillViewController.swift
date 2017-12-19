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
    var source = AKVocalTract()
	var mixer = AKMixer()
    var octave = 4
	
	@IBOutlet var noteButtons: [UIButton]!
	@IBOutlet weak var recordButton: MDStateButton!
	@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var octaveLabel: UILabel!
    
	var recorder: AKNodeRecorder!
	var player: AKAudioPlayer!
	var tapeRecord: AKAudioFile!
    var tapePlay: AKAudioFile!
    
	var recordings: [Recording] {
        return Recording.all.sorted { $0.date > $1.date }
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
		setupSound()
    }
    
    func setupSound() {
        let tempMixer = AKMixer(source)
        tapeRecord = try! AKAudioFile()
        tapePlay = try! AKAudioFile()
        
        player = try! AKAudioPlayer(file: tapePlay)
        mixer = AKMixer(player, tempMixer)
        recorder = try! AKNodeRecorder(node: mixer, file: tapeRecord)
        
        AudioKit.output = mixer
        AudioKit.start()
    }
	
	func setupUI() {
		for button in noteButtons {
			button.layer.borderWidth = 2.0
			button.layer.borderColor = UIColor.black.cgColor
			button.layer.cornerRadius = button.bounds.width / 2
			button.clipsToBounds = true
		}
        recordButton.layer.cornerRadius = 8.0
        recordButton.clipsToBounds = true
        octaveLabel.text = "\(octave)"
	}
    @IBAction func octaveChanged() {
        octave = Int(stepper.value)
        octaveLabel.text = "\(octave)"
    }
    
	@IBAction func play(sender: UIButton) {
		let note = MDNote(rawValue: sender.tag)!
		
		source.frequency = note.getFrequency(for: octave)
		source.start()
	}
	
	@IBAction func stop() {
		if source.isPlaying { source.stop() }
	}

	
	@IBAction func record(_ sender: UIButton) {
        if recorder.isRecording {
            recordButton.activeState = .nonActive("Record Audio")
            recorder.stop()
            let alert = UIAlertController(title: "Saving recording", message: "Give a name for your recording", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            
            let ok = UIAlertAction(title: "Save", style: .default) { _ in
                let unixTimeDate = Date().timeIntervalSince1970
                let name = alert.textFields!.first!.text!
                self.tapeRecord.exportAsynchronously(name: "\(unixTimeDate)@@@\(name)", baseDir: .documents, exportFormat: .caf) { file, error in
                    guard file != nil else { return }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            recordButton.activeState = .active("Recording...")
            try! recorder.record()
		}
	}
	
    @objc func playRecord(sender: MDStateButton) {
        player.completionHandler = { sender.activeState = .nonActive("Play") }
        if player.isPlaying {
            sender.activeState = .nonActive("Play")
			player.stop()
        } else {
            sender.activeState = .active("Stop")
            let fileName = recordings[sender.tag].fileName
            tapePlay = try! AKAudioFile(readFileName: fileName, baseDir: .documents)
            try! player.replace(file: tapePlay)
            player.play()
        }
	}
}

extension OscillViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return recordings.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
            let cell = tableView.dequeueReusableCell(withIdentifier: MDCell.recording, for: indexPath) as? RecordingCell
        else {
			return UITableViewCell()
		}
        
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(playRecord(sender:)), for: .touchUpInside)
        
        let recording = recordings[indexPath.row]
        
        cell.nameLabel.text = recording.name
        cell.dateLabel.text = MDConstant.dateFormatter.string(from: recording.date)

		return cell
	}
}

