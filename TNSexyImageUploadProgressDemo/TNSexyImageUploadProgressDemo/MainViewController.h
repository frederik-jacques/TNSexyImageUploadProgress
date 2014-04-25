//
//  MainViewController.h
//  TNSexyImageUploadProgressDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainView.h"

#import "TNSexyImageUploadProgress.h"

@interface MainViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) MainView *view;
@property (nonatomic, strong) TNSexyImageUploadProgress *imageUploadProgress;

@end
