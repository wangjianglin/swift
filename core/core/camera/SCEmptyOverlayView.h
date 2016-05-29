//
//  SCWatermarkOverlayView.h
//  SCRecorderExamples
//
//  Created by Simon CORSIN on 16/06/15.
//
//

#import <UIKit/UIKit.h>
#import "SCVideoConfiguration.h"

@interface SCEmptyOverlayView : UIView<SCVideoOverlay>

@property (strong, nonatomic) NSDate *date;

@end
