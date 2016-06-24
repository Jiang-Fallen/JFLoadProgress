//
//  SUploadProgressView.h
//  Wefafa
//
//  Created by Mr_J on 16/6/23.
//  Copyright © 2016年 metersbonwe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFLoadProgressView : UIView

@property (nonatomic, assign) CGFloat marginPercentage;
@property (nonatomic, assign) CGFloat progressValue;
@property (nonatomic, strong) UIColor *maskColor;

+ (instancetype)showInView:(UIView *)view;

- (void)reloadProgressState;

@end
