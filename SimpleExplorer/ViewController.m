//
//  ViewController.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
{
    SEWindowController *seWindowController;
    SEContextMenu *outlineViewMenu;
    SEContextMenu *tableViewMenu;
    SETreeNode *currentParentNode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self->currentDirectoryPath = [NSString string];
    self->currentParentNode = [[SETreeNode alloc] init];
    
    // Создаем свой столбец
    NSTableColumn *columnName = [[NSTableColumn alloc] initWithIdentifier:@"MainColumnName"];
    columnName.title = @"Название";
    [self->outlineView addTableColumn:columnName];
    
    // Назначение столбца главным
    [self->outlineView setOutlineTableColumn:columnName];
    
    // Удаление ненужных столбцов
    NSArray<NSTableColumn *> *arrayOfColumns = self->outlineView.tableColumns;
    for (int i = (int)arrayOfColumns.count - 1; i >= 0; i--) {
        NSTableColumn *column = [arrayOfColumns objectAtIndex:i];
        if ([column.identifier isEqualToString:@"MainColumnName"]) {
            continue;
        }
        [self->outlineView removeTableColumn:column];
    }
    
    NSTableColumn *colFileName = [[NSTableColumn alloc] initWithIdentifier:TableViewFileNameColumn];
    colFileName.headerCell.alignment = NSCenterTextAlignment;
    colFileName.title = @"Название";
    colFileName.minWidth = 300.f;
    [self->tableView addTableColumn:colFileName];
    
    NSTableColumn *colChangeData = [[NSTableColumn alloc] initWithIdentifier:TableViewChangeDataColumn];
    colChangeData.headerCell.alignment = NSCenterTextAlignment;
    colChangeData.title = @"Дата изменения";
    colChangeData.minWidth = 150.f;
    [self->tableView addTableColumn:colChangeData];
    
    NSTableColumn *colFileSize = [[NSTableColumn alloc] initWithIdentifier:TableViewFileSizeColumn];
    colFileSize.headerCell.alignment = NSCenterTextAlignment;
    colFileSize.title = @"Размер";
    colFileSize.minWidth = 50.f;
    [self->tableView addTableColumn:colFileSize];
    
    [self->tableView sizeToFit];
    [self->tableView setRowHeight:24.f];
    [self->tableView setGridStyleMask:NSTableViewGridNone | NSTableViewSolidHorizontalGridLineMask | NSTableViewDashedHorizontalGridLineMask];
    
    self->dataSource        = [[SEDataSource alloc] initWithValue:[[SEFileItem alloc] initWithPath:@""]];
    self->outlineViewMenu   = [[SEContextMenu alloc] initWithMenuTitle:@"OutlineContext" andView:self->outlineView];
    self->tableViewMenu     = [[SEContextMenu alloc] initWithMenuTitle:@"TableContext" andView:self->tableView];
    
    [self addRootDir];
    
    [self->outlineView setDataSource:self->dataSource];
    [self->outlineView setDelegate:self->dataSource];
    
    [self->tableView setDataSource:self->dataSource];
    [self->tableView setDelegate:self->dataSource];
    
    [self->outlineViewMenu  setDelegate:self];
    [self->tableViewMenu    setDelegate:self];
    
    self->fileOperations = [[SEFileOperations alloc] initWithFileManager:self->fileManager];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    self->seWindowController = ((SEWindowController *)self.view.window.windowController);
    [self->seWindowController setDelegate:self];
    
    NSNotificationCenter *noteDefaultCenter = [NSNotificationCenter defaultCenter];
    [noteDefaultCenter addObserver:self selector:@selector(outlineItemWillExpand:)      name:NSOutlineViewItemWillExpandNotification object:    self->outlineView];
    [noteDefaultCenter addObserver:self selector:@selector(outlineSelectionDidChange:)  name:NSOutlineViewSelectionDidChangeNotification object:self->outlineView];
    self->tableView.doubleAction = @selector(tableCellDoubleClick);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)addRootDir {
    
    self->fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *array = [self->fileManager contentsOfDirectoryAtPath:@"/" error:nil];
    
    for (int i = 0; i < array.count; i++) {
        NSString *name = [array objectAtIndex:i];
        NSString *path = [NSString stringWithFormat:@"/%@", name];
        BOOL isFolder = false;
        
        [self->fileManager fileExistsAtPath:path isDirectory:&isFolder];
        if (isFolder == true) {
            
            SEFileItem *item = [[SEFileItem alloc] initWithPath:path];
            item.name = name;
            item.isFolder = isFolder;
            SETreeNode *treeNode = [[SETreeNode alloc] initWithValue:item];
            [self->dataSource addNode:treeNode];
            [self addFalseDirectoryForNode:treeNode];
        }
    }
}

