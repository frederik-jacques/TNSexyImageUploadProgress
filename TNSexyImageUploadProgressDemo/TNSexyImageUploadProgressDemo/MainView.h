//
//  MainView.h
//  TNSexyImageUploadProgressDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *btnTakePicture;
@property (nonatomic, strong) UILabel *lblMessage;

- (void)updateWithMessage:(NSString *)message;

@end
