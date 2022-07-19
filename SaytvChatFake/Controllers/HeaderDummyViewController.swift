//
//  HeaderDummyViewController.swift
//  SaytvChatFake
//
//  Created by David Garcia on 19/7/22.
//

import UIKit
import SaytvChat

class HeaderDummyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultTextView: UITextView!
    
    var activeUsers: [ActiveUsers] = [] {
        didSet {
            tableView.reloadData()
            let hasUsers = activeUsers.count != 0
            tableView.isHidden = !hasUsers
            resultTextView.isHidden = hasUsers
            if !hasUsers {
                resultTextView.text = "No active users"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SayTvSdk.getActiveUsers(chatIds: ["1130", "1132", "1133", "1135"]) { result in
            switch result {
            case .success(let activeusers):
                self.activeUsers = activeusers
            case .failure(let error):
                self.resultTextView.text = "Error: \(error.localizedDescription)"
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        let headerCell = UINib(nibName: "HeaderTableViewCell", bundle: nil)
        tableView.register(headerCell, forCellReuseIdentifier: "HeaderTableViewCell")
    }
    
}

extension HeaderDummyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUsers.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
        let start = "20/07/2022 06:00:00"
        let end = "31/07/2022 12:00:00"
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let startDate = formatter.date(from: start)
        let endDate = formatter.date(from: end)
        let activeUser = activeUsers[indexPath.row]
        
        if let startDate = startDate,
           let endDate = endDate {
            cell.setContent(name: "Nice episode event chat",
                            image: "https://image_url_example.com",
                            startDate: startDate,
                            endDate: endDate,
                            count: activeUser.activeUsers)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}