- (void)addFalseDirectoryForNode : (SETreeNode *) node {
    
    NSArray<NSString *> *arrayOfSubDir = [self->fileManager contentsOfDirectoryAtPath:[node getFullPath] error:nil];
    
    for (int j = 0; j < arrayOfSubDir.count; j++) {
        NSString *name = [arrayOfSubDir objectAtIndex:j];
        NSString *path = [NSString stringWithFormat:@"%@/%@", [node getFullPath], name];
        
        BOOL isSubDir = false;
        [self->fileManager fileExistsAtPath:path isDirectory:&isSubDir];
        if (isSubDir == true) {
            
            [node addChildNode:[[SETreeNode alloc] initWithValue:[[SEFileItem alloc] initWithPath:@""]]];
            break;
        }
    }
}

- (void)outlineItemWillExpand : (NSNotification *) notification {
    NSObject *object = [notification.userInfo objectForKey:@"NSObject"];
    if ([object isKindOfClass:[SETreeNode class]]) {
        SETreeNode *treeNode = (SETreeNode *)object;
        
        [treeNode clearChildren]; // удаление старого содержимого
        
        NSArray<NSString *> *array = [self->fileManager contentsOfDirectoryAtPath:[treeNode getFullPath] error:nil];
        for (int i = 0; i < array.count; i++) {
            NSString *name = [array objectAtIndex:i];
            NSString *path = [NSString stringWithFormat:@"%@/%@",[treeNode getFullPath], name];
            BOOL isFolder = false;
            
            [self->fileManager fileExistsAtPath: path isDirectory:&isFolder];
            if (isFolder == true) {
                
                SEFileItem *item = [[SEFileItem alloc] initWithPath:path];
                item.name = name;
                item.isFolder = isFolder;
                SETreeNode *tn = [[SETreeNode alloc] initWithValue:item];
                [treeNode addChildNode:tn];
                
                [self addFalseDirectoryForNode:tn];
            }
        }
    }
}

- (void)outlineSelectionDidChange : (NSNotification *) notification {
    
    NSInteger index = [self->outlineView selectedRow];
    if (index == -1) return;
    
    SETreeNode *treeNode = (SETreeNode *)[self->outlineView itemAtRow:index];
    
    [self->outlineView expandItem:treeNode];
    self->currentDirectoryPath = [treeNode getFullPath];
    self->currentParentNode = treeNode;
    [self->dataSource updateFiles : [treeNode getFullPath]];
    [self->seWindowController setPathToCurrentDirectory:self->currentDirectoryPath];
    [self->tableView reloadData];
}

- (void)tableCellDoubleClick {
    NSInteger row = self->tableView.selectedRow;
    
    SEFileItem *item = [self->dataSource itemByIndex:row];
    if (item.isFolder == true) {
        SETreeNode *treeNode = [self->outlineView itemAtRow:self->outlineView.selectedRow];
        
        [self->outlineView expandItem:treeNode];
        NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:self->outlineView.selectedRow + (item.identifier + 1)];
        [self->outlineView selectRowIndexes:index byExtendingSelection:false];
    } else {
        [self alertMessage:@"К сожалению, открыть файл не получится" withTitle:@"Внимание"];
    }
}

