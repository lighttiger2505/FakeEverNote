//
//  DetailViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemoDetailViewController : UITableViewController <UITextViewDelegate>{
	UITextField *titleView;
	UITextView *textView;
	NSManagedObject *memo;
}

@property(nonatomic, retain) UITextField *titleView;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) NSManagedObject *memo;

- (void)saveMemo:(id)sender;
- (void)configureTitleCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureTagCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureTextCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
