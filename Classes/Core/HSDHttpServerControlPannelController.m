//
//  HSDHttpServerControlPannelController.m
//  HttpServerDebug
//
//  Created by chenjun on 18/07/2017.
//  Copyright © 2017 Baidu Inc. All rights reserved.
//

#import "HSDHttpServerControlPannelController.h"
#import "HSDManager.h"
#import "HSDDefine.h"

@interface HSDHttpServerControlPannelController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UIButton *stopButton;

@end

@implementation HSDHttpServerControlPannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat top = statusBarHeight + 44;
    // header
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, top);
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerView];
    
    UILabel *headerTitleLabel = [[UILabel alloc] init];
    headerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    headerTitleLabel.text = @"HSD";
    headerTitleLabel.textColor = [UIColor blackColor];
    headerTitleLabel.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:headerTitleLabel];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:headerTitleLabel attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:headerView attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0], [NSLayoutConstraint constraintWithItem:headerTitleLabel attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:headerView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:statusBarHeight / 2.f]]];
    
    CGFloat edgeLength = 5.f;
    CGFloat contentSizeHeight = 0;
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    CGFloat bottom = 64;
    CGRect scrollViewFrame = self.view.bounds;
    scrollViewFrame.origin.y = top;
    scrollViewFrame.size.height -= top + bottom;
    self.scrollView.frame = scrollViewFrame;
    [self.view addSubview:self.scrollView];
    
    // textView
    self.textView = [[UITextView alloc] init];
    CGFloat textViewHeight = 120.f;
    self.textView.frame = CGRectMake(edgeLength, edgeLength, scrollViewFrame.size.width - edgeLength * 2, textViewHeight);
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 1.f;
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:14];
    NSString *text = @"";
    if ([HSDManager isHttpServerRunning]) {
        text = [HSDManager fetchAlternateServerSites];
    }
    self.textView.text = text;
    [self.scrollView addSubview:self.textView];
    contentSizeHeight += edgeLength + textViewHeight;
    
    // 启动
    UIView *contentView = [[UIView alloc] init];
    CGFloat contentViewHeight = 50.f;
    CGFloat space = 20;
    contentView.frame = CGRectMake(0, contentSizeHeight + space, scrollViewFrame.size.width, contentViewHeight);
    contentView.layer.borderColor = [UIColor blackColor].CGColor;
    contentView.layer.borderWidth = 1.0f;
    [self.scrollView addSubview:contentView];
    contentSizeHeight += space + contentViewHeight;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"启动";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:titleLabel attribute:(NSLayoutAttributeLeading) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeLeading) multiplier:1 constant:17], [NSLayoutConstraint constraintWithItem:titleLabel attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0]]];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.translatesAutoresizingMaskIntoConstraints = NO;
    [switchView addTarget:self action:@selector(startSwitchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    if ([HSDManager isHttpServerRunning]) {
        switchView.on = YES;
    } else {
        switchView.on = NO;
    }
    [contentView addSubview:switchView];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:switchView attribute:(NSLayoutAttributeTrailing) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeTrailing) multiplier:1 constant:-17], [NSLayoutConstraint constraintWithItem:switchView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0]]];
    
    // 自动启动
    contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, contentSizeHeight + space, scrollViewFrame.size.width, contentViewHeight);
    contentView.layer.borderColor = [UIColor blackColor].CGColor;
    contentView.layer.borderWidth = 1.0f;
    [self.scrollView addSubview:contentView];
    contentSizeHeight += space + contentViewHeight;

    titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"自动启动";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:titleLabel attribute:(NSLayoutAttributeLeading) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeLeading) multiplier:1 constant:17], [NSLayoutConstraint constraintWithItem:titleLabel attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0]]];
    
    switchView = [[UISwitch alloc] init];
    switchView.translatesAutoresizingMaskIntoConstraints = NO;
    [switchView addTarget:self action:@selector(autoStartSwitchViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    BOOL isAutoStart = [[NSUserDefaults standardUserDefaults] boolForKey:kHSDUserDefaultsKeyAutoStart];
    if (isAutoStart) {
        switchView.on = YES;
    } else {
        switchView.on = NO;
    }
    [contentView addSubview:switchView];
    
    [self.view addConstraints:@[[NSLayoutConstraint constraintWithItem:switchView attribute:(NSLayoutAttributeTrailing) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeTrailing) multiplier:1 constant:-17], [NSLayoutConstraint constraintWithItem:switchView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:contentView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0]]];
    
    // 返回
    contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, contentSizeHeight + space, scrollViewFrame.size.width, contentViewHeight);
    contentView.layer.borderColor = [UIColor blackColor].CGColor;
    contentView.layer.borderWidth = 1.0f;
    [self.scrollView addSubview:contentView];
    contentSizeHeight += space + contentViewHeight;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = contentView.bounds;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    
    self.scrollView.contentSize = CGSizeMake(scrollViewFrame.size.width, contentSizeHeight);
}

- (void)startSwitchViewValueChanged:(UISwitch *)sender {
    BOOL isON = sender.on;
    if (isON) {
        [HSDManager startHttpServer];
        self.textView.text = [HSDManager fetchAlternateServerSites];
    } else {
        [HSDManager stopHttpServer];
        self.textView.text = @"";
    }
}

- (void)autoStartSwitchViewValueChanged:(UISwitch *)sender {
    BOOL isON = sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:isON forKey:kHSDUserDefaultsKeyAutoStart];
}

- (void)backButtonPressed {
    if (self.backBlock) {
        self.backBlock();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end