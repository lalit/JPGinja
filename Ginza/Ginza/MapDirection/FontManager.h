//
//  FontManager.h
//  FontLabel
//
//
//  Created by Shailesh Namjoshi
//



#import <Foundation/Foundation.h>

@class MyFont;

@interface FontManager : NSObject {
	CFMutableDictionaryRef fonts;
}
+ (FontManager *)sharedManager;
/*!
    @method     
    @abstract   Loads a TTF font from the main bundle
	@param filename The name of the font file to load (with no extension)
	@return YES if the font was loaded, NO if an error occurred
    @discussion If the font has already been loaded, this method does nothing and returns YES.
*/
- (BOOL)loadFont:(NSString *)filename;
/*!
    @method     
    @abstract   Returns the loaded font with the given filename
	@param filename The name of the font file that was given to -loadFont:
	@return A CGFontRef, or NULL if the specified font cannot be found
    @discussion If the font has not been loaded yet, -loadFont: will be
                called with the given name first.
*/
- (CGFontRef)fontWithName:(NSString *)filename __AVAILABILITY_INTERNAL_DEPRECATED;
/*!
	@method
	@abstract	Returns a MyFont object corresponding to the loaded font with the given filename and point size
	@param filename The name of the font file that was given to -loadFont:
	@param pointSize The point size of the font
	@return A MyFont, or NULL if the specified font cannot be found
	@discussion If the font has not been loaded yet, -loadFont: will be
				called with the given name first.
*/
- (MyFont *)MyFontWithName:(NSString *)filename pointSize:(CGFloat)pointSize;
/*!
	@method
	@abstract   Returns a CFArrayRef of all loaded CGFont objects
	@return A CFArrayRef of all loaded CGFont objects
	@description You are responsible for releasing the CFArrayRef
*/
- (CFArrayRef)copyAllFonts;
@end
