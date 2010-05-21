//
//  CoreTextExampleAppDelegate.h
//  CoreTextExample
//
//  Created by Jonas Schnelli on 18.05.10.
//  Copyright include7 AG 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "I7CoreTextViewController.h"


@interface CoreTextExampleAppDelegate : NSObject <UIApplicationDelegate> {
    
	I7CoreTextViewController *coreTextViewController;
    UIWindow *window;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet I7CoreTextViewController *coreTextViewController;



@end
