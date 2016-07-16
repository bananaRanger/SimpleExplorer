//
//  SEDetailsViewController.h
//  SimpleExplorer
//
//  Created by Anthony on 19.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SEFileItem.h"

#define okButtonCode 200 

@interface SEDetailsViewController : NSViewController
{
    IBOutlet NSImageView *imageView;
    
    IBOutlet NSTextField *nameLabel;
    IBOutlet NSTextField *changeDateLabel;
    IBOutlet NSTextField *sizeLabel;
    IBOutlet NSTextField *ownerLabel;
    
    IBOutlet NSTextField *typeItem;
    IBOutlet NSTextField *sizeItem;
    IBOutlet NSTextField *pathItem;
    IBOutlet NSTextField *createItem;
    
    SEFileItem *item;
}

@property SEFileItem *item;

- (IBAction) okButtonClicked : (id) sender;

@end
