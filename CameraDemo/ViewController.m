//
//  ViewController.m
//  CameraDemo
//
//  Created by Jacob on 10/25/16.
//  Copyright © 2016 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "CameroViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *test = [[UIButton alloc] initWithFrame:CGRectMake(100, 80, 100, 50)];
    [self.view addSubview:test];
    [test setTitle:@"普通" forState:UIControlStateNormal];
    [test setBackgroundColor:[UIColor orangeColor]];
    [test addTarget:self action:@selector(onClickTest) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *test2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 160, 100, 50)];
    [self.view addSubview:test2];
    [test2 setTitle:@"截取" forState:UIControlStateNormal];
    [test2 setBackgroundColor:[UIColor orangeColor]];
    [test2 addTarget:self action:@selector(onClickTest2) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [UIImageView new];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView.superview);
    }];
    self.imageView = imageView;
}

- (void)onClickTest {
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CameroViewController *vc = [[CameroViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc setUseImageBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)onClickTest2 {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CameroViewController *vc = [[CameroViewController alloc] initWithTitle:@"将参照物置于此区域，并对准拍照" captureSize:CGSizeMake(width - 32, (width - 32) * (54 / 85.6))];
    [self presentViewController:vc animated:YES completion:nil];
    [vc setUseImageBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.imageView.image = nil;
}

@end
