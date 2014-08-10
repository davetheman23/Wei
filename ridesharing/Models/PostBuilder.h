//
//  PostBuilder.h
//  ridesharing
//
//  Created by Wei Lu on 8/2/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostBuilder : NSObject

+ (NSArray *)postsFromQueryResults:(NSArray *)results;
+ (NSArray *)destAnnotationFromQueryResults:(NSArray *)results;
+ (NSArray *)origAnnotationFromQueryResults:(NSArray *)results;


@end
