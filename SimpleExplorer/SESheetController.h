//
//  SESheetController.h
//  SimpleExplorer
//
//  Created by Anthony on 17.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define actionButtonCode 100
#define cancelButtonCode 200

#define folderSegment 0
#define fileSegment 1

@interface SESheetController : NSViewController
{
    IBOutlet NSTextField *titleLabel;
    IBOutlet NSSegmentedControl *segmentControl;
    IBOutlet NSTextField *textField;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSButton *actionButton;
    
    BOOL isCreatingMode;
    NSString *textValue;
    BOOL isFolderSegment;
}

@property BOOL isCreatingMode;
@property (setter = setTextValue: , getter = getTextValue) NSString *textValue;
@property BOOL isFolderSegment;

- (IBAction) cancelButtonClicked : (id) sender;
- (IBAction) actionButtonClicked : (id) sender;
- (IBAction) switchSelectSegment : (id) sender;

@end
