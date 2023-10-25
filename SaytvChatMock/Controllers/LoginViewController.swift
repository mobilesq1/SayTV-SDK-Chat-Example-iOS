//
//  LoginViewController.swift
//  SaytvChatMock
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
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sendTapAction(_ sender: UIButton) {
        guard let digicelId = digicelIdTextField.text,
              !digicelId.isEmpty
        else {
            resultTextView.text = "DigicelId needs to have a value"
            return
        }
        SayTvSdk.login(digicelId: digicelId,
                       apiToken: kApiToken) { result in
            switch result {
            case .success(let response):
                self.resultTextView.text = "Success: \(response == true), User has login"
            case .failure(let error):
                self.resultTextView.text = "Failure: \(error.localizedDescription)"
            }
        }
    }
    
}
