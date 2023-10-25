//
//  ProfileViewController.swift
//  SaytvChatMock
//
//  Created by David Garcia on 27/6/22.
//

import UIKit
import SaytvChat

class ProfileViewController: UIViewController {

    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var userIdLabel: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func tapButton(_ sender: UIButton) {
        guard let userIdString = userIdLabel.text,
              let userId = Int(userIdString)
        else {
            resultTextView.text = "User Id needs to be a number"
            return
        }
        let _ = ProfileComponent(userId: userId, containerView: view)
        infoStackView.isHidden = true
    }
    
}
