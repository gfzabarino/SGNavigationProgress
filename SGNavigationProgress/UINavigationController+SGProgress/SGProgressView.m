//
//  SGProgressView.m
//  SGNavigationProgress
//
//  Created by Ben on 19/03/2014.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "SGProgressView.h"

@interface SGProgressView ()
@property (nonatomic, strong) UIView *progressBar;
@end

@implementation SGProgressView

- (void)setProgress:(float)progress {
	_progress = (progress < 0) ? 0 :
				(progress > 1) ? 1 :
				progress;

	CGRect slice, remainder;
	CGRectDivide(self.bounds, &slice, &remainder, CGRectGetWidth(self.bounds) * _progress, CGRectMinXEdge);

	if (!CGRectEqualToRect(self.progressBar.frame, slice)) {
		self.progressBar.frame = slice;
	}
}

- (void)cancelAnimations:(BOOL)complete {
    if (!complete) {
        id presentationLayer = self.progressBar.layer.presentationLayer;
        if (presentationLayer) {
            CGRect frame = [presentationLayer frame];
            // fixes a bug in which a progress of 0 leaves a presentation layer frame of
            // CGRectZero, which makes look animations as if the height of the progress bar would be
            // also animating
            frame.size.height = self.progressBar.layer.frame.size.height;
            self.progressBar.layer.frame = frame;
        }
    }
    [self.progressBar.layer removeAllAnimations];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.frame = frame;
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
		self.progressBar = [[UIView alloc] init];
		self.progressBar.backgroundColor = self.tintColor;
		self.progress = 0;
		[self addSubview:self.progressBar];
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
	// 0.5 pt doesn't work well with autoresizingMask.
	frame.origin.y = ceilf(frame.origin.y);
	frame.size.height = floorf(frame.size.height);
	[super setFrame:frame];

	__weak typeof(self)weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		weakSelf.progress = weakSelf.progress;
	});
}

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	self.progressBar.backgroundColor = tintColor;
}

@end
