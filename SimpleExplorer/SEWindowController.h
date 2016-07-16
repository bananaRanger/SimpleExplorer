//
//  SEWindowController.h
//  SimpleExplorer
//
//  Created by Anthony on 17.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const NSToolbarBackItem;
extern NSString *const NSToolbarPathItem;
extern NSString *const NSToolbarCreateItem;
extern NSString *const NSToolbarSortItem;
extern NSString *const NSToolbarInfoItem;

@protocol  SEWindowControllerDelegate;
@interface SEWindowController : NSWindowController <NSToolbarDelegate>
{
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSTextField *label;
    IBOutlet NSPopUpButton *puButton;
    id<SEWindowControllerDelegate> delegate;
}

@property (nonatomic) id<SEWindowControllerDelegate> delegate;

- (void) setDelegate : (id<SEWindowControllerDelegate>) newDelegate;
- (id<SEWindowControllerDelegate>) getDelegate;

- (void) setPathToCurrentDirectory : (NSString *) cPath;

@end

@protocol SEWindowControllerDelegate <NSObject>

@required
- (void) seWindowController : (SEWindowController *) windowController backToolbarButton:   (NSToolbar *) toolBar;
- (void) seWindowController : (SEWindowController *) windowController createToolbarButton: (NSToolbar *) toolBar;
- (void) seWindowController : (SEWindowController *) windowController sortToolbarButton:   (NSToolbar *) toolBar;
- (void) seWindowController : (SEWindowController *) windowController infoToolbarButton:   (NSToolbar *) toolBar;

@end