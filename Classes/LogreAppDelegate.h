//
//  LogreAppDelegate.h
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright http://www.somuchwit.com/ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogreAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

