//
//  TweetCell.swift
//  Swift_de_Twitter
//
//  Created by 松浦 篤 on 2015/03/06.
//  Copyright (c) 2015年 atsushi. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    var model: NSDictionary!

    @IBOutlet weak var profileImageView: UIImageView!   // プロフィール画像
    @IBOutlet weak var createTime: UILabel!             // 時間
    @IBOutlet weak var userName: UILabel!               // ユーザーネーム
    @IBOutlet weak var screenName: UILabel!             // @name
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func update(model: NSDictionary) {
        self.model = model
        
        var user: NSDictionary = model.objectForKey("user") as NSDictionary
        self.userName.text = user.objectForKey("name") as? String
        self.screenName.text = user.objectForKey("screen_name") as? String
        
        var created: String = model.objectForKey("created_at") as String
        self.createTime.text = "XX時間前"
//        self.tweetLabel.text = model.objectForKey("text") as? String
    }
}
