//
//  QRCodeView.m
//  ios二维码
//
//  Created by 方世沛 on 2017/4/11.
//  Copyright © 2017年 方世沛. All rights reserved.
//
#import "QRCodeView.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@implementation QRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor blackColor];
        UIImageView *shadowImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        shadowImgV.backgroundColor = [UIColor clearColor];
        shadowImgV.layer.borderColor=UIColorFromRGB(0xdfdfdf).CGColor;
        shadowImgV.layer.borderWidth=1;
        [self addSubview:shadowImgV];
        [shadowImgV makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo((SCREEN_WIDTH-102));
            make.height.equalTo((SCREEN_WIDTH-102));
        }];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"qrcode_border"];
        CGFloat top = image.size.height * 0.5;
        CGFloat left = image.size.width * 0.5;
        CGFloat bottom = image.size.height * 0.5;
        CGFloat right = image.size.width * 0.5;
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
        image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        imgv.image=image;
        [self addSubview:imgv];
        [imgv makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo((SCREEN_WIDTH-100));
            make.height.equalTo((SCREEN_WIDTH-100));
        }];
        
        lineImgV=[[UIImageView alloc] initWithFrame:CGRectMake(70, (SCREEN_HEIGHT-SCREEN_WIDTH+100)/2, SCREEN_WIDTH-142, 2)];
        lineImgV.image=[UIImage imageNamed:@"bg_scanningrod"];
        [self addSubview:lineImgV];
        
        [self animate];
        
        
        UIView *tempView;
        for (int i=0; i<4; i++) {
            UIView *view =[[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [self addSubview:view];
            [view makeConstraints:^(MASConstraintMaker *make) {
                switch (i) {
                    case 0:
                        make.left.equalTo(self);
                        make.width.equalTo(51);
                        make.top.equalTo(self);
                        make.bottom.equalTo(self);
                        break;
                    case 1:
                        make.left.equalTo(tempView.right);
                        make.top.equalTo(self);
                        make.width.equalTo(SCREEN_WIDTH-102);
                        make.height.equalTo((SCREEN_HEIGHT-SCREEN_WIDTH+102)/2);
                        break;
                    case 2:
                        make.right.equalTo(self);
                        make.top.equalTo(self);
                        make.width.equalTo(51);
                        make.bottom.equalTo(self);
                        break;
                    case 3:
                        make.right.equalTo(tempView.left);
                        make.width.equalTo(SCREEN_WIDTH-102);
                        make.bottom.equalTo(self);
                        make.height.equalTo((SCREEN_HEIGHT-SCREEN_WIDTH+102)/2);
                        break;
                        
                }
            }];
            tempView = view;
        }
    }
    return self;
}

- (void)animate {
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         lineImgV.frame = CGRectMake(70, (SCREEN_HEIGHT-SCREEN_WIDTH+100)/2+SCREEN_WIDTH-104, SCREEN_WIDTH-140, 2);
                     } completion:^(BOOL finished) {
                         lineImgV.frame = CGRectMake(70, (SCREEN_HEIGHT-SCREEN_WIDTH+100)/2, SCREEN_WIDTH-140, 2);
                         [self animate];
                     }];
}

@end
