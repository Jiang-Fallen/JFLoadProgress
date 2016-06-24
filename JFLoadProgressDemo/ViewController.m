//
//  ViewController.m
//  JFLoadProgressDemo
//
//  Created by Mr_J on 16/6/24.
//  Copyright © 2016年 Mr_Jiang. All rights reserved.
//

#import "ViewController.h"
#import "JFLoadProgressView.h"

@interface ViewController ()
{
    CGFloat _progressValue;
}

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) JFLoadProgressView *loadProgressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadProgressView = [JFLoadProgressView showInView:self.contentImageView];
}

- (IBAction)contentImageTapAction:(UITapGestureRecognizer *)sender {
    _progressValue = 0;
    [self.loadProgressView reloadProgressState];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(refreshProgressView:) userInfo:nil repeats:YES];
}

- (void)refreshProgressView:(NSTimer *)timer{
    _progressValue += 0.01;
    self.loadProgressView.progressValue = _progressValue;
    if (_progressValue > 1) {
        [timer invalidate];
    }
}

@end
