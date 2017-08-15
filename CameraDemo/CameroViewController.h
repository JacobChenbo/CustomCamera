//
//  CameroViewController.h
//  CameraDemo
//
//  Created by Jacob on 10/25/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameroViewController : UIViewController

// 整张图，跟系统相机一样
- (id)init;

// 截取
- (id)initWithTitle:(NSString *)title captureSize:(CGSize)captureSize;

@property (nonatomic, copy) void (^useImageBlock)(UIImage *image);

@end
