    //
//  I7CoreTextViewController.m
//  CoreTextExample
//
//  Created by Jonas Schnelli on 19.05.10.
//  Copyright 2010 include7 AG. All rights reserved.
//

#import "I7CoreTextViewController.h"


@implementation I7CoreTextViewController

@synthesize coreTextView, scrollView, loadingView;



#pragma mark -
#pragma mark navigation bar buttons

- (IBAction)textTypeDidChange:(id)sender {
	loadingView.hidden = NO;
	
	UISegmentedControl *textTypeControl = (UISegmentedControl *)sender;
	
	if(textTypeControl.selectedSegmentIndex == 0) {
		coreTextView.textType = I7CoreTextViewTextTypeFonts;	
	}
	if(textTypeControl.selectedSegmentIndex == 1) {
		coreTextView.textType = I7CoreTextViewTextTypeParagraph;	
	}
	
	
	[self performSelector:@selector(updateContent) withObject:nil afterDelay:0.0];
	
	
}

- (IBAction)fontSizeDidChange:(id)sender {
	loadingView.hidden = NO;
	
	UISegmentedControl *fontSizeSender = (UISegmentedControl *)sender;
	
	if(fontSizeSender.selectedSegmentIndex == 0) {
		coreTextView.fontSize = 14;	
	}
	if(fontSizeSender.selectedSegmentIndex == 1) {
		coreTextView.fontSize = 18;	
	}
	if(fontSizeSender.selectedSegmentIndex == 2) {
		coreTextView.fontSize = 24;	
	}
	if(fontSizeSender.selectedSegmentIndex == 3) {
		coreTextView.fontSize = 32;	
	}
	if(fontSizeSender.selectedSegmentIndex == 4) {
		coreTextView.fontSize = 56;	
	}
	
	[self performSelector:@selector(updateContent) withObject:nil afterDelay:0.0];
	
}

- (void)updateContent {
	[coreTextView buildText];
	[coreTextView calculateHeight];
	[coreTextView setNeedsDisplay];
	
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width,coreTextView.frame.size.height);	
	
	[self performSelector:@selector(hideLoading) withObject:nil afterDelay:0.0];
}

- (void)hideLoading {
	loadingView.hidden = YES;	
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width,coreTextView.frame.size.height);
	[scrollView addSubview:coreTextView];	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	/* build text
	 use dumb multithreading */
	[self performSelector:@selector(firstUpdate) withObject:nil afterDelay:0.0];
}

- (void)firstUpdate {
	/* very very dumb multithreading */
	/* i know, it's lame! */
	[coreTextView localInit];
	scrollView.contentSize = CGSizeMake(self.view.frame.size.width,coreTextView.frame.size.height);
	[self hideLoading];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[coreTextView release];
	[scrollView release];
	[loadingView release];
    [super dealloc];
}


@end
