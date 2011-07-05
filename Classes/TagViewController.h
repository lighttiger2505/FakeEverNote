//
//  TagViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/26.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTagView.h"

@interface TagViewController : UITableViewController <NSFetchedResultsControllerDelegate, NewTagViewDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
	
	NewTagView *newTagView;
	
	NSManagedObject *memo;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NewTagView *newTagView;

@property (nonatomic, retain) NSManagedObject *memo;

- (void)configureTagNameCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