- (void) alertMessage : (NSString *) message withTitle : (NSString *) title {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    alert.alertStyle = NSCriticalAlertStyle;
    [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
}

- (void) contextMenu:(SEContextMenu *)seMenu createItemClick:(NSMenuItem *)item {
    
    SESheetController *sheetController = [[SESheetController alloc] initWithNibName:nil bundle:nil];
    sheetController.isCreatingMode = true;
    NSWindow *window = [NSWindow windowWithContentViewController:sheetController];
    NSString *currentItmPath = [self getPathOfCurrentItem:seMenu];
    if (currentItmPath == nil) {
        currentItmPath = self->currentDirectoryPath;
    }
    [self.view.window beginSheet:window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == actionButtonCode) {
            BOOL result;
            BOOL isFolderCheck = sheetController.isFolderSegment;
            NSString *path = [NSString stringWithFormat:@"%@/%@", [self->fileOperations pathToItemByPath:currentItmPath], sheetController.textValue];

            if (isFolderCheck == true) {
                result = [self->fileOperations createFolder:path];
            } else {
                result = [self->fileOperations createFile:path];
            }
            if (result == true) {
                [self->dataSource updateFiles : self->currentDirectoryPath];
                [self->outlineView reloadItem : self->currentParentNode reloadChildren:true];
                [self->tableView reloadData];
            } else {
                [self alertMessage:@"Создать элемент не удалось" withTitle:@"Внимание"];
            }
        }
    }];
}

- (void) contextMenu:(SEContextMenu *)seMenu renameItemClick:(NSMenuItem *)item {
    
    SESheetController *sheetController = [[SESheetController alloc] initWithNibName:nil bundle:nil];
    sheetController.isCreatingMode = false;
    NSWindow *window = [NSWindow windowWithContentViewController:sheetController];
    NSString *oldPath = [self getPathOfCurrentItem:seMenu];

    if (oldPath != nil) {
    
        sheetController.textValue = [self->fileOperations nameByPath:oldPath];

        [self.view.window beginSheet:window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == actionButtonCode) {
                NSString *newPath = [NSString stringWithFormat:@"%@/%@", self->currentDirectoryPath, sheetController.textValue];
                BOOL result = [self->fileOperations renameItem:oldPath to:newPath];
                if (result == true) {
                    [self->dataSource updateFiles : self->currentDirectoryPath];
                    [self->outlineView reloadItem : self->currentParentNode reloadChildren:true];
                    [self->tableView reloadData];
                } else {
                    [self alertMessage:@"Переименовать элемент не удалось" withTitle:@"Внимание"];
                }
            }
        }];
    } else {
        [self alertMessage:@"Для переименования нужно выбрать элемент" withTitle:@"Внимание"];
    }
}

- (void) contextMenu:(SEContextMenu *)seMenu copyItemClick:(NSMenuItem *)item {
    
    NSString *path = [self getPathOfCurrentItem:seMenu];
    
    if (path != nil) {
        BOOL result = [self->fileOperations copyItemWithFullPath:path andName:[self->fileOperations nameByPath:path]];
        if (result == false) {
            [self alertMessage:@"Копировать элемент не удалось" withTitle:@"Внимание"];
        } else {
            [self->outlineViewMenu setCopyItemDisable];
            [self->tableViewMenu setCopyItemDisable];
        }
    } else {
        [self alertMessage:@"Для копирования нужно выбрать элемент" withTitle:@"Внимание"];
    }
}

- (void) contextMenu:(SEContextMenu *)seMenu pasteItemClick:(NSMenuItem *)item {
    
    NSString *path = [self getPathOfCurrentItem:seMenu];
    if (path == nil) {
        path = self->currentDirectoryPath;
    }
    
    BOOL result = [self->fileOperations copyItemWithFullPath:[self->fileOperations pathToItemByPath:path] andName:nil];
    if (result == true) {
        [self->outlineViewMenu setPasteItemDisable];
        [self->tableViewMenu setPasteItemDisable];
        [self->dataSource updateFiles : self->currentDirectoryPath];
        [self->outlineView reloadItem : self->currentParentNode reloadChildren:true];
        [self->tableView reloadData];
    } else {
        [self alertMessage:@"Вставить элемента не удалось" withTitle:@"Внимание"];
    }
}

- (void) contextMenu:(SEContextMenu *)seMenu deleteItemClick:(NSMenuItem *)item {
    
    NSString *path = [self getPathOfCurrentItem:seMenu];
    
    if (path != nil) {
        BOOL result = [self->fileOperations removeItem: path];
        if (result == true) {
            [self->dataSource updateFiles : self->currentDirectoryPath];
            [self->outlineView reloadItem : self->currentParentNode reloadChildren:true];
            [self->tableView reloadData];
        } else {
            [self alertMessage:@"Удалить элемент не удалось" withTitle:@"Внимание"];
        }
    } else {
        [self alertMessage:@"Для удаления нужно выбрать элемент" withTitle:@"Внимание"];
    }
}

