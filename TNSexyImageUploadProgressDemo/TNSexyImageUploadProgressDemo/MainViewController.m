//
//  MainViewController.m
//  TNSexyImageUploadProgressDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"
#import "AFNetworking/AFHTTPSessionManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)loadView {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    self.view = [[MainView alloc] initWithFrame:bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view.btnTakePicture addTarget:self action:@selector(takePictureClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)takePictureClicked:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:^{}];
    
}

#define WEBSERVICE_URL @"YOUR_PATH_TO_YOUR_WEBSERVICE"

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *imageData = UIImagePNGRepresentation(selectedImage);

        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:WEBSERVICE_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"test" mimeType:@"image/png"];
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSProgress *progress = nil;
        
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            [progress removeObserver:self forKeyPath:@"fractionCompleted"];
            
            if (error) {
                [self.view updateWithMessage:[NSString stringWithFormat:@"Error : %@!", error.debugDescription]];
            } else {
                [self.view updateWithMessage:@"Great success!"];
                
            }
        }];
        
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
        
        [uploadTask resume];
        
        self.imageUploadProgress = [[TNSexyImageUploadProgress alloc] init];
        self.imageUploadProgress.radius = 100;
        self.imageUploadProgress.progressBorderThickness = -10;
        self.imageUploadProgress.trackColor = [UIColor blackColor];
        self.imageUploadProgress.progressColor = [UIColor whiteColor];
        self.imageUploadProgress.imageToUpload = selectedImage;
        [self.imageUploadProgress show];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUploadCompleted:) name:IMAGE_UPLOAD_COMPLETED object:self.imageUploadProgress];
        
    }];
}

- (void)imageUploadCompleted:(NSNotification *)notification {
    NSLog(@"[MainVC] Image upload completed");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        //NSLog(@"[MainVC] Uploading photo fraction = %f, completed unit count = %lld, total unit count = %lld", progress.fractionCompleted, progress.completedUnitCount, progress.totalUnitCount);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageUploadProgress.progress = progress.fractionCompleted;
        });
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"[MainVC] Did cancel image picker");
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMAGE_UPLOAD_COMPLETED object:self.imageUploadProgress];
    
}

@end
