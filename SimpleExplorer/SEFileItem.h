//
//  SEFileItem.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

#define byteMin 1000
#define kByteMin 100000
#define mByteMin 100000000

@interface SEFileItem : NSObject
{
    NSInteger identifier;
    NSString *path;
    NSString *name;
    BOOL isFolder;
    NSInteger size;
    NSDate *changeDate;
    NSDate *creationDate;
    NSString *ownerName;
}

@property NSInteger identifier;
@property NSString *path;
@property NSString *name;
@property BOOL isFolder;
@property NSInteger size;
@property NSDate *changeDate;
@property NSDate *creationDate;
@property NSString *ownerName;

- (instancetype) initWithPath : (NSString *) newPath;
- (NSString *) getCreationDate : (BOOL) orChangeDate;
- (NSString *) getFileSize;

@end
