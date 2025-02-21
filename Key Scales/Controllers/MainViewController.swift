//
//  MainViewController.swift
//  Key Scales
//
//  Created by SD43 on 2/12/25.
//

import UIKit
import AVFoundation
import FirebaseAuth

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var keyTextfield: UITextField!
    @IBOutlet var cKey: UIButton!
    @IBOutlet var dKey: UIButton!
    @IBOutlet var eKey: UIButton!
    @IBOutlet var fKey: UIButton!
    @IBOutlet var gKey: UIButton!
    @IBOutlet var aKey: UIButton!
    @IBOutlet var bKey: UIButton!
    @IBOutlet var c4Key: UIButton!
    @IBOutlet var csKey: UIButton!
    @IBOutlet var dsKey: UIButton!
    @IBOutlet var fsKey: UIButton!
    @IBOutlet var gsKey: UIButton!
    @IBOutlet var asKey: UIButton!
    
    var player: AVAudioPlayer?
    var originalColors: [UIButton: UIColor] = [:]
    let appPrimaryColor = UIColor(named: "pastelBlue")
    
    var allScales: [String: [UIButton]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        self.keyTextfield.delegate = self
        cKey.layer.borderWidth = 1
        cKey.layer.borderColor = UIColor.black.cgColor
        dKey.layer.borderWidth = 1
        dKey.layer.borderColor = UIColor.black.cgColor
        eKey.layer.borderWidth = 1
        eKey.layer.borderColor = UIColor.black.cgColor
        fKey.layer.borderWidth = 1
        fKey.layer.borderColor = UIColor.black.cgColor
        gKey.layer.borderWidth = 1
        gKey.layer.borderColor = UIColor.black.cgColor
        aKey.layer.borderWidth = 1
        aKey.layer.borderColor = UIColor.black.cgColor
        bKey.layer.borderWidth = 1
        bKey.layer.borderColor = UIColor.black.cgColor
        c4Key.layer.borderWidth = 1
        c4Key.layer.borderColor = UIColor.black.cgColor
        csKey.layer.borderWidth = 1
        csKey.layer.borderColor = UIColor.black.cgColor
        dsKey.layer.borderWidth = 1
        dsKey.layer.borderColor = UIColor.black.cgColor
        fsKey.layer.borderWidth = 1
        fsKey.layer.borderColor = UIColor.black.cgColor
        gsKey.layer.borderWidth = 1
        gsKey.layer.borderColor = UIColor.black.cgColor
        asKey.layer.borderWidth = 1
        asKey.layer.borderColor = UIColor.black.cgColor
        
        allScales = [
            "C": [cKey, dKey, eKey, fKey, gKey, aKey, bKey, c4Key],
            "C#": [csKey, dsKey, fKey, fsKey, gsKey, asKey, cKey, csKey],
            "D": [dKey, eKey, fsKey, gKey, aKey, bKey, csKey, dKey],
            "D#": [dsKey, fKey, gKey, gsKey, asKey, cKey, dKey, dsKey],
            "E": [eKey, fsKey, gsKey, aKey, bKey, csKey, dsKey, eKey],
            "F": [fKey, gKey, aKey, asKey, cKey, dKey, eKey, fKey],
            "F#": [fsKey, gsKey, asKey, bKey, csKey, dsKey, fKey, fsKey],
            "G": [gKey, aKey, bKey, cKey, dKey, eKey, fsKey, gKey],
            "G#": [gsKey, asKey, cKey, csKey, dsKey, fKey, gKey, gsKey],
            "A": [aKey, bKey, csKey, dKey, eKey, fsKey, gsKey, aKey],
            "A#": [asKey, cKey, dKey, dsKey, fKey, gKey, aKey, asKey],
            "B": [bKey, csKey, dsKey, eKey, fsKey, gsKey, asKey, bKey],
            
            "Cm": [cKey, dKey, dsKey, fKey, gKey, gsKey, asKey, c4Key],
            "C#m": [csKey, dsKey, eKey, fsKey, gsKey, aKey, bKey, csKey],
            "Dm": [dKey, eKey, fKey, gKey, aKey, asKey, cKey, dKey],
            "D#m": [dsKey, fKey, fsKey, gsKey, asKey, bKey, csKey, dsKey],
            "Em": [eKey, fsKey, gKey, aKey, bKey, cKey, dKey, eKey],
            "Fm": [fKey, gKey, gsKey, asKey, cKey, csKey, dsKey, fKey],
            "F#m": [fsKey, gsKey, aKey, bKey, csKey, dKey, eKey, fsKey],
            "Gm": [gKey, aKey, asKey, cKey, dKey, dsKey, fKey, gKey],
            "G#m": [gsKey, asKey, bKey, csKey, dsKey, eKey, fsKey, gsKey],
            "Am": [aKey, bKey, cKey, dKey, eKey, fKey, gKey, aKey],
            "A#m": [asKey, cKey, csKey, dsKey, fKey, fsKey, gsKey, asKey],
            "Bm": [bKey, csKey, dKey, eKey, fsKey, gKey, aKey, bKey]
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
    }
    
    @IBAction func playGamePressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gameSegue", sender: nil)
    } 
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    func textFieldShouldReturn(_ keyTextField: UITextField) -> Bool {
        keyTextField.resignFirstResponder()
         
        let formattedKey = formatKeyInput(keyTextField.text ?? "")
        if let scaleNotes = allScales[formattedKey]{
            playNotesSequentially(notes: scaleNotes, index: 0)
        } else {
            showAlert(message: "Invalid key entered.")
        }
        
        keyTextField.text = ""
        return true
    }
    
    func playNotesSequentially(notes: [UIButton], index: Int) {
        if index >= notes.count {
            // Restore original colors after the last note is played
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                for note in notes {
                    note.backgroundColor = self.originalColors[note]
                }
            }
            return
        }
        
        let note = notes[index]
        
        // Store original color only once (first time note is played)
        if originalColors[note] == nil {
            originalColors[note] = note.backgroundColor
        }
        
        note.backgroundColor = UIColor(named: "pastelBlue")
        playSound(for: note)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.playNotesSequentially(notes: notes, index: index + 1)
        }
    }
    
    func playSound(for button: UIButton) {
        if let note = button.currentTitle {
            
            guard let path = Bundle.main.path(forResource: note, ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func formatKeyInput(_ input: String) -> String {
        guard !input.isEmpty else { return "" }
        
        let firstLetter = input.prefix(1).uppercased()
        let remainingLetters = input.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
 
