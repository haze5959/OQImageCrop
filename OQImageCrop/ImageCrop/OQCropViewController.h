//
//  OQCropViewController.h
//
//  Created by 권오규 on 2018. 1. 15..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OQCropView.h"

@interface OQCropViewController : UIViewController<OQCropViewDelegate>

+ (OQCropViewController *)viewControllerWithImage:(UIImage *)image cropAspectRatio:(CGFloat)cropAspectRatio yesBlock:(void (^)(UIImage *resultImage))yesCompletion noBlock:(void (^)(void))noCompletion;

@end
