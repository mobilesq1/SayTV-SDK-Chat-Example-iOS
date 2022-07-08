//
//  ChatViewController.swift
//  SaytvChatFake
//
//  Created by David Garcia on 24/5/22.
//

import UIKit
import SaytvChat

class ChatViewController: UIViewController {

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var chatContainerView: UIView!
    
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
    
    private var showFullChat: Bool = false {
        didSet {
            chatContainerView.isHidden = !showFullChat
            headerContainerView.isHidden = !showFullChat
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        showFullChat = false
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
        
        startHeader(chatId: chatId,
                    name: name,
                    chatImage: image,
                    startDate: startTime,
                    endDate: endTime) { result in
            self.evaluate(sender: sender, result: result)
            switch result {
            case .success:
                self.startChat(chatId: chatId,
                               name: name,
                               chatImage: image,
                               startDate: startTime,
                               endDate: endTime) { result in
                    self.evaluate(sender: sender, result: result)
                }
            default:
                break
            }
        }
    }
    
    private func evaluate(sender: UIButton, result: Result<Void, Error> ) {
        switch result {
        case .success:
            self.infoStackView.isHidden = true
            self.showFullChat = true
        case .failure(let error):
            sender.isUserInteractionEnabled = true
            self.resultTextView.text = "Failure: \(error.localizedDescription)"
        }
    }
    
    private func startHeader(chatId: String, name: String,
                             chatImage: String, startDate: Date,
                             endDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        let _ = HeaderComponent(containerView: headerContainerView,
                                chatId: chatId,
                                chatName: name,
                                chatImage: chatImage,
                                startDate: startDate,
                                endDate: endDate,
                                completion: completion)
    }
    
    private func startChat(chatId: String, name: String,
                           chatImage: String, startDate: Date,
                           endDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        let _ = ChatComponent(view: chatContainerView,
                              name: name.isEmpty ? nil : name,
                              image: chatImage.isEmpty ? nil : chatImage,
                              startTime: startDate,
                              endTime: endDate,
                              chatId: chatId,
                              completion: completion)
    }
    
    private func addDatePicker(id: Int, textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.tag = id
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
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

extension ChatViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 100 || textField.tag == 101 {
            return false
        }
        return true
    }
    
}
