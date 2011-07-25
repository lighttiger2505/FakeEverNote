//
//  TagViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/26.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "TagEditorViewController.h"

#import "Memo.h"
#import "Tag.h"

@implementation TagEditorViewController

@synthesize fetchedResultsController, managedObjectContext;
@synthesize newTagView;
@synthesize memo;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // タグを新規作成する為の情報入力ビューをテーブルのヘッダーとして登録
	NewTagView *aNewTagView = [[NewTagView alloc] init];
	aNewTagView.delegate = self;
	self.newTagView = aNewTagView;
	self.tableView.tableHeaderView = self.newTagView;
	[aNewTagView release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	if (memo == nil) {
		NSLog(@"Error:メモが設定されていません。");
	}
		
	[self.fetchedResultsController performFetch:nil];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[self configureTagNameCell:cell atIndexPath:indexPath];
    
    return cell;
}

/**
 タグの内容を表示するセル内容を編集
 */
- (void)configureTagNameCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = tag.name;
    // 既に登録されているタグのセルならばチェックを入れる
	if ([self isEntryTag:tag]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
}

#pragma mark -
#pragma mark Table view delegate

/**
 引数として渡されたタグが編集中のメモに登録されているかをチェックする
 */
- (BOOL)isEntryTag:(Tag*)tag {
	for (Tag *entryTag in memo.tag) {
		if (entryTag == tag) {
			return YES;
		}
	}
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	Tag *selectedTag = [fetchedResultsController objectAtIndexPath:indexPath];
	
	// 既に登録されているタグならば
	if ([self isEntryTag:selectedTag]) {
        // タグをメモを登録して
		cell.accessoryType = UITableViewCellAccessoryNone;
		[selectedTag removeMemoObject:memo];
		[memo removeTagObject:selectedTag];
	}
	// まだ登録されていないタグならば
	else {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[selectedTag addMemoObject:memo];
		[memo addTagObject:selectedTag];
	}
	
	// ハイライトを消す
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark NewTagView delegate

/**
 タグの新規作成イベントが起きた際に呼び出されるデリゲート
 */
- (void)newTagView:(NewTagView*)createNewTag :(NSString*)newTagName 
{
	// タグを新規作成
	Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" 
														 inManagedObjectContext:self.managedObjectContext];
	
	// タグに名前を指定
	tag.name = newTagName;
	// タグのついているメモとして現在編集中のメモを登録
	[tag addMemoObject:memo];
	
	// メモについているタグとして作成したタグを付ける
	[memo addTagObject:tag];
	
	// 現在の状態を保存
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	// 再度フェッチを行って追加したタグを一覧に表示
	[self.fetchedResultsController performFetch:nil];
}

#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureTagNameCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark -   
#pragma mark Fetched results controller 
/**
 フェッチのコントローラーを作成する。
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
	
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // データを取得するエンティティを指定
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
	
    // 取得するデータの並び順を指定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // フェッチのコントローラーを作成
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								managedObjectContext:self.managedObjectContext 
																								  sectionNameKeyPath:nil 
																										   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	// フェッチを実行する。
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return fetchedResultsController;
}

@end

