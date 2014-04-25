//
//  MainView.m
//  TNSexyImageUploadProgressDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        [self addSubview:self.backgroundImageView];
        
        UIImage *buttonImage = [UIImage imageNamed:@"button"];
        
        self.btnTakePicture = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnTakePicture.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        [self.btnTakePicture setBackgroundImage:buttonImage forState:UIControlStateNormal];
        self.btnTakePicture.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - self.btnTakePicture.frame.size.height);
        [self addSubview:self.btnTakePicture];
        
    }
    
    return self;
}

- (void)updateWithMessage:(NSString *)message {
    self.lblMessage.text = message;
    
    CGRect msgRect = [message boundingRectWithSize:CGSizeMake(self.frame.size.width - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    self.lblMessage.frame = CGRectMake(0, 0, self.frame.size.width - 30, msgRect.size.height);
    self.lblMessage.center = self.center;
    
}

- (UILabel *)lblMessage {
    
    if( !_lblMessage ){
        
        _lblMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblMessage.font = [UIFont systemFontOfSize:15];
        _lblMessage.textColor = [UIColor grayColor];
        _lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
        _lblMessage.numberOfLines = 0;
        _lblMessage.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lblMessage];
        
    }
    
    return _lblMessage;
    
}

@end
