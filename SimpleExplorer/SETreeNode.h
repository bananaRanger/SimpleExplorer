//
//  SETreeNode.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEFileItem.h"

@interface SETreeNode : NSObject
{
    SEFileItem *value;
    NSMutableArray<SETreeNode *> *children;
    SETreeNode *parent;
}

- (instancetype) initWithValue : (SEFileItem *) newValue;
- (void) addChildNode : (SETreeNode *) node;
- (void) clearChildren;
- (NSInteger) getChildrenCount;
- (SETreeNode *) getChildNode : (NSInteger) index;
- (SETreeNode *) getParent;
- (SEFileItem *) getValue;
- (NSString *) getFullPath;

@end
