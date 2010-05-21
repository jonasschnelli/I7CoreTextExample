//
//  I7CoreTextView.m
//  CoreTextExample
//
//  Created by Jonas Schnelli on 18.05.10.
//  Copyright 2010 include7 AG. All rights reserved.
//

#import "I7CoreTextView.h"


#define PADDING_LEFT 10.0
#define PADDING_TOP 10.0



@implementation I7CoreTextView

@synthesize fontSize,height,textType;

- (void)awakeFromNib {
	/* this will ensure that the layer will be redrawn when the user changes the autorotation */
	CALayer *layer = self.layer;
	[layer setNeedsDisplayOnBoundsChange:YES];
}

- (void)localInit {
	[self loadMutableFonts];
	fontSize = 24.0;
	[self buildText];
	[self calculateHeight];
}


- (void)calculateHeight {

	/* this methode will get the text height and change the frame size of self (the view) */
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
	
	CFRange fitRange = CFRangeMake(0,0);
	CGSize aSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, CFStringGetLength((CFStringRef)attrString)), NULL, CGSizeMake(self.frame.size.width,CGFLOAT_MAX), &fitRange);
	
	self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,aSize.height+PADDING_TOP+PADDING_TOP);	
}

- (void)loadMutableFonts {
	/* load all existing fonts */
	
	CTFontCollectionRef collection = CTFontCollectionCreateFromAvailableFonts(NULL);
	CFArrayRef fonts = CTFontCollectionCreateMatchingFontDescriptors(collection);
	CFIndex count = CFArrayGetCount(fonts);
	fontsMutable = CFArrayCreateMutable(kCFAllocatorDefault, count, NULL);
	
	for (int i = 0; i < count; i++)
	{
		CTFontDescriptorRef desc = (CTFontDescriptorRef)CFArrayGetValueAtIndex(fonts, i);	
		CFStringRef fontName = CTFontDescriptorCopyAttribute(desc,kCTFontNameAttribute);
		CFArrayAppendValue(fontsMutable, fontName);
		CFRelease(fontName);
	}
	
    CFArraySortValues(fontsMutable, CFRangeMake(0, count), (CFComparatorFunction)CFStringCompare, NULL);
	CFRelease(fonts);
}


- (void)buildText {
	/* build the text */
	
	if(attrString) {
		CFRelease(attrString);
	}
	NSMutableString *mString;
	attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
	
	if(textType == I7CoreTextViewTextTypeFonts) {
		
		attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
		mString = [[NSMutableString alloc] init];
		for (int i = 0; i < CFArrayGetCount(fontsMutable); i++)
		{
			CFStringRef fontName = CFArrayGetValueAtIndex(fontsMutable,i);
			
			[mString appendString:(NSString *)fontName];
			[mString appendString:@"\n"];
		}
		
		
		CFStringRef string = (CFStringRef)mString;
		CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), string);
		
		
		
		
		/* change every font text with the correspondending font  */
		for (int i = 0; i < CFArrayGetCount(fontsMutable); i++)
		{
			CFStringRef fontName = CFArrayGetValueAtIndex(fontsMutable,i);
			CTFontRef myFont = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL); 
			CFRange range = CFStringFind((CFStringRef)mString, fontName, kCFCompareCaseInsensitive);
			CFAttributedStringSetAttribute(attrString, range, kCTFontAttributeName, myFont);
		}
		
	}
	else {
		mString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sampleText" ofType:@"txt"]];
		
		CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef)mString);
		
		CFStringRef fontName = (CFStringRef)@"Helvetica";
		CTFontRef myFont = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL); 
		CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFStringGetLength((CFStringRef)mString)), kCTFontAttributeName, myFont);
		
		
		
		
		
		/* set some dummy attributes  */
		CTFontRef myFont2 = CTFontCreateWithName((CFStringRef)@"Helvetica Bold", fontSize, NULL); 
		CTFontRef myFont3 = CTFontCreateWithName((CFStringRef)@"SnellRoundhand-Bold", fontSize*2, NULL); 
		
		CFRange range = CFStringFind((CFStringRef)mString, (CFStringRef)@"Lorem", kCFCompareCaseInsensitive);
		CFAttributedStringSetAttribute(attrString, range, kCTFontAttributeName, myFont2);
		
		
		CFRange range2 = CFStringFind((CFStringRef)mString, (CFStringRef)@"dolor", kCFCompareCaseInsensitive);
		CFAttributedStringSetAttribute(attrString, range2, kCTFontAttributeName, myFont3);	
		
		
		CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
		CGFloat components[] = { 1.0, 0.3, 0.3, 0.8 };
		CGColorRef red = CGColorCreate(rgbColorSpace, components);
		CGColorSpaceRelease(rgbColorSpace);
		CFAttributedStringSetAttribute(attrString, range2,
									   kCTForegroundColorAttributeName, red);
		
		CFRelease(red);
		
	}
	
	[mString release];
	
	CTTextAlignment alignment = kCTLeftTextAlignment;
	CTParagraphStyleSetting settings[] = {
		{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
	};
	CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
	CFAttributedStringSetAttribute(attrString, CFRangeMake(0, CFStringGetLength((CFStringRef)attrString)), kCTParagraphStyleAttributeName, paragraphStyle);
}

- (void) drawRect:(CGRect)rect {
	/* draw it */
	
	if(!fontsMutable) {
		/* if no fonts loaded, cancel! */
		return;
	}
	
	if(!attrString) {
		[self buildText];
	}

	
	
	/* get the context */
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	/* flip the coordinate system */
	
	float viewHeight = self.bounds.size.height;
    CGContextTranslateCTM(context, 0, viewHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, 1.0));
	
	
	/* generate the path for the text */
	CGMutablePathRef path = CGPathCreateMutable();
	CGRect bounds = CGRectMake(PADDING_LEFT, -PADDING_TOP, self.bounds.size.width-20.0, self.bounds.size.height);
	CGPathAddRect(path, NULL, bounds);
	
	
	
	/* draw the text */
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
												CFRangeMake(0, 0), path, NULL);
	CFRelease(framesetter);
	CFRelease(path);
	CTFrameDraw(frame, context);
}


@end
