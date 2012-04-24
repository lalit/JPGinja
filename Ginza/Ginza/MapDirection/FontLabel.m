//
//  FontLabel.m
//  FontLabel
//
//
//  Created by Shailesh Namjoshi



#import "FontLabel.h"
#import "FontManager.h"
#import "FontLabelStringDrawing.h"
#import "MyFont.h"

@interface MyFont (MyFontPrivate)
@property (nonatomic, readonly) CGFloat ratio;
@end

@implementation FontLabel
@synthesize _MyFont;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName pointSize:(CGFloat)pointSize {
		return [self initWithFrame:frame MyFont:[[FontManager sharedManager] MyFontWithName:fontName pointSize:pointSize]];
}

- (id)initWithFrame:(CGRect)frame MyFont:(MyFont *)font {
	if (self = [super initWithFrame:frame]) {
		_MyFont = [font retain];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame font:(CGFontRef)font pointSize:(CGFloat)pointSize {
	return [self initWithFrame:frame MyFont:[MyFont fontWithCGFont:font size:pointSize]];
}

- (CGFontRef)cgFont {
	return self._MyFont.cgFont;
}

- (void)setCGFont:(CGFontRef)font {
	if (self._MyFont.cgFont != font) {
		self._MyFont = [MyFont fontWithCGFont:font size:self._MyFont.pointSize];
	}
}

- (CGFloat)pointSize {
	return self._MyFont.pointSize;
}

- (void)setPointSize:(CGFloat)pointSize {
	if (self._MyFont.pointSize != pointSize) {
		self._MyFont = [MyFont fontWithCGFont:self._MyFont.cgFont size:pointSize];
	}
}

- (void)drawTextInRect:(CGRect)rect {
	if (self._MyFont == NULL) {
		[super drawTextInRect:rect];
		return;
	}
	
	// this method is documented as setting the text color for us, but that doesn't appear to be the case
	[self.textColor setFill];
	
	MyFont *actualFont = self._MyFont;
	CGSize origSize = rect.size;
	if (self.numberOfLines == 1) {
		origSize.height = actualFont.leading;
		CGPoint point = CGPointMake(rect.origin.x,
									rect.origin.y + ((rect.size.height - actualFont.leading) / 2.0f));
		if (self.adjustsFontSizeToFitWidth && self.minimumFontSize < actualFont.pointSize) {
			CGSize size = [self.text sizeWithMyFont:actualFont];
			if (size.width > rect.size.width) {
				CGFloat desiredRatio = (origSize.width * actualFont.ratio) / size.width;
				CGFloat desiredPointSize = desiredRatio * actualFont.pointSize / actualFont.ratio;
				actualFont = [actualFont fontWithSize:MAX(MAX(desiredPointSize, self.minimumFontSize), 1.0f)];
				size = [self.text sizeWithMyFont:actualFont
							  constrainedToSize:CGSizeMake(origSize.width, actualFont.leading)
								  lineBreakMode:self.lineBreakMode];
			}
			if (!CGSizeEqualToSize(origSize, size)) {
				switch (self.baselineAdjustment) {
					case UIBaselineAdjustmentAlignCenters:
						point.y += (origSize.height - size.height) / 2.0f;
						break;
					case UIBaselineAdjustmentAlignBaselines:
						point.y += (self._MyFont.ascender - actualFont.ascender);
						break;
					case UIBaselineAdjustmentNone:
						break;
				}
			}
		}
		rect = (CGRect){point, CGSizeMake(origSize.width, actualFont.leading)};
		[self.text drawInRect:rect withMyFont:actualFont lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
	} else {
		if (self.numberOfLines > 0) origSize.height = MIN(origSize.height, self.numberOfLines * actualFont.leading);
		CGSize size = [self.text sizeWithMyFont:actualFont constrainedToSize:origSize lineBreakMode:self.lineBreakMode];
		CGPoint point = rect.origin;
		point.y += MAX(rect.size.height - size.height, 0.0f) / 2.0f;
		rect = (CGRect){point, CGSizeMake(rect.size.width, size.height)};
		[self.text drawInRect:rect withMyFont:actualFont lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
	}
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
	if (self._MyFont == NULL) {
		return [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	}
	
	if (numberOfLines > 0) bounds.size.height = MIN(bounds.size.height, self._MyFont.leading * numberOfLines);
	bounds.size = [self.text sizeWithMyFont:self._MyFont constrainedToSize:bounds.size lineBreakMode:self.lineBreakMode];
	return bounds;
}

- (void)dealloc {
	[_MyFont release];
	[super dealloc];
}
@end
