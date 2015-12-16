//
//  UsersTableViewController.swift
//  Instagram Clone
//
//  Created by Jonathan Mitchell on 12/15/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import Parse

class UsersTableViewController: UITableViewController {
    
    var userNames = [""]
    var ids = [""]
    var followingList = ["":false]
    
    var refresher: UIRefreshControl!
    
    func refresh(){
        
        let query = PFUser.query()
        
        //print("Refreshed")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            
            if let users = objects {
                
                self.userNames.removeAll(keepCapacity: true)
                self.ids.removeAll(keepCapacity: true)
                self.followingList.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        
                        if user.objectId != PFUser.currentUser()?.objectId {
                            self.userNames.append(user.username!)
                            self.ids.append(user.objectId!)
                            
                            
                            let query = PFQuery(className: "followers")
                            query.whereKey("follower", equalTo: (PFUser.currentUser()!.objectId)!)
                            query.whereKey("following", equalTo: (user.objectId)!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                
                                if let objects = objects {
                                    self.followingList[user.objectId!] = Bool(objects.count > 0)
                                } else {
                                    self.followingList[user.objectId!] = false
                                }
                                
                                //print(self.followingList)
                                
                                if self.followingList.count == self.userNames.count {
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                }
                                
                            })
                            
                        }
                    }
                }
            }
            
            //print(self.userNames)
            //print(self.ids)
        })
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)//value changed meaning the user puled down to refresh
        self.tableView.addSubview(refresher)
        
        refresh()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = userNames[indexPath.row]
        
        let followedId:String = ids[indexPath.row]
        
        //retarded
        if followingList[followedId] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let followedId:String = ids[indexPath.row]
        
        if followingList[followedId] == true {
            
            followingList[followedId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            let query = PFQuery(className: "followers")
            query.whereKey("follower", equalTo: (PFUser.currentUser()!.objectId)!)
            query.whereKey("following", equalTo: ids[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                if let objects = objects {
                    
                    for object in objects{
                        object.deleteInBackground()
                        
                    }
                }
            })
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            let selectedId = ids[indexPath.row]
            
            followingList[selectedId] = true
            
            let following = PFObject(className: "followers")
            following["following"] = selectedId
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()
            
        }
        
        //print(self.followingList)
    }
    
}