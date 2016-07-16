//
//  SETreeNode.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SETreeNode.h"

@implementation SETreeNode

- (instancetype) initWithValue : (SEFileItem *) newValue {
    self = [super init];
    if (self != nil) {
        self->value    = newValue;
        self->children = [NSMutableArray array];
        self->parent   = nil;
    }
    return self;
}

- (void) addChildNode : (SETreeNode *) node {
    node->parent = self;
    [self->children addObject:node];
}

- (void) clearChildren {
    [self->children removeAllObjects];
}

- (NSInteger) getChildrenCount {
    return self->children.count;
}

- (SETreeNode *) getChildNode : (NSInteger) index {
    
    if (index >= 0 && index < self->children.count) {
        return [self->children objectAtIndex:index];
    }
    return nil;
}

- (SETreeNode *) getParent {
    return self->parent;
}

- (SEFileItem *) getValue {
    return self->value;
}

- (NSString *) getFullPath {
    return self->value.path;
}

@end
