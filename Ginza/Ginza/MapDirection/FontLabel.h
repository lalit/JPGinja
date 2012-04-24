//
//  FontLabel.h
//  FontLabel
//
//  Created by Shailesh Namjoshi


#import <Foundation/Foundation.h>

@class MyFont;

@interface FontLabel : UILabel 
{
	void *reserved; // works around a bug in UILabel
	MyFont *_MyFont;
}

@property (nonatomic, setter=setCGFont:) CGFontRef cgFont __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, assign) CGFloat pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@property (nonatomic, retain, setter=setMyFont:) MyFont *_MyFont;


// -initWithFrame:fontName:pointSize: uses FontManager to look up the font name
- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize;
- (id)initWithFrame:(CGRect)frame MyFont:(MyFont *)font;
- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize __AVAILABILITY_INTERNAL_DEPRECATED;
@end
