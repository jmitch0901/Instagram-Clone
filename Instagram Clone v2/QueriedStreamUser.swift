//
//  QueriedStreamUser.swift
//  Instagram Clone v2
//
//  Created by Jonathan Mitchell on 12/16/15.
//  Copyright © 2015 nuapps. All rights reserved.
//

import UIKit
import Parse

class QueriedStreamUser{
    
    var userId: String?
    var message: String?
    var imageFile: PFFile?
    
    
    init(userId:String, message: String, file: PFFile){
        self.userId = userId
        self.message = message
        self.imageFile = file
        
    }
    
    
}
