//
//  LoginViewController.swift
//  SaytvChatFake
//
//  Created by David Garcia on 24/5/22.
//

import UIKit
import SaytvChat

class LoginViewController: UIViewController {

    @IBOutlet weak var digicelIdTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendTapAction(_ sender: UIButton) {
        guard let text = digicelIdTextField.text,
                let digicelId = Int(text)
        else {
            resultTextView.text = "DigicelId needs to be a number"
            return
        }
        SayTvSdk.login(digicelId: digicelId) { result in
            switch result {
            case .success(let response):
                self.resultTextView.text = "Success: \(response == true), User has login"
            case .failure(let error):
                self.resultTextView.text = "Failure: \(error.localizedDescription)"
            }
        }
    }
    
}
