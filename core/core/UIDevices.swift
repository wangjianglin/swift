//
//  UIDevices.swift
//  seller iOS7
//
//  Created by lin on 2/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice{
    
    private func orientationString() -> String{
        switch self.orientation {
        case .Unknown:
            return "Unknown";
        case .Portrait: // Device oriented vertically, home button on the bottom:
            return "Portrait";
        case .PortraitUpsideDown: // Device oriented vertically, home button on the top:
            return "PortraitUpsideDown";
        case .LandscapeLeft: // Device oriented horizontally, home button on the right:
            return "LandscapeLeft";
        case .LandscapeRight: // Device oriented horizontally, home button on the left:
            return "LandscapeRight";
        case .FaceUp: // Device oriented flat, face up:
            return "FaceUp";
        case .FaceDown:
            return "FaceDown";
        }
    }
    
    private func batteryStateString() -> String{
        switch self.batteryState {
        case .Unknown:
            return "Unknown";
        case .Unplugged: // Device oriented vertically, home button on the bottom:
            return "Unplugged";
        case .Charging: // Device oriented vertically, home button on the top:
            return "Charging";
        case .Full: // Device oriented horizontally, home button on the right:
            return "Full";
        }
    }
    
    private func userInterfaceIdiomString() -> String{
        switch self.userInterfaceIdiom {
        case .Unspecified:
            return "Unspecified";
        case .Phone: // Device oriented vertically, home button on the bottom:
            return "Phone";
        case .Pad: // Device oriented vertically, home button on the top:
            return "Pad";
        case .TV:
            return "TV";
        }
    }
    
    public func toString()->String{
        
        var str = "name:" + self.name;
        str = str + "\nmodel:" + self.model;
        str = str + "\nlocalizedModel:" + self.localizedModel;
        str = str + "\nsystemName:" + self.systemName;
        str = str + "\nsystemVersion:" + self.systemVersion;
        str = str + "\norientation:" + self.orientationString();
        
        str = str + "\nidentifierForVendor:" + self.identifierForVendor!.description;
        str = str + "\ngeneratesDeviceOrientationNotifications:\(self.generatesDeviceOrientationNotifications)";
        str = str + "\nbatteryMonitoringEnabled:\(self.batteryMonitoringEnabled)";
        str = str + "\nbatteryState:\(self.batteryStateString())";
        
        str = str + "\nbatteryLevel:\(self.batteryLevel)";
        str = str + "\nproximityMonitoringEnabled:\(self.proximityMonitoringEnabled)";
        str = str + "\nproximityState:\(self.proximityState)";
        str = str + "\nmultitaskingSupported:\(self.multitaskingSupported)";
        str = str + "\nuserInterfaceIdiom:\(self.userInterfaceIdiomString())";
        
        
        return str;
        
    }
}