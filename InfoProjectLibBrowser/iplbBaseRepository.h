//
//  iplbBaseRepository.h
//  InfoProjectLibBrowser
//
//  Created by  Jinyanhua on 14-3-27.
//  Copyright (c) 2014年 com.gpdi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iplbBaseRepository : NSObject
-(NSMutableDictionary *) dictionaryFromHTTPResponseJSON:(NSString *)url;
@end
