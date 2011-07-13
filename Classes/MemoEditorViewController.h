//
//  DetailViewController.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Memo;

/**
 メモの詳細情報を表示するビューのコントローラー
 */
@interface MemoEditorViewController : UITableViewController <UITextViewDelegate>{
	UITextField *titleView;
	UITextView *textView;
	Memo *memo;
}

@property(nonatomic, retain) UITextField *titleView;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) NSManagedObject *memo;

- (void)saveMemo;
- (void)deleteMemo;
- (void)configureTitleCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureTagCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureTextCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
