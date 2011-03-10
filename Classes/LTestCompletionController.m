//
//  LTestCompletionController.m
//  Logre
//
//  Created by Cody Brimhall on 11/14/08.
//  Copyright 2008 http://somuchwit.com/. All rights reserved.
//

#import "LTestCompletionController.h"
#import "LTestViewController.h"


@implementation LTestCompletionController

@synthesize correct;
@synthesize incorrect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil correct:(NSArray *)correctList incorrect:(NSArray *)incorrectList {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		return nil;
	
	self.correct = correctList;
	self.incorrect = incorrectList;
	
    return self;
}

- (void)viewDidLoad {
	if([self.incorrect count] == 0) {
		[retestButton setUserInteractionEnabled:NO];
	}
}

- (IBAction)retest:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	LTestViewController *topView = (LTestViewController *)[navController topViewController];
	
	[navController dismissModalViewControllerAnimated:YES];
	[topView startRetest:self];
}

- (IBAction)startOver:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	LTestViewController *topView = (LTestViewController *)[navController topViewController];
	
	[navController dismissModalViewControllerAnimated:YES];
	[topView startNewTest:self];
}

- (IBAction)mainMenu:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	
	[navController popToRootViewControllerAnimated:YES];
	[navController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
