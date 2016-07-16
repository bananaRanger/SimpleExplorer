//
//  SEDetailsViewController.m
//  SimpleExplorer
//
//  Created by Anthony on 19.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEDetailsViewController.h"

@interface SEDetailsViewController ()

@end

@implementation SEDetailsViewController

@synthesize item;

- (void)viewDidLoad {
    [super viewDidLoad];
    self->imageView.image = (item.isFolder)?[NSImage imageNamed:@"NSFolder"]:[NSImage imageNamed:@"ImageFile"];
    
    self->nameLabel.stringValue = item.name;
    self->changeDateLabel.stringValue = [item getCreationDate:false];
    self->sizeLabel.stringValue = (item.isFolder)?@"":[item getFileSize];
    self->ownerLabel.stringValue = item.ownerName;
    
    self->typeItem.stringValue = (item.isFolder)?@"Папка":@"Файл";
    self->sizeItem.stringValue = (item.isFolder)?@"":[item getFileSize];
    self->pathItem.stringValue = item.path;
    self->createItem.stringValue = [item getCreationDate:true];
}

- (IBAction) okButtonClicked : (id) sender {
    if (self.view.window.sheet == true) {
        [self.view.window.sheetParent endSheet:self.view.window returnCode:okButtonCode];
    } else {
        [NSApp stopModalWithCode:okButtonCode];
        [self.view.window orderOut:nil];
    }
}

@end
