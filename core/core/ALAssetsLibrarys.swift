//
//  ALAssetsLibrarys.swift
//  LinCore
//
//  Created by lin on 1/29/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import LinUtil

public extension ALAssetsLibrary{
    
    
    public func writeImageToSavedPhotosAlbums(images:[CGImage],albumName:NSString, metadata: [NSObject : AnyObject]!,completion:(([NSURL!]!,[NSError!]!)->())!){
        
        let set = AutoResetEvent();
        
        Queue.asynQueue(){() in
            for image in images {
                set.reset();
                self.writeImageToSavedPhotosAlbum(image,albumName:albumName,metadata:metadata,completion:{(url:NSURL!,error:NSError!) in                    set.set();
                });
                set.waitOne();
            }
            Queue.mainQueue(){() in
                completion(nil,nil);
            }
        }
    }
    
    
    
    public func writeImageToSavedPhotosAlbum(image:CGImage,albumName:NSString, metadata: [NSObject : AnyObject]!,completion:((NSURL!,NSError!)->())!){
    self.writeImageToSavedPhotosAlbum(image, metadata: nil, completionBlock: {(url:NSURL!, error:NSError!) in

        if let error = error {
            completion?(url,error);
            return;
        }
        var albumWasFound = false;
        self.enumerateGroupsWithTypes(ALAssetsGroupAlbum , usingBlock:{(group:ALAssetsGroup!, stop:UnsafeMutablePointer<ObjCBool>) in
   
            if group != nil {
                let r = albumName.compare(group.valueForProperty(ALAssetsGroupPropertyName) as! String);
                if  r == NSComparisonResult.OrderedSame {
                    albumWasFound = true;
                    self.assetForURL(url,resultBlock:{(asset:ALAsset!) in
                        group.addAsset(asset);
                        completion(url,nil);
                        },failureBlock:{(error:NSError!) in
                            completion(nil,error);
                    });
                }
                return;
            }
            if group == nil && albumWasFound == false {
                self.addAssetsGroupAlbumWithName(albumName as String,resultBlock:{(group:ALAssetsGroup!) in
                
                    
                    self.assetForURL(url,resultBlock:{(asset:ALAsset!) in
                        group?.addAsset(asset);
                        completion(url,nil);
                    },failureBlock:{(error:NSError!) in
                        completion(nil,error);
                    });
                },failureBlock:{(error:NSError!) in
                    completion(nil,error);
                });
            }

        }, failureBlock: {(error:NSError!) in
                completion(nil,error);
        })
    });
    }

}