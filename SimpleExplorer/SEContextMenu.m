//
//  SEContextMenu.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEContextMenu.h"

@implementation SEContextMenu

@synthesize menu;
@synthesize delegate;

- (instancetype) initWithMenuTitle : (NSString *) title andView : (NSView *) view {
    self = [super init];
    if (self != nil) {
        self->menu = [[NSMenu alloc] initWithTitle : title];
        [self->menu setAutoenablesItems:false];
        self->createItem = [[NSMenuItem alloc] initWithTitle:@"Создать"         action:@selector(createAction)  keyEquivalent:@""];
        self->renameItem = [[NSMenuItem alloc] initWithTitle:@"Переименовать"   action:@selector(renameAction)  keyEquivalent:@""];
        self->copyItem   = [[NSMenuItem alloc] initWithTitle:@"Копировать"      action:@selector(copyAction)    keyEquivalent:@""];
        self->pasteItem  = [[NSMenuItem alloc] initWithTitle:@"Вставить"        action:@selector(pasteAction)   keyEquivalent:@""];
        self->deleteItem = [[NSMenuItem alloc] initWithTitle:@"Удалить"         action:@selector(deleteAction)  keyEquivalent:@""];
        self->createItem.target = self;
        self->renameItem.target = self;
        self->copyItem.target   = self;
        self->pasteItem.target  = self;
        self->deleteItem.target = self;
        [self->menu addItem:self->createItem];
        [self->menu addItem:[NSMenuItem separatorItem]];
        [self->menu addItem:self->renameItem];
        [self->menu addItem:[NSMenuItem separatorItem]];
        [self->menu addItem:self->copyItem];
        [self->menu addItem:self->pasteItem];
        [self->menu addItem:self->deleteItem];
        self->pasteItem.enabled = false;
        [view setMenu:self->menu];
    }
    return self;
}

- (void) setDelegate : (id<SEContextMenuDelegate>) newDelegate {
    self->delegate = newDelegate;
}

- (id<SEContextMenuDelegate>) getDelegate {
    return self->delegate;
}

- (void) createAction {
    [self.delegate contextMenu:self createItemClick:self->createItem];
}

- (void) renameAction {
    [self.delegate contextMenu:self renameItemClick:self->renameItem];
}

- (void) copyAction {
    [self.delegate contextMenu:self copyItemClick:self->copyItem];
}

- (void) pasteAction {
    [self.delegate contextMenu:self pasteItemClick:self->pasteItem];
}

- (void) deleteAction {
    [self.delegate contextMenu:self deleteItemClick:self->pasteItem];
}

- (void) setCopyItemDisable {
    self->copyItem.enabled = false;
    self->pasteItem.enabled = true;
}

- (void) setPasteItemDisable {
    self->copyItem.enabled = true;
    self->pasteItem.enabled = false;
}

@end
