//
//  MemoBelongTagTableViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/13.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "MemoBelongTagTableViewController.h"

#import "Memo.h"
#import "MemoEditorViewController.h"

@implementation MemoBelongTagTableViewController

@synthesize selectedTag, memoArray;

- (void)dealloc
{
    [selectedTag release];
    [memoArray release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:YES];

    if (selectedTag == nil) {
        @throw [NSException exceptionWithName:@"IllegalArgumentException" reason:@"did not set selectedTag" userInfo:nil];
    }
    
    self.title = selectedTag.name;
    // タグを登録しているメモを取得する
    NSSet *tagSetOfMemo = selectedTag.memo;
    // NSSetをArrayに変換
    memoArray = [[NSMutableArray alloc] initWithArray:[tagSetOfMemo allObjects]];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [memoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemoCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// 表示テーブルビューに応じたフェッチコントローラを取得し、フェッチの結果をテーブルセルに代入する。
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Memo *selectedMemo = [memoArray objectAtIndex:indexPath.row];
    MemoEditorViewController *memoEditorViewController = [[MemoEditorViewController alloc] init];
    memoEditorViewController.memo = selectedMemo;
    
    [self.navigationController pushViewController:memoEditorViewController animated:YES];
    [memoEditorViewController release];
}

/**
 セルの内容を編集する。
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// タイトルを表示
    Memo *memoObject = (Memo*)[memoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = memoObject.title;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy/MM/dd"];
	cell.detailTextLabel.text = [formatter stringFromDate:memoObject.timestamp];
}

@end
