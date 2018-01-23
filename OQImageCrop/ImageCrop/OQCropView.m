//
//  settingOQCropView.m
//
//  Created by 권오규 on 2018. 1. 15..
//  Copyright © 2018년 권오규. All rights reserved.
//

#import "OQCropView.h"

@interface OQCropView ()

@property (nonatomic, readwrite) CGPoint translation;
@property (nonatomic) CGPoint startPoint;

@end

@implementation OQCropView

- (void)settingOQCropView{
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;

    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    //테두리
    self.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f].CGColor;
    self.layer.borderWidth = 2.0f;
    
    //그리드
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat borderPadding = 2.0f;

        if (i > 0) {
            [[UIColor whiteColor] set];
            
            UIRectFill(CGRectMake(roundf(width / 3 * i), borderPadding, 1.0f, roundf(height) - borderPadding * 2));
            UIRectFill(CGRectMake(borderPadding, roundf(height / 3 * i), roundf(width) - borderPadding * 2, 1.0f));
        }
    }
    
    //엣지
    //좌상
    UIRectFill(CGRectMake(0, 0, 25, 5));
    UIRectFill(CGRectMake(0, 0, 5, 25));
    //우상
    UIRectFill(CGRectMake(width, 0, -25, 5));
    UIRectFill(CGRectMake(width, 0, -5, 25));
    //좌하
    UIRectFill(CGRectMake(0, height, 25, -5));
    UIRectFill(CGRectMake(0, height, 5, -25));
    //우하
    UIRectFill(CGRectMake(width, height, -25, -5));
    UIRectFill(CGRectMake(width, height, -5, -25));
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint translationInView = [gestureRecognizer translationInView:self.superview];
        self.startPoint = CGPointMake(roundf(translationInView.x), translationInView.y);
        
        if ([self.delegate respondsToSelector:@selector(paningCropViewDidBegin:)]) {
            [self.delegate paningCropViewDidBegin:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        self.translation = CGPointMake(roundf(self.startPoint.x + translation.x),
                                       roundf(self.startPoint.y + translation.y));
        
        if ([self.delegate respondsToSelector:@selector(paningCropViewDid:)]) {
            [self.delegate paningCropViewDid:self];
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(paningCropViewDidEnd:)]) {
            [self.delegate paningCropViewDidEnd:self];
        }
    }
}

@end
