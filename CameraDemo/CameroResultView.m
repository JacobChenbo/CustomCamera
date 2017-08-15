//
//  CameroResultView.m
//  CameraDemo
//
//  Created by Jacob on 10/27/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import "CameroResultView.h"
#import <Masonry.h>

@interface CameroResultView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CameroResultView

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (id)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.0;
    
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView.superview);
        make.size.mas_equalTo(CGSizeZero);
    }];
    self.imageView = imageView;
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:resetButton];
    [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(resetButton.superview).offset(16);
        make.bottom.equalTo(resetButton.superview).offset(-25);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    [resetButton setTitle:@"重拍" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [resetButton addTarget:self action:@selector(onClickResetButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *usePhotoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:usePhotoButton];
    [usePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(usePhotoButton.superview).offset(-15);
        make.bottom.equalTo(usePhotoButton.superview).offset(-25);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    [usePhotoButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [usePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    usePhotoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [usePhotoButton addTarget:self action:@selector(onClickUsePhotoButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickResetButton {
    [self dismiss];
    if (self.resetBlock) {
        self.resetBlock();
    }
}

- (void)onClickUsePhotoButton {
//    [self removeFromSuperview];
    if (self.usePhotoBlock) {
        self.usePhotoBlock();
    }
}

- (void)showWithImage:(UIImage *)image {
    _image = image;
    if (image == nil) {
        [self removeFromSuperview];
        return;
    }
    
    self.imageView.image = image;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(image.size);
    }];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finish) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finish) {
        [self removeFromSuperview];
    }];
}

@end
