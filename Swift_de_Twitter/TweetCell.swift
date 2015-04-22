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
    @IBOutlet weak var screenName: UILabel!             // @name表示
    @IBOutlet weak var tweet: UILabel!                  // つぶやき
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func defaultHeight() -> CGFloat {
        return 50.0
    }
    
    func update(model: NSDictionary) {
        self.model = model
        
        var user: NSDictionary = model.objectForKey("user") as NSDictionary
        self.userName.text = user.objectForKey("name") as? String        
        
        let screen_name = user.objectForKey("screen_name") as? String
        self.screenName.text = "@" + screen_name!
        
        var created: String = model.objectForKey("created_at") as String

        self.tweet.text = model.objectForKey("text") as? String
        self.tweet.sizeToFit()
    }
}
