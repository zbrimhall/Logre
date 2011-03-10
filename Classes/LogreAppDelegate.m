//
//  LogreAppDelegate.m
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright http://www.somuchwit.com/ 2008. All rights reserved.
//

#import "LogreAppDelegate.h"
#import "RootViewController.h"


@implementation LogreAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
