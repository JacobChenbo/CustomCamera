//
//  CameroTopView.m
//  CameraDemo
//
//  Created by Jacob on 10/31/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import "CameroTopView.h"
#import <Masonry.h>

@interface CameroTopView()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *autoButton;
@property (nonatomic, strong) UIButton *openButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation CameroTopView

- (id)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor blackColor];
    
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.superview).offset(5);
        make.top.bottom.equalTo(button.superview);
        make.width.equalTo(@30);
    }];
    [button setImage:[UIImage imageNamed:@"Flash-lamp"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickButton) forControlEvents:UIControlEventTouchUpInside];
    self.flashButton = button;
    
    UIView *selectView = [UIView new];
    [self addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(10);
        make.top.bottom.right.equalTo(selectView.superview);
    }];
    
    UIColor *selectedColor = [UIColor colorWithRed:(float)((0xf7bb02 & 0xFF0000) >> 16) / 255.0 green:(float)((0xf7bb02 & 0xFF00) >> 8) / 255.0 blue:(float)(0xf7bb02 & 0xFF) / 255.0 alpha:1.0];
    
    UIButton *autoButton = [UIButton new];
    [selectView addSubview:autoButton];
    [autoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(autoButton.superview);
        make.width.equalTo(selectView.superview).multipliedBy(0.2);
    }];
    autoButton.tag = 0;
    [autoButton setTitle:@"自动" forState:UIControlStateNormal];
    autoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [autoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [autoButton setTitleColor:selectedColor forState:UIControlStateSelected];
    [autoButton addTarget:self action:@selector(changeFlashMode:) forControlEvents:UIControlEventTouchUpInside];
    self.autoButton = autoButton;
    
    UIButton *openButton = [UIButton new];
    [selectView addSubview:openButton];
    openButton.tag = 1;
    [openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(autoButton.superview);
        make.width.equalTo(autoButton);
        make.left.equalTo(autoButton.mas_right);
    }];
    [openButton setTitle:@"打开" forState:UIControlStateNormal];
    openButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openButton setTitleColor:selectedColor forState:UIControlStateSelected];
    [openButton addTarget:self action:@selector(changeFlashMode:) forControlEvents:UIControlEventTouchUpInside];
    self.openButton = openButton;
    
    UIButton *closeButton = [UIButton new];
    [selectView addSubview:closeButton];
    closeButton.tag = 2;
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(autoButton.superview);
        make.width.equalTo(autoButton);
        make.left.equalTo(openButton.mas_right);
    }];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:selectedColor forState:UIControlStateSelected];
    [closeButton addTarget:self action:@selector(changeFlashMode:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = closeButton;
    
    autoButton.selected = YES;
    selectView.alpha = 0.0;
    self.selectView = selectView;
}

- (void)onClickButton {
    if (self.selectView.alpha == 0.0) {
        [self showSelectView];
    } else {
        [self hideSelectView];
    }
}

- (void)changeFlashMode:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag == 0) {
        self.autoButton.selected = YES;
        self.openButton.selected = NO;
        self.closeButton.selected = NO;
        [self.flashButton setImage:[UIImage imageNamed:@"Flash-lamp"] forState:UIControlStateNormal];
    } else if (tag == 1) {
        self.autoButton.selected = NO;
        self.openButton.selected = YES;
        self.closeButton.selected = NO;
        [self.flashButton setImage:[UIImage imageNamed:@"Flash-yellow"] forState:UIControlStateNormal];
    } else if (tag == 2) {
        self.autoButton.selected = NO;
        self.openButton.selected = NO;
        self.closeButton.selected = YES;
        [self.flashButton setImage:[UIImage imageNamed:@"Flash-close"] forState:UIControlStateNormal];
    }
    [self hideSelectView];
    
    if (self.flashModeChangeBlock) {
        self.flashModeChangeBlock(tag);
    }
}

- (void)showSelectView {
    [UIView animateWithDuration:0.25 animations:^{
        self.selectView.alpha = 1.0;
    }];
}

- (void)hideSelectView {
    [UIView animateWithDuration:0.25 animations:^{
        self.selectView.alpha = 0.0;
    }];
}

@end
