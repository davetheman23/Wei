//
//  Header.h
//  ridesharing
//
//  Created by Wei Lu on 8/2/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QueryManagerDelegate <NSObject>
- (void)didReceivePosts:(NSArray *)posts;
- (void)fetchingPostsFailedWithError:(NSError *)error;
@end