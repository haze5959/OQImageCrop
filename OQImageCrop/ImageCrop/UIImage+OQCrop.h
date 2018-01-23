//
//  UIImage+OQCrop.h
//
//  Created by 권오규 on 2018. 1. 15..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>
//100의 의미는 툴바의 높이(80) + 여분(20)
#define IMAGEVIEW_HEIGHT_MAX ( CGRectGetHeight([[UIScreen mainScreen] bounds]) - (100 + [UIApplication sharedApplication].statusBarFrame.size.height) )

@interface UIImage (OQCrop)

- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)rotation
                         croppedToRect:(CGRect)rect;

@end
