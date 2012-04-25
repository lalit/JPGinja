//
//  FontLabelStringDrawing.h
//  FontLabel
//
//
//  Created by Shailesh Namjoshi



#import <UIKit/UIKit.h>

@class MyFont;

@interface NSString (FontLabelStringDrawing)
// CGFontRef-based methods
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize constrainedToSize:(CGSize)size __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)sizeWithCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize constrainedToSize:(CGSize)size
		   lineBreakMode:(UILineBreakMode)lineBreakMode __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawAtPoint:(CGPoint)point withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize
	   lineBreakMode:(UILineBreakMode)lineBreakMode __AVAILABILITY_INTERNAL_DEPRECATED;
- (CGSize)drawInRect:(CGRect)rect withCGFont:(CGFontRef)font pointSize:(CGFloat)pointSize
	   lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment __AVAILABILITY_INTERNAL_DEPRECATED;

// MyFont-based methods
- (CGSize)sizeWithMyFont:(MyFont *)font;
- (CGSize)sizeWithMyFont:(MyFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithMyFont:(MyFont *)font constrainedToSize:(CGSize)size lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawAtPoint:(CGPoint)point withMyFont:(MyFont *)font;
- (CGSize)drawInRect:(CGRect)rect withMyFont:(MyFont *)font;
- (CGSize)drawInRect:(CGRect)rect withMyFont:(MyFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode;
- (CGSize)drawInRect:(CGRect)rect withMyFont:(MyFont *)font lineBreakMode:(UILineBreakMode)lineBreakMode
		   alignment:(UITextAlignment)alignment;
@end
