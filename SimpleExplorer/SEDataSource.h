//
//  SEDataSource.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SETreeNode.h"

extern NSString *const TableViewFileNameColumn;
extern NSString *const TableViewChangeDataColumn;
extern NSString *const TableViewFileSizeColumn;

@interface SEDataSource : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate, NSTableViewDataSource, NSTableViewDelegate>
{
    SETreeNode *root;
    NSMutableArray<SEFileItem *> *items;
}

- (instancetype) initWithValue : (SEFileItem *) node;

// outlineView
- (void) addNode : (SETreeNode *) node;

// tableView
- (void) updateFiles : (NSString *) path ;
- (SEFileItem *) itemByIndex : (NSInteger) index;
- (void) sortingNameByAscending : (BOOL) flag;

@end
