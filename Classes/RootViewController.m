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

@implementation RootViewController

@synthesize categories;
@synthesize words;

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


- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadWordsAndCategories];
	
	self.title = @"Logre";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return section == 0 ? @"Activities" : @"Word Categories";
}

- (void)loadWordsAndCategories {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Logre" ofType:@"plist"];
	NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
	
	[self.words release];
	[self.categories release];
	self.categories = [data objectForKey:LCategories];
	self.words = [data objectForKey:LWords];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[self.categories release];
	[self.words release];
	
    [super dealloc];
}


@end

