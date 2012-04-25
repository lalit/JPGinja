//
//  FontManager.m
//  FontLabel
//
//
//  Created by Shailesh Namjoshi



#import "FontManager.h"
#import "MyFont.h"

static FontManager *sharedFontManager = nil;

@implementation FontManager
+ (FontManager *)sharedManager {
	@synchronized(self) {
		if (sharedFontManager == nil) {
			sharedFontManager = [[self alloc] init];
		}
	}
	return sharedFontManager;
}

- (id)init {
	if (self = [super init]) {
		fonts = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}
	return self;
}

- (BOOL)loadFont:(NSString *)filename {
	NSString *fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"ttf"];
	if (fontPath == nil) {
		fontPath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	}
	if (fontPath == nil) return NO;
	
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath fileSystemRepresentation]);
	if (fontDataProvider == NULL) return NO;
	CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider); 
	CGDataProviderRelease(fontDataProvider); 
	if (newFont == NULL) 
		return NO;
	
	CFDictionarySetValue(fonts, filename, newFont);
	CGFontRelease(newFont);
	// if all done, return
	return YES;
}

- (CGFontRef)fontWithName:(NSString *)filename {
	CGFontRef font = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	if (font == NULL && [self loadFont:filename]) {
		font = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	}
	return font;
}

- (MyFont *)MyFontWithName:(NSString *)filename pointSize:(CGFloat)pointSize {
	CGFontRef cgFont = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	if (cgFont == NULL && [self loadFont:filename]) {
		cgFont = (CGFontRef)CFDictionaryGetValue(fonts, filename);
	}
	if (cgFont != NULL) {
		return [MyFont fontWithCGFont:cgFont size:pointSize];
	}
	return nil;
}

- (CFArrayRef)copyAllFonts 
{
	CFIndex count = CFDictionaryGetCount(fonts);
	CGFontRef *values = (CGFontRef *)malloc(sizeof(CGFontRef) * count);
	CFDictionaryGetKeysAndValues(fonts, NULL, (const void **)values);
	CFArrayRef array = CFArrayCreate(NULL, (const void **)values, count, &kCFTypeArrayCallBacks);
	free(values);
	return array;
}

- (void)dealloc {
	CFRelease(fonts);
	[super dealloc];
}
@end
