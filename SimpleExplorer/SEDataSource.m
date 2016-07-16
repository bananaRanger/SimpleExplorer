//
//  SEDataSource.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEDataSource.h"

NSString *const TableViewFileNameColumn   = @"fileName";
NSString *const TableViewChangeDataColumn = @"changeData";
NSString *const TableViewFileSizeColumn   = @"fileSize";

@implementation SEDataSource
{
    NSImage *folderImage;
    NSImage *fileImage;
}

- (instancetype) initWithValue : (SEFileItem *) node {
    self = [super init];
    if (self != nil) {
        self->root  = [[SETreeNode alloc] initWithValue:node];
        self->items = [NSMutableArray array];
        self->folderImage = [NSImage imageNamed:@"NSFolder"];
        self->fileImage   = [NSImage imageNamed:@"ImageFile"];
    }
    return self;
}

#pragma mark - outlineView

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    
    if (item == nil) { // для корневого элемента
        return [self->root getChildrenCount];
    } else if ([item isKindOfClass:[SETreeNode class]]) {
        SETreeNode *node = (SETreeNode *)item;
        return [node getChildrenCount];
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    
    if (item == nil) { // для корневого элемента
        return [self->root getChildrenCount] > 0;
    } else if ([item isKindOfClass:[SETreeNode class]]) {
        SETreeNode *node = (SETreeNode *)item;
        return ([node getChildrenCount] > 0);
    }
    return false;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    if (item == nil) { // для корневого элемента
        return [self->root getChildNode:index];
    } else if ([item isKindOfClass:[SETreeNode class]]) {
        SETreeNode *node = (SETreeNode *)item;
        return [node getChildNode:index];
    }
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    
    if (item == nil) { // для корневого элемента
        return [[self->root getValue].name description];
    } else if ([item isKindOfClass:[SETreeNode class]]) {
        SETreeNode *node = (SETreeNode *)item;
        if ([tableColumn.identifier isEqualToString:@"name"]) {
            return [[node getValue].name description];
        }
    }
    return @"---";
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    return 24.f;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(nonnull id)item {
    
    tableColumn.headerCell.alignment = NSCenterTextAlignment;
    if ([item isKindOfClass:[SETreeNode class]]) {
        
        SETreeNode *treeNode = (SETreeNode *)item;
        NSView *viewCont = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
        
        NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(6, 3, 18, 18)];
        [imageView setImage:self->folderImage];
        
        [viewCont addSubview:imageView];
        
        NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(30, 6, 160, 16)];
        [textField setStringValue:[[treeNode getValue].name description]];
        [textField setBordered:false];
        [textField setEditable:false];
        [textField setBackgroundColor:nil];
        
        [viewCont addSubview:textField];
        
        return viewCont;
    }
    return nil;
}

- (void) addNode : (SETreeNode *) node {
    [self->root addChildNode:node];
}

#pragma mark - tableView

- (void) updateFiles : (NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    [self->items removeAllObjects];
    
    for (int i = 0; i < array.count; i++) {
        NSString *name = [array objectAtIndex:i];
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", path, name];
        
        BOOL isDir = false;
        [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        
        SEFileItem *item = [[SEFileItem alloc] initWithPath:fullPath];
        item.name       = name;
        item.isFolder   = isDir;
        item.size       = ([[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileSize] / 1000);
        item.changeDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileModificationDate];
        item.creationDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileCreationDate];
        item.ownerName  = [[[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil] fileOwnerAccountName];
        [self->items addObject:item];
    }
    [self sortingNameByAscending:true];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)tableView {
    return items.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 24.f;
}

- (NSView *) tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    SEFileItem *item = [self->items objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:TableViewFileNameColumn]) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 420, 22)];
        NSImageView *image = [[NSImageView alloc] initWithFrame:NSMakeRect(4, 3, 28, 18)];
        NSTextField *label = [self labelForTableView:NSMakeRect(35, 3, 400, 18) withValue:item.name];
        
        if (item.isFolder == true) {
            image.image = self->folderImage;
        } else {
            image.image = self->fileImage;
        }
        [view addSubview:image];
        [view addSubview:label];
        
        return view;
    } else if ([tableColumn.identifier isEqualToString:TableViewChangeDataColumn]) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 22)];
        NSTextField *label = [self labelForTableView:NSMakeRect(2, 3, 180, 18) withValue:[item getCreationDate:true]];
        label.textColor = [NSColor controlShadowColor];
        [view addSubview: label];
        
        return view;
    } else if ([tableColumn.identifier isEqualToString:TableViewFileSizeColumn]) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 100, 22)];
        NSTextField *label = [self labelForTableView:NSMakeRect(2, 3, 98, 18) withValue:[item getFileSize]];
        label.textColor = [NSColor controlShadowColor];
        label.alignment = NSRightTextAlignment;
        [view addSubview: label];
        
        if (item.isFolder == false) {
            return view;
        } else {
            return nil;
        }
    }
    return nil;
}

- (NSTextField *) labelForTableView : (NSRect) rect withValue : (NSString *) value {
    NSTextField *label = [[NSTextField alloc] initWithFrame:rect];
    label.stringValue = value;
    label.bordered = false;
    label.editable = false;
    label.backgroundColor = nil;
    
    return label;
}

- (SEFileItem *) itemByIndex : (NSInteger) index {
    if (self->items.count > index) {
        return [self->items objectAtIndex:index];
    }
    return nil;
}

- (void) sortingNameByAscending : (BOOL) flag {
    if (self->items != nil) {
        NSArray<SEFileItem *> *sortedArray = [self->items sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            SEFileItem *item1 = ((SEFileItem *)obj1);
            SEFileItem *item2 = ((SEFileItem *)obj2);
            
            if (item1.isFolder < item2.isFolder) {
                return NSOrderedDescending;
            } else if (item1.isFolder > item2.isFolder) {
                return NSOrderedAscending;
            } else {
                if ([item1.name compare:item2.name options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
                    if (flag == true) { return NSOrderedDescending; } else { return NSOrderedAscending; }
                } else if ([item1.name compare:item2.name options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
                    if (flag == true) { return NSOrderedAscending; } else { return NSOrderedDescending; }
                } else {
                    return NSOrderedSame;
                }
            }
        }];
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:sortedArray];
        self->items = tmpArray;
        if (flag == true) { [self setItemIdentifierNumber]; }
    }
}

- (void) setItemIdentifierNumber {
    NSInteger number = 0;
    for (SEFileItem *item in self->items) {
        item.identifier = number;
        number++;
    }
}

@end
