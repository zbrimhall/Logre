//
//  LTestCompletionController.h
//  Logre
//
//  Created by Cody Brimhall on 11/14/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LTestCompletionController : UIViewController {
	IBOutlet UIButton *retestButton;
	IBOutlet UIButton *startOverButton;
	IBOutlet UIButton *mainMenuButton;
	IBOutlet UITextView *textView;
	
	NSArray *correct;
	NSArray *incorrect;
}

@property (nonatomic, retain) NSArray *correct;
@property (nonatomic, retain) NSArray *incorrect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil correct:(NSArray *)correctList incorrect:(NSArray *)incorrectList;

- (IBAction)retest:(id)sender;
- (IBAction)startOver:(id)sender;
- (IBAction)mainMenu:(id)sender;

@end
