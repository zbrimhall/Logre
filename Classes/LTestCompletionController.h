//
//  LTestCompletionController.h
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


@interface LTestCompletionController : UIViewController {
	IBOutlet UIButton *retestButton;
	IBOutlet UIButton *startOverButton;
	IBOutlet UIButton *mainMenuButton;
	IBOutlet UITextView *textView;
	
	NSArray *correct;
	NSArray *incorrect;
}

@property (nonatomic, retain) NSArray *correct;
@property (nonatomic, retain) NSArray *incorrect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil correct:(NSArray *)correctList incorrect:(NSArray *)incorrectList;

- (IBAction)retest:(id)sender;
- (IBAction)startOver:(id)sender;
- (IBAction)mainMenu:(id)sender;

@end
