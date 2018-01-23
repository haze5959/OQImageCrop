//
//  settingOQCropView.h
//
//  Created by 권오규 on 2018. 1. 15..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol OQCropViewDelegate;

@interface OQCropView : UIView

@property (nonatomic, weak) id<OQCropViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;
@property CGPoint beforeStatePoint;

- (void)settingOQCropView;

@end

@protocol OQCropViewDelegate <NSObject>

- (void)paningCropViewDidBegin:(OQCropView *)CropView;
- (void)paningCropViewDid:(OQCropView *)CropView;
- (void)paningCropViewDidEnd:(OQCropView *)CropView;

@end
