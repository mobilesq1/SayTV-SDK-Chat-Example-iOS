//
//  ViewController.swift
//  SaytvChatFake
//
//  Created by David Garcia on 24/5/22.
//

import UIKit
import SaytvChat

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var avatarTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var digicelIdTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sendTapAction(_ sender: UIButton) {
        guard let digicelId = digicelIdTextField.text,
              !digicelId.isEmpty
        else {
            resultTextView.text = "DigicelId needs to have a value"
            return
        }
        SayTvSdk.register(digicelId: digicelId,
                          email: emailTextField.text ?? "",
                          avatar: avatarTextField.text ?? "",
                          username: usernameTextField.text ?? "",
                          apiToken: kApiToken) { result in
            switch result {
            case .success(let response):
                self.resultTextView.text = "Success: \(response == true), User registered"
            case .failure(let error):
                self.resultTextView.text = "Failure: \(error.localizedDescription)"
            }
        }
    }
    
}

