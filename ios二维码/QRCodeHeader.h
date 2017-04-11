//
//  QRCodeHeader.h
//  ios二维码
//
//  Created by 方世沛 on 2017/4/11.
//  Copyright © 2017年 方世沛. All rights reserved.
//

#ifndef QRCodeHeader_h
#define QRCodeHeader_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif /* QRCodeHeader_h */
