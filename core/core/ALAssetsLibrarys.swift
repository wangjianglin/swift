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
    
    
    public func writeImageToSavedPhotosAlbums(_ images:[CGImage],albumName:NSString, metadata: [AnyHashable: Any]!,completion:(([URL?]?,[Error?]?)->())!){
        
        let set = AutoResetEvent();
        
        Queue.asynQueue(){() in
            for image in images {
                set.reset();
                self.writeImageToSavedPhotosAlbum(image,albumName:albumName,metadata:metadata,completion:{(url:URL?,error:Error?) in                    set.set();
                });
                set.waitOne();
            }
            Queue.mainQueue(){() in
                completion(nil,nil);
            }
        }
    }
    
    
    
    public func writeImageToSavedPhotosAlbum(_ image:CGImage,albumName:NSString, metadata: [AnyHashable: Any]!,completion:((URL?,Error?)->())!){
        
        
//        self.writeImage(toSavedPhotosAlbum: CGImage!, metadata: [AnyHashable : Any]!) { (URL?, <#Error?#>) in
//            <#code#>
//        }
        
    self.writeImage(toSavedPhotosAlbum: image, metadata: nil, completionBlock: {(url:URL?, error:Error?) in

        if let error = error {
            completion?(url,error);
            return;
        }
        var albumWasFound = false;
        
//        self.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (<#ALAssetsGroup?#>, <#UnsafeMutablePointer<ObjCBool>?#>) in
//            code
//            }, failureBlock: { (<#Error?#>) in
//                <#code#>
//        })
        
        self.enumerateGroupsWithTypes(ALAssetsGroupAlbum , usingBlock:{(group:ALAssetsGroup?, stop:UnsafeMutablePointer<ObjCBool>?) in
   
            if group != nil {
                let r = albumName.compare(group?.value(forProperty: ALAssetsGroupPropertyName) as! String);
                if  r == ComparisonResult.orderedSame {
                    albumWasFound = true;
                    self.asset(for: url,resultBlock:{(asset:ALAsset?) in
                        group?.add(asset);
                        completion(url,nil);
                        },failureBlock:{(error:Error?) in
                            completion(nil,error);
                    });
                }
                return;
            }
            if group == nil && albumWasFound == false {
                self.addAssetsGroupAlbum(withName: albumName as String,resultBlock:{(group:ALAssetsGroup?) in
                
                    
                    self.asset(for: url,resultBlock:{(asset:ALAsset?) in
                        group?.add(asset);
                        completion(url,nil);
                    },failureBlock:{(error:Error?) in
                        completion(nil,error);
                    });
                },failureBlock:{(error:Error?) in
                    completion(nil,error);
                });
            }

        }, failureBlock: {(error:Error?) in
                completion(nil,error);
        })
    });
    }

}
