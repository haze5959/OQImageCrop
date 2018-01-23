//
//  ViewController.m
//  OQImageCrop
//
//  Created by 권오규 on 2018. 1. 23..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import "ViewController.h"
#import "OQCropViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) CGFloat cropAspectRatio;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cropAspectRatio = 3.0f / 2.0f;   //3 : 2 ratio
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        OQCropViewController *controller = [OQCropViewController viewControllerWithImage:image cropAspectRatio:self.cropAspectRatio yesBlock:^(UIImage *resultImage) {
            //Image Crop Done!
            [self.imageView setImage:resultImage];

        } noBlock:^{
            //Image Crop Cancel
            
        }];
        [self presentViewController:controller animated:NO completion:NULL];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button Action
- (IBAction)pressGalleryBtn:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:controller animated:NO completion:NULL];
}

- (IBAction)pressCameraBtn:(id)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:controller animated:NO completion:NULL];
}
@end
