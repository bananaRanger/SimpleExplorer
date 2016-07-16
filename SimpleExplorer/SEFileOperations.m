//
//  SEFileOperations.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEFileOperations.h"

@implementation SEFileOperations
{
    NSString *itemInBuffer;
}

- (instancetype) initWithFileManager : (NSFileManager *) newFileManager {
    self = [super init];
    if (self != nil) {
        self->isItemInBuffer = false;
        self->bufferPath     = [NSString string];
        self->fileManager    = newFileManager;
        [self createBufferFolder];
    }
    return self;
}

- (void) createBufferFolder {
    
    self->bufferPath = [NSString stringWithFormat:@"/Users/%@/Documents/buffer/", NSUserName()];
    [self->fileManager createDirectoryAtPath:bufferPath withIntermediateDirectories:false attributes:nil error:nil];
}

- (BOOL) copyItemWithFullPath : (NSString *) fullPath andName: (NSString *) item {
    
    NSError *error;
    BOOL result;
    if (self->isItemInBuffer == false) {
        result = [self->fileManager copyItemAtPath:fullPath toPath:[NSString stringWithFormat:@"%@%@",self->bufferPath,item] error:&error];
        self->itemInBuffer = item;
        self->isItemInBuffer = true;
    } else {
        result = [self->fileManager copyItemAtPath:[NSString stringWithFormat:@"%@/%@", self->bufferPath,  self->itemInBuffer]
                                            toPath:[NSString stringWithFormat:@"%@/%@", fullPath,          self->itemInBuffer]
                                             error:&error];
        if (result == true) {
            [self removeItem:[NSString stringWithFormat:@"%@%@", self->bufferPath, self->itemInBuffer]];
            self->isItemInBuffer = false;
        }
    }
    return result;
}

- (BOOL) removeItem : (NSString *) fullPath {
    
    BOOL result = [self->fileManager removeItemAtPath:fullPath error:nil];
    return result;
}

- (BOOL) createFolder : (NSString *) fullPath {
    
    BOOL result = [self->fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:false attributes:nil error:nil];
    return result;
}

- (BOOL) createFile : (NSString *) fullPath {
    
    BOOL result = [self->fileManager createFileAtPath:fullPath contents:nil attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"app", NSFileType, nil]];
    return result;
}

- (BOOL) renameItem : (NSString *) oldName to: (NSString *) newName {
    
    BOOL result = [self->fileManager moveItemAtPath:oldName toPath:newName error:nil];
    return result;
}

- (NSString *) nameByPath : (NSString *) path {
    NSArray *array = [path componentsSeparatedByString:@"/"];
    NSString *name = [array objectAtIndex:array.count-1];
    return name;
}

- (NSString *) pathToItemByPath : (NSString *) path {
    NSString *string = [NSString string];
    NSMutableArray<NSString *> *array = (NSMutableArray *)[path componentsSeparatedByString:@"/"];
    [array removeLastObject];
    for (NSString *item in array) {
        if (![item isEqualToString:@""]) {
            string = [NSString stringWithFormat:@"%@/%@", string, item];
        }
    }
    return path;
}

@end
