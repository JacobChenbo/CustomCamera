//
//  CameroCaptureView.m
//  CameraDemo
//
//  Created by Jacob on 10/26/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import "CameroCaptureView.h"
#import <Masonry.h>

@interface CameroCaptureView()

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) CGRect captureAreaFrame;

@end

@implementation CameroCaptureView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title captureFrame:(CGRect)captureFrame {
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.captureAreaFrame = captureFrame;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.opaque = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.captureAreaFrame) + 18, self.frame.size.width, 20)];
    [self addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.text = self.title;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor( context, [UIColor blackColor].CGColor );
    CGContextFillRect( context, rect );
    
    if (CGRectIntersectsRect(self.captureAreaFrame, rect)) {
        CGContextSetBlendMode(context, kCGBlendModeClear);
        [[UIColor clearColor] set];
        CGContextFillRect(context, self.captureAreaFrame);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
    }
    
    // 画线
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame), CGRectGetMinY(self.captureAreaFrame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame), CGRectGetMinY(self.captureAreaFrame));
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame), CGRectGetMinY(self.captureAreaFrame));
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame), CGRectGetMaxY(self.captureAreaFrame));
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame), CGRectGetMaxY(self.captureAreaFrame));
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame), CGRectGetMaxY(self.captureAreaFrame));
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame), CGRectGetMaxY(self.captureAreaFrame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame), CGRectGetMinY(self.captureAreaFrame));
    
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context, 2.0);
//    CGContextSetRGBStrokeColor(context, 9 / 255.0, 188 / 255.0, 7 / 255.0, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5 + 14, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5 + 14);
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMaxY(self.captureAreaFrame)  - 0.5);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5 + 14, CGRectGetMaxY(self.captureAreaFrame) - 0.5);
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMaxY(self.captureAreaFrame) - 0.5);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.captureAreaFrame) + 0.5, CGRectGetMaxY(self.captureAreaFrame) - 0.5 - 14);
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5 - 14, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMinY(self.captureAreaFrame) + 0.5 + 14);
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMaxY(self.captureAreaFrame) - 0.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5 - 14, CGRectGetMaxY(self.captureAreaFrame) - 0.5);
    
    CGContextMoveToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMaxY(self.captureAreaFrame) - 0.5);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.captureAreaFrame) - 0.5, CGRectGetMaxY(self.captureAreaFrame) - 0.5 - 14);
    
    CGContextStrokePath(context);
}

@end
