//
//  HttpClientModel.swift
//  LinComm
//
//  Created by lin on 24/10/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import CoreData

//@objc(BackgroundDown)
//public class BackgroundDown: NSManagedObject {
//    
//    dynamic var location:String!;
//}

import Foundation
import CoreData


public class BackgroundDown: NSManagedObject {
    
}

extension BackgroundDown {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackgroundDown> {
        return NSFetchRequest<BackgroundDown>(entityName: "BackgroundDown");
    }
    
    @NSManaged public var identifier: String?
    @NSManaged public var location: String?
    
}
