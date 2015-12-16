//
//  StreamTableViewController.swift
//  Instagram Clone v2
//
//  Created by Jonathan Mitchell on 12/16/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import Parse



class StreamTableViewController: UITableViewController {
    
    
    var postInfo = [String:String]() //MAP ausername BY there user ID
    var data:[QueriedStreamUser] = []
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        //print("Refreshed")
        query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            
            if let objects = objects {
                self.postInfo.removeAll(keepCapacity: true)
                self.data.removeAll(keepCapacity: true)
                
                for object in objects{
                    
                    if let user = object as? PFUser{
                        
                        if user.objectId != PFUser.currentUser()?.objectId{
                        
                            //print("Got here too!")
                            self.postInfo[user.objectId!] = user.username!
                            
                        }
                    }
                }
            }
            
        })
        
    

    
        let getFollowedUsersQuery = PFQuery(className: "followers")
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    let followedUser = object["following"] as! String
                    
                    let query = PFQuery(className: "Post")
                    
                    //We only want feed from followed users
                    query.whereKey("userId", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if let objects = objects {
                            
                            for object in objects{
 
                               // print("GOT HERE")
                                
                                self.data.append(
                                    QueriedStreamUser(
                                        userId: object.valueForKey("userId") as! String,
                                        message: object.valueForKey("message") as! String,
                                        file: object.valueForKey("imageFile") as! PFFile))
                                
                                self.tableView.reloadData()
                            }
                            
                            print(self.data)
                            
                            //print(self.postInfo)
                            //self.dictionaryAsArr = Array(self.postInfo.values)
                            //print(self.dictionaryAsArr)
                            //print(self.dictionaryAsArr.count)
                            
                        }
                        
                    })
                    
                    
                }
            }
        }
        
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("streamCell", forIndexPath: indexPath) as! PhotoStreamCellTableViewCell

        
        data[indexPath.row].imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                cell.imageViewCell.image = downloadedImage
                print("donezo")
            }
        })
        
        
        
        
        cell.userName.text = postInfo[data[indexPath.row].userId!]
        cell.message.text = data[indexPath.row].message

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
