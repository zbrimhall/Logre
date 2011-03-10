//
//  LTestViewController.h
//  Logre
//
//  Created by Cody Brimhall on 11/14/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const NSInteger LTestViewAnswerOptionCount;
extern NSString *QuestionCellIdentifier;
extern NSString *AnswerCellIdentifier;

@interface LTestViewController : UITableViewController {
	NSArray *categories;
	NSArray *words;
	
	NSDictionary *currentWord;
	NSMutableArray *answerOptions;
	NSMutableArray *correct;
	NSMutableArray *incorrect;
	NSMutableArray *remaining;

	NSTimer *advancementTimer;
}

@property(nonatomic, retain) NSArray *categories;
@property(nonatomic, retain) NSArray *words;

- (id)initWithStyle:(UITableViewStyle)style categories:(NSArray *)categoryList words:(NSArray *)wordList;
- (IBAction)startNewTest:(id)sender;
- (IBAction)startRetest:(id)sender;
- (void)advance:(NSTimer *)firedTimer;

@end
