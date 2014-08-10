//
//  PostBuilder.m
//  ridesharing
//
//  Created by Wei Lu on 8/2/14.
//  Copyright (c) 2014 WEI LU. All rights reserved.
//

#import "PostBuilder.h"
#import "RSPostDestAnnotation.h"
#import "RSPostOriginAnnotation.h"

@implementation PostBuilder

+ (NSArray *)postsFromQueryResults:(NSArray *)results
{
    NSMutableArray *newPosts = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        RSPostDestAnnotation *newPost = [[RSPostDestAnnotation alloc] initWithPFObject:object];
        [newPosts addObject:newPost];
    }
    return newPosts;
}

+ (NSArray *)destAnnotationFromQueryResults:(NSArray *)results;
{
    NSMutableArray *newPosts = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        RSPostDestAnnotation *newPost = [[RSPostDestAnnotation alloc] initWithPFObject:object];
        [newPosts addObject:newPost];
    }
    return newPosts;
}

+ (NSArray *)origAnnotationFromQueryResults:(NSArray *)results;
{
    NSMutableArray *newPosts = [[NSMutableArray alloc] init];
    for (PFObject *object in results) {
        RSPostOriginAnnotation *newPost = [[RSPostOriginAnnotation alloc] initWithPFObject:object];
        [newPosts addObject:newPost];
    }
    return newPosts;
}

@end
