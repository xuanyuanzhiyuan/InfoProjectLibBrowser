//
//  iplbProjectLabel.h
//  InfoProjectLibBrowser
//
//  Created by jinyanhua on 14-6-19.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbProjectLabel : NSObject
@property NSString *chnName;
@property NSString *labelCode;
+(iplbProjectLabel *) labelWithDictionary:(NSDictionary *) dic;
@end
