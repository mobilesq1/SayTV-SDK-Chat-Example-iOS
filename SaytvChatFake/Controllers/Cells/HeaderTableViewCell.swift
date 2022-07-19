//
//  HeaderTableViewCell.swift
//  SaytvChatFake
//
//  Created by David Garcia on 19/7/22.
//

import UIKit
import SaytvChat

class HeaderTableViewCell: UITableViewCell {
    
    func setContent(name: String, image: String, startDate: Date, endDate: Date, count: Int) {
        let _ = HeaderComponent(containerView: contentView,
                                chatName: name,
                                chatImage: image,
                                startDate: startDate,
                                endDate: endDate,
                                activeUsers: count)
    }
    
}
