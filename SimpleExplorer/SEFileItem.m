//
//  SEFileItem.m
//  SimpleExplorer
//
//  Created by Anthony on 15.06.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "SEFileItem.h"

@implementation SEFileItem

@synthesize identifier;
@synthesize path;
@synthesize name;
@synthesize isFolder;
@synthesize size;
@synthesize changeDate;
@synthesize creationDate;
@synthesize ownerName;

- (instancetype) initWithPath : (NSString *) newPath {
    self = [super init];
    if (self != nil) {
        self->identifier = 0;
        self->path = [NSString stringWithString:newPath];
        self->name = [NSString string];
        self->isFolder = true;
        self->size = 0;
        self->changeDate = [NSDate date];
    }
    return self;
}

- (NSString *) getCreationDate : (BOOL) orChangeDate {
    
    NSString *date = [NSString string];
    NSDate *fileDate;
    
    if (orChangeDate == true) {
        fileDate = self->creationDate;
    } else {
        fileDate = self->changeDate;
    }
    
    if (fileDate != nil) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                       fromDate:fileDate];
        NSInteger day   = [components day];
        NSInteger month = [components month];
        NSInteger year  = [components year];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        date = [NSString stringWithFormat:@"%li %@ %li г., %@", day, [self monthName:month], year, [formatter stringFromDate:fileDate]];
    }
    return date;
}

- (NSString *) monthName : (NSInteger) month {
    
    NSString *monthName = [NSString string];
    
    switch (month) {
        case 1 : monthName = @"января";   break;
        case 2 : monthName = @"февраля";  break;
        case 3 : monthName = @"марта";    break;
        case 4 : monthName = @"апреля";   break;
        case 5 : monthName = @"мая";      break;
        case 6 : monthName = @"июня";     break;
        case 7 : monthName = @"июля";     break;
        case 8 : monthName = @"августа";  break;
        case 9 : monthName = @"сентября"; break;
        case 10: monthName = @"октября";  break;
        case 11: monthName = @"ноября";   break;
        case 12: monthName = @"декабря";  break;
            
        default: NSLog(@"MYFileItem.monthName"); break;
    }
    return monthName;
}

- (NSString *) getFileSize {
    
    NSString *fileSize = [NSString string];
    
    if (self->size <= byteMin) {
        fileSize = [NSString stringWithFormat:@"%li Б", self->size];
    } else if (self->size > byteMin && self->size <= kByteMin) {
        fileSize = [NSString stringWithFormat:@"%li КБ", self->size/1000];
    } else if (self->size > kByteMin && self->size <= mByteMin) {
        fileSize = [NSString stringWithFormat:@"%li МБ", self->size/1000000];
    }
    return fileSize;
}

@end
