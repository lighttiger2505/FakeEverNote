//
//  MemoBelongTagTableViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/13.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tag.h"

@interface MemoBelongTagTableViewController : UITableViewController {
    Tag *selectedTag;
    NSMutableArray *memoArray;
}

@property (nonatomic, retain) Tag *selectedTag;
@property (nonatomic, retain) NSMutableArray *memoArray;

@end
