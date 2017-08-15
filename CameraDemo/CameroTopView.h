//
//  CameroTopView.h
//  CameraDemo
//
//  Created by Jacob on 10/31/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameroTopView : UIView

@property (nonatomic, copy) void (^flashModeChangeBlock)(NSInteger index);

@end
