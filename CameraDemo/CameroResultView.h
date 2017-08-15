//
//  CameroResultView.h
//  CameraDemo
//
//  Created by Jacob on 10/27/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameroResultView : UIView

@property (nonatomic, copy) void (^resetBlock)();
@property (nonatomic, copy) void (^usePhotoBlock)();
@property (nonatomic, strong) UIImage *image;

- (void)showWithImage:(UIImage *)image;
- (void)dismiss;

@end
