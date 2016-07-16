//
//  ViewController.h
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEDataSource.h"
#import "SEContextMenu.h"
#import "SEFileOperations.h"
#import "SESheetController.h"
#import "SEWindowController.h"
#import "SEDetailsViewController.h"

@interface ViewController : NSViewController <SEContextMenuDelegate, SEWindowControllerDelegate>
{
    NSFileManager *fileManager;
    IBOutlet NSOutlineView *outlineView;
    IBOutlet NSTableView *tableView;
    NSString *currentDirectoryPath;
    SEDataSource *dataSource;
    SEFileOperations *fileOperations;
}

@end

