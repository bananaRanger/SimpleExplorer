//
//  SEFileOperations.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEFileOperations : NSObject
{
    BOOL isItemInBuffer;
    NSString *bufferPath;
    NSFileManager *fileManager;
}

- (instancetype) initWithFileManager : (NSFileManager *) newFileManager;
- (BOOL) copyItemWithFullPath : (NSString *) fullPath andName: (NSString *) item;
- (BOOL) removeItem : (NSString *) fullPath;
- (BOOL) createFolder : (NSString *) fullPath;
- (BOOL) createFile   : (NSString *) fullPath;
- (BOOL) renameItem   : (NSString *) oldName to: (NSString *) newName;
- (NSString *) nameByPath : (NSString *) path;
- (NSString *) pathToItemByPath : (NSString *) path;

@end
