//
//  LinWebController.m
//  LinWeb
//
//  Created by lin on 3/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

//@implementation UIWebView (JavaScriptAlert)
//
//static BOOL diagStat = NO;
//
//-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame{
//    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
//    [dialogue show];
////    [dialogue autorelease];
//}
//
//-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame{
//    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:NSLocalizedString(@"Cancel", @"Cancel"), nil];
//    [dialogue show];
//    while (dialogue.hidden==NO && dialogue.superview!=nil) {
//        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
//    }
////    [dialogue release];
//    
//    return diagStat;
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==0) {
//        diagStat=YES;
//    }else if(buttonIndex==1){
//        diagStat=NO;
//    }
//}
//@end