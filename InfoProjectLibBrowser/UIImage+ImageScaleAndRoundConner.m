//
//  UIImage+ImageScaleAndRoundConner.m
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-4-3.
//  Copyright (c) 2014年 com.xysoft. All rights reserved.
//

#import "UIImage+ImageScaleAndRoundConner.h"

@implementation UIImage (ImageScaleAndRoundConner)
- (UIImage*)imageScaledToRoundConnerSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10] addClip];
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
