//
//  LTestViewController.h
//  Logre
//
//  Created by Cody Brimhall on 11/14/08.
//  Copyright 2008 Cody Brimhall
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
