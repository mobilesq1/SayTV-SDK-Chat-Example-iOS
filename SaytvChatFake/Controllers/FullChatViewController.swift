//
//  FullChatViewController.swift
//  SaytvChatFake
//
//  Created by David Garcia on 7/7/22.
//

import UIKit
import SaytvChat
import FirebaseAnalytics

class FullChatViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var chatIdTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        containerView.isHidden = true
        startTimeTextField.tag = 100
        endTimeTextField.tag = 101
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        addDatePicker(id: startTimeTextField.tag, textField: startTimeTextField)
        addDatePicker(id: endTimeTextField.tag, textField: endTimeTextField)
    }
    
    @IBAction func sendTapAction(_ sender: UIButton) {
        guard let chatId = chatIdTextField.text,
              let name = nameTextField.text,
              let image = imageTextField.text,
              let startTime = dateFormatter.date(from: startTimeTextField.text ?? ""),
              let endTime = dateFormatter.date(from: endTimeTextField.text ?? ""),
              !chatId.isEmpty || !name.isEmpty
        else {
            resultTextView.text = "Fill all the form"
            return
        }
        sender.isUserInteractionEnabled = false
        
        let fullChatComponent = FullChatComponent(containerView: view,
                                  chatId: chatId,
                                  chatName: name,
                                  chatImage: image,
                                  startDate: startTime,
                                  endDate: endTime) { result in
            switch result {
            case .success:
                self.infoStackView.isHidden = true
                self.containerView.isHidden = false
            case .failure(let error):
                sender.isUserInteractionEnabled = true
                self.resultTextView.text = "Failure: \(error.localizedDescription)"
            }
        }
        
        fullChatComponent.chatActions { event in
            print("Full ChatActions event: \(event)")
            Analytics.logEvent("sdk_send_commend_test", parameters: event)
        }

    }
    
    private func addDatePicker(id: Int, textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.tag = id
        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.minimumDate = Date()
        datePicker.addTarget(self,
                             action: #selector(dateChanged),
                             for: .allEvents)
        textField.inputView = datePicker
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(self.datePickerDone))
        doneButton.tag = id
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil),
                          doneButton],
                         animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    @objc
    func dateChanged(sender: UIDatePicker) {
        if sender.tag == 100 {
            startTimeTextField.text = dateFormatter.string(from: sender.date)
        } else {
            endTimeTextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc
    func datePickerDone(sender: UIBarButtonItem) {
        if sender.tag == 100 {
            startTimeTextField.resignFirstResponder()
        } else {
            endTimeTextField.resignFirstResponder()
        }
    }

}

extension FullChatViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.tag == 100 || textField.tag == 101 {
            return false
        }
        return true
    }
    
}
