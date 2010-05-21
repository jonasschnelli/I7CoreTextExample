//
//  I7CoreTextView.h
//  CoreTextExample
//
//  Created by Jonas Schnelli on 18.05.10.
//  Copyright 2010 include7 AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


enum I7CoreTextViewTextType {
	I7CoreTextViewTextTypeFonts,
	I7CoreTextViewTextTypeParagraph
};

@interface I7CoreTextView : UIView {
	CFMutableArrayRef fontsMutable;
	CGFloat fontSize;
	CGFloat height;
	
	enum I7CoreTextViewTextType textType;
	
	CFMutableAttributedStringRef attrString;
}

@property (assign) CGFloat fontSize;
@property (assign) enum I7CoreTextViewTextType textType;
@property (readonly) CGFloat height;

- (void)loadMutableFonts;
- (void)calculateHeight;
- (void)buildText;
- (void)localInit;
@end
