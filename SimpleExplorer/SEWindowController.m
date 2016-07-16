//
//  SEWindowController.m
//  SimpleExplorer
//
//  Created by Anthony on 17.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEWindowController.h"

NSString *const NSToolbarBackItem    = @"NSToolbarBackItem";
NSString *const NSToolbarPathItem    = @"NSToolbarPathItem";
NSString *const NSToolbarCreateItem  = @"NSToolbarCreateItem";
NSString *const NSToolbarSortItem    = @"NSToolbarSortItem";
NSString *const NSToolbarInfoItem    = @"NSToolbarInfoItem";

@interface SEWindowController ()

@end

@implementation SEWindowController
{
    NSMutableArray<NSString *> *arrayWithItems;
}

@synthesize delegate;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.minSize = NSMakeSize(894, 400);
    
    self.window.titleVisibility = NSWindowTitleHidden;
    
    self->arrayWithItems = [NSMutableArray array];
    
    [self fullArrayWithItem];
    
    self->toolbar.delegate = self;
    
    for (int i = 0; i < self->arrayWithItems.count; i++) {
        NSString *item = [self->arrayWithItems objectAtIndex:i];
        [self->toolbar insertItemWithItemIdentifier:item atIndex:i];
    }
}

- (void) fullArrayWithItem {
    [self->arrayWithItems addObject:NSToolbarBackItem];
    [self->arrayWithItems addObject:NSToolbarFlexibleSpaceItemIdentifier];
    [self->arrayWithItems addObject:NSToolbarPathItem];
    [self->arrayWithItems addObject:NSToolbarFlexibleSpaceItemIdentifier];
    [self->arrayWithItems addObject:NSToolbarCreateItem];
    [self->arrayWithItems addObject:NSToolbarInfoItem];
    [self->arrayWithItems addObject:NSToolbarSortItem];
}


- (NSArray<NSString *> *) toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return self->arrayWithItems;
}

- (NSArray<NSString *> *) toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return self->arrayWithItems;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    if ([itemIdentifier isEqualToString:NSToolbarBackItem]) {
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 44, 29)];
        button.bezelStyle = NSThickSquareBezelStyle;
        button.image = [NSImage imageNamed:@"ImageBack"];
        button.toolTip = @"Вернутся в предыдущий каталог";
        button.target  = self;
        button.action  = @selector(backItemClicked);
        item.view = button;
    } else if ([itemIdentifier isEqualToString:NSToolbarPathItem]) {
        self->label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 600, 20)];
        self->label.editable = false;
        self->label.bezelStyle = NSTextFieldRoundedBezel;
        self->label.alignment = NSCenterTextAlignment;
        self->label.backgroundColor = nil;
        self->label.toolTip = @"Путь к текущему каталогу";
        item.view    = self->label;
    } else if ([itemIdentifier isEqualToString:NSToolbarCreateItem]) {
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 44, 29)];
        button.bezelStyle = NSThickSquareBezelStyle;
        button.image = [NSImage imageNamed:@"ImageCreate"];
        button.toolTip = @"Создание папки или файла";
        button.image   = [NSImage imageNamed:@"ImageCreate"];
        button.target  = self;
        button.action  = @selector(createItemClicked);
        item.view = button;
    } else if ([itemIdentifier isEqualToString:NSToolbarSortItem]) {
        self->puButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 44, 32) pullsDown:true];
        [self->puButton setBezelStyle:NSThickSquareBezelStyle];
        
        [self->puButton addItemWithTitle:@""];
        [self->puButton addItemWithTitle:@"По убыванию"];
        [self->puButton addItemWithTitle:@"По возрастанию"];
        NSMenuItem *itm = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        [self->puButton.cell setMenuItem: itm];
        
        self->puButton.toolTip = @"Сортировка элементов";
        self->puButton.target  = self;
        self->puButton.action  = @selector(sortItemClicked);
        item.view    = self->puButton;
    } else if ([itemIdentifier isEqualToString:NSToolbarInfoItem]) {
        NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 44, 29)];
        button.bezelStyle = NSThickSquareBezelStyle;
        button.image = [NSImage imageNamed:@"ImageInfo"];
        button.toolTip = @"Свойства папки или файла";
        button.image   = [NSImage imageNamed:@"ImageInfo"];
        button.target  = self;
        button.action  = @selector(infoItemClicked);
        item.view = button;
    } 
    return item;
}

- (void) setDelegate : (id<SEWindowControllerDelegate>) newDelegate {
    self->delegate = newDelegate;
}

- (id<SEWindowControllerDelegate>) getDelegate {
    return self->delegate;
}

- (void) backItemClicked {
    [self->delegate seWindowController:self backToolbarButton:self->toolbar];
}

- (void) createItemClicked {
    [self->delegate seWindowController:self createToolbarButton:self->toolbar];
}

- (void) sortItemClicked {
    [self->delegate seWindowController:self sortToolbarButton:self->toolbar];
}

- (void) infoItemClicked {
    [self->delegate seWindowController:self infoToolbarButton:self->toolbar];
}

- (void) setPathToCurrentDirectory : (NSString *) cPath {
    self->label.stringValue = cPath;
}

@end