- (void) seWindowController : (SEWindowController *) windowController backToolbarButton:   (NSToolbar *) toolBar {
    NSInteger currentLevel = [self->outlineView levelForRow:self->outlineView.selectedRow];
    NSInteger row = self->outlineView.selectedRow;
    NSInteger level = 0;
    
    do {
        row--;
        level = [self->outlineView levelForRow:row];
    } while (level != currentLevel-1);
    
    NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:row];
    [self->outlineView selectRowIndexes:index byExtendingSelection:false];
    [self->seWindowController setPathToCurrentDirectory:self->currentDirectoryPath];
}

- (void) seWindowController : (SEWindowController *) windowController createToolbarButton: (NSToolbar *) toolBar {
    SESheetController *sheetController = [[SESheetController alloc] initWithNibName:nil bundle:nil];
    sheetController.isCreatingMode = true;
    NSWindow *window = [NSWindow windowWithContentViewController:sheetController];

    [self.view.window beginSheet:window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == actionButtonCode) {
            BOOL result;
            BOOL isFolderCheck = sheetController.isFolderSegment;
            NSString *path = [NSString stringWithFormat:@"%@/%@", self->currentDirectoryPath, sheetController.textValue];
            
            if (isFolderCheck == true) {
                result = [self->fileOperations createFolder:path];
            } else {
                result = [self->fileOperations createFile:path];
            }
            if (result == true) {
                [self->dataSource updateFiles : self->currentDirectoryPath];
                [self->outlineView reloadItem : self->currentParentNode reloadChildren:true];
                [self->tableView reloadData];
            } else {
                [self alertMessage:@"Создать элемент не удалось" withTitle:@"Внимание"];
            }
        }
    }];
}

- (void) seWindowController : (SEWindowController *) windowController sortToolbarButton: (NSToolbar *) toolBar {
    
    NSPopUpButton *button;
    NSArray *array = toolBar.items;
    for (NSToolbarItem *item in array) {
        if ([item.itemIdentifier isEqualToString:NSToolbarSortItem]) {
            button = (NSPopUpButton *)item.view;
        }
    }
    
    NSInteger index = [self->outlineView selectedRow];
    SETreeNode *treeNode = (SETreeNode *)[self->outlineView itemAtRow:index];
    
    if ([button.selectedItem.title isEqualToString:@"По убыванию"]) {
        [self->dataSource updateFiles : [treeNode getFullPath]];
        [self->dataSource sortingNameByAscending:false];
        [self->tableView reloadData];
    } else {
        [self->dataSource updateFiles : [treeNode getFullPath]];
        [self->tableView reloadData];
    }
}

- (void) seWindowController : (SEWindowController *) windowController infoToolbarButton: (NSToolbar *) toolBar {
    
    NSInteger row = self->tableView.selectedRow;
    
    if (row != -1) {
        SEFileItem *item = [self->dataSource itemByIndex:self->tableView.selectedRow];
    
        SEDetailsViewController *detailsController = [[SEDetailsViewController alloc] initWithNibName:nil bundle:nil];
        detailsController.item = item;
        NSWindow *window = [NSWindow windowWithContentViewController:detailsController];
        [self.view.window beginSheet:window completionHandler:nil];
    } else {
        [self alertMessage:@"Элемент не выбран" withTitle:@"Внимание"];
    }
}

- (NSString *) getPathOfCurrentItem : (SEContextMenu *) menu {
    
    NSInteger row = 0;
    NSString *path = nil;
    
    if ([menu isEqualTo:self->outlineViewMenu]) {
        row = self->outlineView.clickedRow;
        if (row == -1) {
            row = self->outlineView.selectedRow;
        }
        SETreeNode *node = [self->outlineView itemAtRow:row];
        path = [node getFullPath];
    } else if ([menu isEqualTo:self->tableViewMenu]) {
        row = self->tableView.clickedRow;
        if (row == -1) {
            row = self->tableView.selectedRow;
        }
        SEFileItem *item = [self->dataSource itemByIndex:row];
        path = item.path;
    }
    return path;
}

@end
