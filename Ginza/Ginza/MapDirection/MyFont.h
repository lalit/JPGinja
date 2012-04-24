//
//  MyFont.h
//  FontLabel
//
//
//  Created by Shailesh Namjoshi



#import <Foundation/Foundation.h>

@interface MyFont : NSObject {
	CGFontRef _cgFont;
	CGFloat _pointSize;
	CGFloat _ratio;
	NSString *_familyName;
	NSString *_fontName;
	NSString *_postScriptName;
}
@property (nonatomic, readonly) CGFontRef cgFont;
@property (nonatomic, readonly) CGFloat pointSize;
@property (nonatomic, readonly) CGFloat ascender;
@property (nonatomic, readonly) CGFloat descender;
@property (nonatomic, readonly) CGFloat leading;
@property (nonatomic, readonly) CGFloat xHeight;
@property (nonatomic, readonly) CGFloat capHeight;
@property (nonatomic, readonly) NSString *familyName;
@property (nonatomic, readonly) NSString *fontName;
@property (nonatomic, readonly) NSString *postScriptName;



+ (MyFont *)fontWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize;
- (id)initWithCGFont:(CGFontRef)cgFont size:(CGFloat)fontSize;
- (MyFont *)fontWithSize:(CGFloat)fontSize;
@end
