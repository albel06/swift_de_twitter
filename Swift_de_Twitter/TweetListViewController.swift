//
//  MasterViewController.swift
//  Swift_de_Twitter
//
//  Created by 松浦 篤 on 2015/02/02.
//  Copyright (c) 2015年 atsushi. All rights reserved.
//

import UIKit
import Accounts
import Social

class TweetListViewController: UITableViewController {

    let accountStore = ACAccountStore()
    var tweets: [NSDictionary] = [NSDictionary]()
    
    let imageQueue = NSOperationQueue()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        let dummy = TweetDetailViewController()
        
        super.viewDidLoad()
        self.setup()
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    func setup() {
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        // SLRequest Handler
        let slRequestHandler = {
            (data: NSData!, response: NSHTTPURLResponse!, error: NSError!) -> () in
            if let _response = response {
                var jsonError: NSError?
                if let timeLine: NSArray = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.MutableLeaves, error: &jsonError) as? NSArray {
                        for tweet: NSDictionary in timeLine as [NSDictionary] {
                            self.tweets.append(tweet)
                        }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in self.tableView.reloadData() })
            } else {
                println("JSON Error")
            }
        }
        
        // アカウントアクセスコンプリートハンドラ
        let handler: ACAccountStoreRequestAccessCompletionHandler! = { granted, error in
            if (granted) {
                let accounts = self.accountStore.accountsWithAccountType(accountType)
                if (accounts.isEmpty) {
                    return
                }
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                                        requestMethod: SLRequestMethod.GET,
                                        URL: NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!,
                                        parameters: nil)
                request.account = accounts[0] as ACAccount
                request.performRequestWithHandler(slRequestHandler)
            }
        }
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = tweets[indexPath.row] as NSDictionary
            (segue.destinationViewController as TweetDetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TweetCell

        cell.update(tweets[indexPath.row])

        let user: NSDictionary = cell.model.objectForKey("user") as NSDictionary

        if let url: String = user.objectForKey("profile_image_url") as? String {
            var handler = { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.profileImageView.image = UIImage(data: data)!
                })
            }
            let req = NSURLRequest(URL: NSURL(string: url)!)
            NSURLConnection.sendAsynchronousRequest(req, queue: self.imageQueue, completionHandler: handler)
        }
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}
