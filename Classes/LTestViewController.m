//
//  LTestViewController.m
//  Logre
//
//  Created by Cody Brimhall on 11/14/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "LTestViewController.h"
#import "RootViewController.h"
#import "LTestCompletionController.h"


const NSInteger LTestViewAnswerOptionCount = 6;
NSString *QuestionCellIdentifier = @"QuestionCellIdentifier";
NSString *AnswerCellIdentifier = @"AnswerCellIdentifier";

@implementation LTestViewController

@synthesize categories;
@synthesize words;

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

- (void)viewDidLoad {
	[self.tableView setScrollEnabled:NO];
	[self startNewTest:self];
}

- (IBAction)startNewTest:(id)sender {
	[correct removeAllObjects];
	[incorrect removeAllObjects];
	[remaining addObjectsFromArray:self.words];
	[self shuffleRemaining];
	[self enableAnswers];
	
	[self showNextWord];
}

- (IBAction)startRetest:(id)sender {
	[remaining addObjectsFromArray:incorrect];
	[incorrect removeAllObjects];
	[self shuffleRemaining];
	[self enableAnswers];
	
	[self showNextWord];
}

- (void)shuffleRemaining {
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

- (void)showNextWord {
	int candidate;
	int count;
	BOOL good;
	
	if(![remaining count]) {
		[self disableAnswers];
		[self raiseCompletionModal];
		
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger indices[2];
	NSUInteger correctAnswer;
	NSUInteger correctAnswerIndex;
	UITableViewCell *selectedCell;
	UITableViewCell *correctCell;
	
	if(indexPath.section == 0)
		return;
	
	[self disableAnswers];
	
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

- (void)advance:(NSTimer *)firedTimer {
	[advancementTimer invalidate];
	advancementTimer = nil;
	
	[remaining removeLastObject];
	[self enableAnswers];
	[self showNextWord];
}

- (void)disableAnswers {
	[self.tableView setUserInteractionEnabled:NO];
}

- (void)enableAnswers {
	[self.tableView setUserInteractionEnabled:YES];
}

- (void)raiseCompletionModal {
	LTestCompletionController *modal = [[[LTestCompletionController alloc] initWithNibName:@"LTestCompletionController" bundle:nil correct:correct incorrect:incorrect] autorelease];
	[self.navigationController presentModalViewController:modal animated:YES];
}

- (void)dealloc {
	[self.categories release];
	[self.words release];
	[correct release];
	[incorrect release];
	[remaining release];
	
    [super dealloc];
}


@end

