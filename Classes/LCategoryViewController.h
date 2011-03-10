//
//  LCategoryViewController.h
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCategoryViewController : UITableViewController {
	NSArray *words;
}

@property (nonatomic, retain) NSArray *words;

- (id)initWithStyle:(UITableViewStyle)style words:(NSArray *)wordList;

@end
