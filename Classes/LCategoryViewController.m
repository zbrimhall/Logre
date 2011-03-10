//
//  LCategoryViewController.m
//  Logre
//
//  Created by Cody Brimhall on 11/13/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import "LCategoryViewController.h"


@implementation LCategoryViewController

@synthesize words;

- (id)initWithStyle:(UITableViewStyle)style words:(NSArray *)wordList {
	if(!(self = [super initWithStyle:style]))
		return nil;
	
	self.words = wordList;
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CategoryViewCellIdentifier = @"CategoryViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryViewCellIdentifier];
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CategoryViewCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	cell.text = [self.words objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[self.words release];
    [super dealloc];
}


@end

