//
//  SESheetController.m
//  SimpleExplorer
//
//  Created by Anthony on 17.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SESheetController.h"

@interface SESheetController ()

@end

@implementation SESheetController

@synthesize isCreatingMode;
@synthesize isFolderSegment;

- (void)viewDidLoad {
    self->isFolderSegment = true;
    [super viewDidLoad];
    [self setCreateMode];
}

- (void) setCreateMode {
    if (self->isCreatingMode == true) {
        self->titleLabel.stringValue = @"Создание элемента";
        self->segmentControl.enabled = true;
        self->actionButton.title = @"Добвить";
    } else {
        self->titleLabel.stringValue = @"Переименование элемента";
        self->segmentControl.enabled = false;
        self->actionButton.title = @"Изменить";
    }
}

- (void)setTextValue:(NSString *)txtValue {
    self->textField.stringValue = txtValue;
    self->textValue = txtValue;
}

- (NSString *)getTextValue {
    self->textValue = self->textField.stringValue;
    return self->textValue;
}

- (IBAction) cancelButtonClicked : (id) sender {
    if (self.view.window.sheet == true) {
        [self.view.window.sheetParent endSheet:self.view.window returnCode:cancelButtonCode];
    } else {
        [NSApp stopModalWithCode:actionButtonCode];
        [self.view.window orderOut:nil];
    }
}

- (IBAction) actionButtonClicked : (id) sender {
    if (self.view.window.sheet == true) {
        [self.view.window.sheetParent endSheet:self.view.window returnCode:actionButtonCode];
    } else {
        [NSApp stopModalWithCode:actionButtonCode];
        [self.view.window orderOut:nil];
    }
}

- (IBAction) switchSelectSegment : (id) sender {
    if ([sender isEqualTo:self->segmentControl]) {
        if (self->segmentControl.selectedSegment == folderSegment) {
            self->isFolderSegment = true;
        } else if (self->segmentControl.selectedSegment == fileSegment) {
            self->isFolderSegment = false;
        }
    }
}

@end
