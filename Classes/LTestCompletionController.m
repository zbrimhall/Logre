//
//  LTestCompletionController.m
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

#import "LTestCompletionController.h"
#import "LTestViewController.h"


@implementation LTestCompletionController

@synthesize correct;
@synthesize incorrect;

#pragma mark -
#pragma mark  Setup/Teardown


- (void)dealloc {
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil correct:(NSArray *)correctList incorrect:(NSArray *)incorrectList {
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		return nil;
	
	self.correct = correctList;
	self.incorrect = incorrectList;
	
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	if([self.incorrect count] == 0) {
		[retestButton setUserInteractionEnabled:NO];
	}
}

#pragma mark -
#pragma mark Actions

/**
 * Dismiss the test completion view and restart the test using only the words
 * that the user answered incorrectly in the previous test.
 */
- (IBAction)retest:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	LTestViewController *topView = (LTestViewController *)[navController topViewController];
	
	[navController dismissModalViewControllerAnimated:YES];
	[topView startRetest:self];
}

/**
 * Dismiss the test completion view and restart the entire test from scratch.
 */
- (IBAction)startOver:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	LTestViewController *topView = (LTestViewController *)[navController topViewController];
	
	[navController dismissModalViewControllerAnimated:YES];
	[topView startNewTest:self];
}

/**
 * Dismiss all of the testing views and return the user to the main menu view.
 */
- (IBAction)mainMenu:(id)sender {
	UINavigationController *navController = (UINavigationController *)self.parentViewController;
	
	[navController popToRootViewControllerAnimated:YES];
	[navController dismissModalViewControllerAnimated:YES];
}


@end
