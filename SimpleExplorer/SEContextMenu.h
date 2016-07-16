//
//  SEContextMenu.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol  SEContextMenuDelegate;
@interface SEContextMenu : NSObject
{
    NSMenu *menu;
    NSMenuItem *createItem;
    NSMenuItem *renameItem;
    NSMenuItem *copyItem;
    NSMenuItem *pasteItem;
    NSMenuItem *deleteItem;
    id<SEContextMenuDelegate> delegate;
}

@property NSMenu *menu;
@property (nonatomic) id<SEContextMenuDelegate> delegate;

- (instancetype) initWithMenuTitle : (NSString *) title andView : (NSView *) view;
- (void) setDelegate : (id<SEContextMenuDelegate>) newDelegate;
- (id<SEContextMenuDelegate>) getDelegate;

- (void) setCopyItemDisable;
- (void) setPasteItemDisable;

@end

@protocol SEContextMenuDelegate <NSObject>

@required
- (void) contextMenu : (SEContextMenu *) seMenu createItemClick : (NSMenuItem *) item;
- (void) contextMenu : (SEContextMenu *) seMenu renameItemClick : (NSMenuItem *) item;
- (void) contextMenu : (SEContextMenu *) seMenu copyItemClick   : (NSMenuItem *) item;
- (void) contextMenu : (SEContextMenu *) seMenu pasteItemClick  : (NSMenuItem *) item;
- (void) contextMenu : (SEContextMenu *) seMenu deleteItemClick : (NSMenuItem *) item;

@end