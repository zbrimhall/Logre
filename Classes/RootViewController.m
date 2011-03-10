//
//  RootViewController.m
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright http://www.somuchwit.com/ 2008. All rights reserved.
//

#import "RootViewController.h"
#import "LogreAppDelegate.h"
#import "LCategoryViewController.h"
#import "LTestViewController.h"


NSString *LCategories = @"LCategories";
NSString *LCategory = @"LCategory";
NSString *LWords = @"LWords";
NSString *LWord = @"LWord";

@interface RootViewController (Private)
- (void)L_loadWordsAndCategories;
@end

@implementation RootViewController

@synthesize categories;
@synthesize words;

#pragma mark -
#pragma mark Setup/Teardown

- (void)dealloc {
	[self.categories release];
	[self.words release];
	
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self L_loadWordsAndCategories];
	
	self.title = @"Logre";
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.text = indexPath.section == 0 ? @"Take Test" : [self.categories objectAtIndex:indexPath.row];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == 0 ? @"Activities" : @"Word Categories";
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller;
	NSMutableArray *wordList;
	
	if(indexPath.section == 0) {
		controller = [[[LTestViewController alloc] initWithStyle:UITableViewStyleGrouped categories:self.categories words:self.words] autorelease];
		controller.title = @"Vocabulary Test";
	}
	else {
		wordList = [NSMutableArray arrayWithCapacity:10];
		for(NSDictionary *word in self.words) {
			if([[word objectForKey:LCategory] intValue] == indexPath.row)
				[wordList addObject:[word objectForKey:LWord]];
		}
		
		[wordList sortUsingSelector:@selector(caseInsensitiveCompare:)];
		controller = [[[LCategoryViewController alloc] initWithStyle:UITableViewStylePlain words:wordList] autorelease];
		controller.title = [self.categories objectAtIndex:indexPath.row];
	}
	
	[self.navigationController pushViewController:controller animated:YES];
}

@end

#pragma mark -
#pragma mark -

@implementation RootViewController (Private)

/**
 * Load the list of words and word categories from the plists stored in the app
 * bundle.
 */
- (void)L_loadWordsAndCategories {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Logre" ofType:@"plist"];
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
	
	[self.words release];
	[self.categories release];
	self.categories = [data objectForKey:LCategories];
	self.words = [data objectForKey:LWords];
}

@end