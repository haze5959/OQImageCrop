//
//  OQCropViewController.m
//
//  Created by 권오규 on 2018. 1. 15..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import "OQCropViewController.h"
#import "UIImage+OQCrop.h"
#import <AVFoundation/AVFoundation.h>

@interface OQCropViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet OQCropView *cropView;

@property UIImage *image;
@property (nonatomic) CGFloat cropAspectRatio;

@property (nonatomic, copy) void(^yesCompletion)(UIImage *resultImage);
@property (nonatomic, copy) void(^noCompletion)(void);

//Shadow View
@property (weak, nonatomic) IBOutlet UIView *topShadow;
@property (weak, nonatomic) IBOutlet UIView *leftShadow;
@property (weak, nonatomic) IBOutlet UIView *bottomShadow;
@property (weak, nonatomic) IBOutlet UIView *rightShadow;

@end

@implementation OQCropViewController

#pragma mark - init
+ (OQCropViewController *)viewControllerWithImage:(UIImage *)image cropAspectRatio:(CGFloat)cropAspectRatio yesBlock:(void (^)(UIImage *resultImage))yesCompletion noBlock:(void (^)(void))noCompletion{
    
    OQCropViewController *viewController = [[OQCropViewController alloc]
                                                 initWithNibName:@"OQCropViewController"
                                                 bundle:nil];
    
    viewController.image = image;
    viewController.cropAspectRatio = cropAspectRatio;
    
    viewController.yesCompletion = yesCompletion;
    viewController.noCompletion = noCompletion;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCropView];
}

#pragma mark - 크랍뷰 초기화
-(void)initCropView{
    CGFloat scale = MIN(CGRectGetWidth([[UIScreen mainScreen] bounds]) / self.image.size.width,
                        IMAGEVIEW_HEIGHT_MAX / self.image.size.height);
    
    //이미지뷰 크기 연산
    float imageViewWidth = self.image.size.width * scale;
    float imageViewHeight = self.image.size.height * scale;
    float horizenMargin = (CGRectGetWidth([[UIScreen mainScreen] bounds]) - imageViewWidth) / 2;
    float verticalMargin = (CGRectGetHeight([[UIScreen mainScreen] bounds]) - imageViewHeight) / 2;
    [self.imageView setFrame:CGRectMake(horizenMargin, verticalMargin, imageViewWidth, imageViewHeight)];
    [self.imageView setImage:self.image];
    
    CGRect cropRect = self.imageView.frame;
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    if (self.cropAspectRatio <= 1.0f) {
        width = height * self.cropAspectRatio;
    } else {
        height = width / self.cropAspectRatio;
    }
    cropRect.size = CGSizeMake(width, height);
    
    [self.cropView setFrame:cropRect];
    [self.cropView settingOQCropView];
    self.cropView.delegate = self;
    
    [self updateCropView:[self getMiddlePointForRect:self.cropView.frame]];
}

#pragma mark - 업데이트 뷰
- (void)updateCropView:(CGPoint)point{
    float cropViewMaxX = self.imageView.frame.origin.x + self.imageView.frame.size.width - self.cropView.frame.size.width;
    float cropViewMaxY = self.imageView.frame.origin.y + self.imageView.frame.size.height - self.cropView.frame.size.height;
    
    if (point.x < self.imageView.frame.origin.x) {
        point.x = self.imageView.frame.origin.x;
    }
    else if (point.x > cropViewMaxX) {
        point.x = cropViewMaxX;
    }
    
    if (point.y < self.imageView.frame.origin.y) {
        point.y = self.imageView.frame.origin.y;
    }
    else if (point.y > cropViewMaxY) {
        point.y = cropViewMaxY;
    }
    
    CGRect cropRect = self.cropView.frame;
    cropRect.origin.x = point.x;
    cropRect.origin.y = point.y;
    [self.cropView setFrame:cropRect];
    
    [self updateShadowView];
}

