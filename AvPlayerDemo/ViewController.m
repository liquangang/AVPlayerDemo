//
//  ViewController.m
//  AvPlayerDemo
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD.h>

@interface ViewController ()
@property (nonatomic, strong) AVPlayer * avplayer;
@property (nonatomic, strong) UIButton * playButton;
@property (nonatomic, strong) UIButton * pauseButton;
@property (nonatomic, strong) UILabel * promptLabel;
@property (nonatomic, strong) UITextField * urlTextField;
@property (nonatomic, strong) MBProgressHUD * HUD;
@property (nonatomic, strong) UIView * backView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * str = @" ";
    NSLog(@"%ld", str.length);
    [self initUI];
}

- (void)initUI{
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(6, 64, 50, 50)];
    [self.view addSubview:self.backView];
    
    UIButton * playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.backView addSubview:playButton];
    playButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton = playButton;
    [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.playButton.font = [UIFont boldSystemFontOfSize:12];
    self.playButton.backgroundColor = [UIColor grayColor];
    
    UIButton * pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(66, 64, 50, 50)];
    [self.view addSubview:pauseButton];
    pauseButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pauseButton.hidden = YES;
    [pauseButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseButton = pauseButton;
    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    self.pauseButton.font = [UIFont boldSystemFontOfSize:12];
    
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(126, 64, 50, 50)];
    [self.view addSubview:self.promptLabel];
    self.promptLabel.font = [UIFont boldSystemFontOfSize:13];
    self.promptLabel.textColor = [UIColor grayColor];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    
    self.urlTextField = [[UITextField alloc] initWithFrame:CGRectMake(6, 126, [UIScreen mainScreen].bounds.size.width - 12, 36)];
    [self.view addSubview:self.urlTextField];
    self.urlTextField.placeholder = @"请输入音乐的url";
    self.urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.urlTextField setBorderStyle:UITextBorderStyleRoundedRect];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)buttonAction:(UIButton *)btn{
    //http://movier-vdc.oss-cn-beijing.aliyuncs.com/movier/Template/Music/M126/
    //http://movier-vdc.oss-cn-beijing.aliyuncs.com/movier%2FTemplate%2FMusic%2F%E8%94%A1%E6%B7%B3%E4%BD%B3%2F%E7%AD%89%E4%B8%80%E4%B8%AA%E6%99%B4%E5%A4%A9%2F19%20%E4%BB%96%E5%92%8C%E5%A5%B9.mp3
    self.promptLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.promptLabel.text = @"已播放";
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.backView];
    [self.backView addSubview:self.HUD];
    self.HUD.cornerRadius = 0;
    self.HUD.opacity = 0;
    self.HUD.minSize = self.playButton.bounds.size;
    self.HUD.activityIndicatorColor = [UIColor groupTableViewBackgroundColor];
    __weak typeof(self) weakSelf = self;
    [weakSelf.HUD showAnimated:YES whileExecutingBlock:^{
        sleep(0.8);
        if (weakSelf.urlTextField.text.length != 0) {
            [weakSelf initAvplayerWithURL:weakSelf.urlTextField.text];
            return;
        }
        [weakSelf initAvplayerWithURL:@"http://movier-vdc.oss-cn-beijing.aliyuncs.com/movier%2FTemplate%2FMusic%2F%E8%94%A1%E6%B7%B3%E4%BD%B3%2F%E7%AD%89%E4%B8%80%E4%B8%AA%E6%99%B4%E5%A4%A9%2F19%20%E4%BB%96%E5%92%8C%E5%A5%B9.mp3"];
    } completionBlock:^{
        [weakSelf.HUD removeFromSuperview];
        weakSelf.HUD = nil;
    }];
    
}

- (void)pauseButtonAction:(UIButton *)btn{
    self.promptLabel.text = @"已暂停";
    self.pauseButton.hidden = YES;
    self.playButton.hidden = NO;
    [self.avplayer pause];
}

- (void)initAvplayerWithURL:(NSString *)urlStr{
    if (self.avplayer) {
        self.avplayer = nil;
    }
    
    self.avplayer = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:urlStr] ]];
//    self.avplayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [self.avplayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
