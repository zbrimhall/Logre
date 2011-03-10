//
//  RootViewController.m
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
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