- (void)updateShadowView{
    //위쪽 쉐도우
    float topShadowHeight = self.cropView.frame.origin.y - self.imageView.frame.origin.y;
    [self.topShadow setFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, topShadowHeight)];
    //아래쪽 쉐도우
    float bottomShadowHeight = (self.imageView.frame.origin.y + self.imageView.frame.size.height) - (self.cropView.frame.origin.y + self.cropView.frame.size.height);
    [self.bottomShadow setFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y + topShadowHeight + self.cropView.frame.size.height, self.imageView.frame.size.width, bottomShadowHeight)];
    //왼쪽 쉐도우
    float leftShadowWidth = self.cropView.frame.origin.x - self.imageView.frame.origin.x;
    [self.leftShadow setFrame:CGRectMake(self.imageView.frame.origin.x, self.cropView.frame.origin.y, leftShadowWidth, self.cropView.frame.size.height)];
    //오른쪽 쉐도우
    float rightShadowWidth = self.imageView.frame.size.width - (leftShadowWidth + self.cropView.frame.size.width);
    [self.rightShadow setFrame:CGRectMake(self.cropView.frame.origin.x + self.cropView.frame.size.width, self.cropView.frame.origin.y, rightShadowWidth, self.cropView.frame.size.height)];
}

#pragma mark - OQCropViewDelegate

- (void)paningCropViewDidBegin:(OQCropView *)CropView{
//    NSLog(@"크랍뷰 paning start!! %f", CropView.frame.origin.x);
    CropView.beforeStatePoint = CropView.frame.origin;
}
- (void)paningCropViewDid:(OQCropView *)CropView{
//    NSLog(@"크랍뷰 paning %f", CropView.translation.x);
    [self updateCropView:CGPointMake(CropView.beforeStatePoint.x + CropView.translation.x, CropView.beforeStatePoint.y + CropView.translation.y)];
}
- (void)paningCropViewDidEnd:(OQCropView *)CropView{
//    NSLog(@"크랍뷰 paning end!! %f", CropView.frame.origin.x);
    CropView.beforeStatePoint = CGPointZero;
}

#pragma mark - 도구
//이미지뷰를 기점으로 해당 Rect이 중심에 위치할 origin 좌표를 반환한다.
- (CGPoint)getMiddlePointForRect:(CGRect)Rect{
    float pointX = self.imageView.frame.origin.x + ((self.imageView.frame.size.width - Rect.size.width) / 2);
    float pointY = self.imageView.frame.origin.y + ((self.imageView.frame.size.height - Rect.size.height) / 2);
    
    return CGPointMake(pointX, pointY);
}

#pragma mark - 버튼 이벤트
- (IBAction)pressCancelBtn:(id)sender {
    self.noCompletion();
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pressRotateBtn:(id)sender {
    //이미지 돌리기
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (self.image.imageOrientation) {
        case UIImageOrientationUp:
            orientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationLeft:
            orientation = UIImageOrientationDown;
            break;
        case UIImageOrientationDown:
            orientation = UIImageOrientationRight;
            break;
        case UIImageOrientationRight:
            orientation = UIImageOrientationUp;
            break;
        default:
            orientation = UIImageOrientationUp;
            break;
    }
    UIImage * newImage = [[UIImage alloc] initWithCGImage: self.image.CGImage
                                                    scale: 1.0
                                              orientation: orientation];
    self.image = newImage;
    
    [self initCropView];
}
- (IBAction)pressCompleteBtn:(id)sender {
    CGRect cropRect = self.cropView.frame;
    cropRect.origin.x = self.imageView.frame.origin.x - cropRect.origin.x;
    cropRect.origin.y = cropRect.origin.y - self.imageView.frame.origin.y;
    
    UIImage *image = [self.image rotatedImageWithtransform:self.imageView.transform croppedToRect:cropRect];
    
    self.yesCompletion(image);
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.delegate OQCropViewController:self didFinishCroppingImage:image];
}


@end
