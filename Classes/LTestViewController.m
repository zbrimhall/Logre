//
//  LTestViewController.m
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

#import <AudioToolbox/AudioServices.h>
#import "LTestViewController.h"
#import "RootViewController.h"
#import "LTestCompletionController.h"


const NSInteger LTestViewAnswerOptionCount = 6;
NSString *QuestionCellIdentifier = @"QuestionCellIdentifier";
NSString *AnswerCellIdentifier = @"AnswerCellIdentifier";

@interface LTestViewController (Private)
- (void)L_shuffleRemaining;
- (void)L_showNextWord;
- (void)L_disableAnswers;
- (void)L_enableAnswers;
- (void)L_raiseCompletionModal;
@end

@implementation LTestViewController

@synthesize categories;
@synthesize words;

#pragma mark -
#pragma mark Setup/Teardown

- (void)dealloc {
	[self.categories release];
	[self.words release];
	[correct release];
	[incorrect release];
	[remaining release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style categories:(NSArray *)categoryList words:(NSArray *)wordList {
    if (!(self = [super initWithStyle:style]))
		return nil;
	
	self.categories = categoryList;
	self.words = wordList;
	
	correct = [[NSMutableArray alloc] initWithCapacity:[self.words count]];
	incorrect = [[NSMutableArray alloc] initWithCapacity:[self.words count]];
	remaining = [[NSMutableArray alloc] initWithCapacity:[self.words count]];
	answerOptions = [[NSMutableArray alloc] initWithCapacity:LTestViewAnswerOptionCount];
	
    return self;
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	[self.tableView setScrollEnabled:NO];
	[self startNewTest:self];
}

#pragma mark -
#pragma mark Actions

/**
 * Clear the answered and unanswered lists, shuffle the remaining words, and
 * show the first one.
 */
- (IBAction)startNewTest:(id)sender {
	[correct removeAllObjects];
	[incorrect removeAllObjects];
	[remaining addObjectsFromArray:self.words];
	[self L_shuffleRemaining];
	[self L_enableAnswers];
	
	[self L_showNextWord];
}

/**
 * Take the list of words that were answered incorrectly in the previous
 * iteration of the test and use them as the new list of words to be tested.
 * Shuffle them and show the first one.
 */
- (IBAction)startRetest:(id)sender {
	[remaining addObjectsFromArray:incorrect];
	[incorrect removeAllObjects];
	[self L_shuffleRemaining];
	[self L_enableAnswers];
	
	[self L_showNextWord];
}

/**
 * Show the next word in the unanswered queue.
 */
- (void)advance:(NSTimer *)firedTimer {
	[advancementTimer invalidate];
	advancementTimer = nil;
	
	[remaining removeLastObject];
	[self L_enableAnswers];
	[self L_showNextWord];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : LTestViewAnswerOptionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *idToUse = indexPath.section == 0 ? QuestionCellIdentifier : AnswerCellIdentifier;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idToUse];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:idToUse] autorelease];
	}
	
	if(indexPath.section == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.text = [currentWord objectForKey:LWord];
	}
	else {
		cell.text = [self.categories objectAtIndex:[[answerOptions objectAtIndex:indexPath.row] intValue]];
		cell.selected = NO;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == 0 ? @"Question" : @"Answer";
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger indices[2];
	NSUInteger correctAnswer;
	NSUInteger correctAnswerIndex;
	UITableViewCell *selectedCell;
	UITableViewCell *correctCell;
	
	if(indexPath.section == 0)
		return;
	
	[self L_disableAnswers];
	
	correctAnswer = [[currentWord objectForKey:LCategory] intValue];
	
	for(NSNumber *number in answerOptions) {
		if([number intValue] == correctAnswer) {
			correctAnswerIndex = [answerOptions indexOfObject:number];
			break;
		}
	}
	
	indices[0] = 1;
	indices[1] = correctAnswerIndex;
	
	selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
	correctCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndexes:indices length:2]];
	correctCell.accessoryType = UITableViewCellAccessoryCheckmark;
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([[answerOptions objectAtIndex:indexPath.row] intValue] == [[currentWord objectForKey:LCategory] intValue])
		[correct addObject:currentWord];
	else {
		[incorrect addObject:currentWord];
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
	
	if(advancementTimer == nil || ![advancementTimer isValid])
		advancementTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(advance:) userInfo:nil repeats:NO];
}

@end

#pragma mark -
#pragma mark -

@implementation LTestViewController (Private)

/**
 * Shuffle the list of remaining words.
 */
- (void)L_shuffleRemaining {
	NSDictionary *current;
	NSDictionary *replacement;
	int newIndex;
	int count = [remaining count];
	
	srand((unsigned int)time(NULL));
	
	for(int index = 0; index < count; index++) {
		newIndex = rand() % count;
		
		if(index == newIndex)
			continue;
		
		current = [remaining objectAtIndex:index];
		replacement = [remaining objectAtIndex:newIndex];
		[remaining replaceObjectAtIndex:newIndex withObject:current];
		[remaining replaceObjectAtIndex:index withObject:replacement];
	}
}

/**
 * Load the view with the next word and six suitable answer options.
 */
- (void)L_showNextWord {
	int candidate;
	int count;
	BOOL good;
	
	if(![remaining count]) {
		[self L_disableAnswers];
		[self L_raiseCompletionModal];
		
		return;
	}
	
	currentWord = [remaining lastObject];
	[answerOptions removeAllObjects];
	[answerOptions addObject:[currentWord objectForKey:LCategory]];
	count = [self.categories count];
	
	srand((unsigned int)time(NULL));
	
	for(int i = 1; i < LTestViewAnswerOptionCount; i++) {
		do {
			candidate = rand() % count;
			good = YES;
			
			for(int n = 0; n < i; n++) {
				if([[answerOptions objectAtIndex:n] intValue] == candidate) {
					good = NO;
					break;
				}
			}
		} while(!good);
		
		[answerOptions insertObject:[NSNumber numberWithInt:candidate] atIndex:i];
	}
	
	[answerOptions sortUsingSelector:@selector(compare:)];
	[self.tableView reloadData];
}

/**
 * Disable user interaction with the answers table.
 */
- (void)L_disableAnswers {
	[self.tableView setUserInteractionEnabled:NO];
}

/**
 * Enable user interaction with the answers table.
 */
- (void)L_enableAnswers {
	[self.tableView setUserInteractionEnabled:YES];
}

/**
 * Raise the modal view that presents the completed test results.
 */
- (void)L_raiseCompletionModal {
	LTestCompletionController *modal = [[[LTestCompletionController alloc] initWithNibName:@"LTestCompletionController" bundle:nil correct:correct incorrect:incorrect] autorelease];
	[self.navigationController presentModalViewController:modal animated:YES];
}

@end