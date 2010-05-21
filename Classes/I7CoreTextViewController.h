//
//  I7CoreTextViewController.h
//  CoreTextExample
//
//  Created by Jonas Schnelli on 19.05.10.
//  Copyright 2010 include7 AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "I7CoreTextView.h"

@interface I7CoreTextViewController : UIViewController {
	I7CoreTextView *coreTextView;
	UIScrollView *scrollView;
	
	UIView *loadingView;
}

@property (nonatomic, retain) IBOutlet I7CoreTextView *coreTextView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;


- (IBAction)fontSizeDidChange:(id)sender;
- (IBAction)textTypeDidChange:(id)sender;

@end
