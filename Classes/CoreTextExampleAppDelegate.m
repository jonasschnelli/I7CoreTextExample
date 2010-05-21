//
//  CoreTextExampleAppDelegate.m
//  CoreTextExample
//
//  Created by Jonas Schnelli on 18.05.10.
//  Copyright include7 AG 2010. All rights reserved.
//

#import "CoreTextExampleAppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"




@implementation CoreTextExampleAppDelegate

@synthesize window, coreTextViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[window addSubview:coreTextViewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}



#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[coreTextViewController release];
	[window release];
	[super dealloc];
}


@end

