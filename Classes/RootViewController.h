//
//  RootViewController.h
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright http://www.somuchwit.com/ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


// Define constants for the Logre.plist keys
extern NSString *LCategories;
extern NSString *LCategory;
extern NSString *LWords;
extern NSString *LWord;

@interface RootViewController : UITableViewController {
	NSArray *categories;
	NSArray *words;
}

@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *words;

@end
