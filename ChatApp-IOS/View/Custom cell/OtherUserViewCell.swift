//
//  OtherUserViewCell.swift
//  ChatApp-IOS
//
//  Created by TWBKG on 14/5/2562 BE.
//  Copyright © 2562 TWBKG. All rights reserved.
//

import UIKit

class OtherUserViewCell: UITableViewCell {

    @IBOutlet weak var avartarImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
