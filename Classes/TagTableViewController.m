//
//  TagTableViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/09.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "TagTableViewController.h"

#import "MemoBelongTagTableViewController.h"

#import "Tag.h"

@implementation TagTableViewController

@synthesize managedObjectContext, fetchedResultsController;

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
 
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"タグ";
        self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"タグ" image:[UIImage imageNamed:@"TagIcon.png"] tag:0] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *sections = fetchedResultsController.sections;
	id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

/**
 セルの内容を編集する。
 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// タイトルを表示
    Tag *tagObject = (Tag*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tagObject.name;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    // タグ内容を表示するビューを新規作成選択したタグを設定する
    MemoBelongTagTableViewController *memoBelongtagTableViewConroller = [[MemoBelongTagTableViewController alloc] init];
    Tag *selectedTag = [fetchedResultsController objectAtIndexPath:indexPath];
    memoBelongtagTableViewConroller.selectedTag = selectedTag;
    
    // ビューをナビゲーションにプッシュ
    [self.navigationController pushViewController:memoBelongtagTableViewConroller animated:YES];
    [memoBelongtagTableViewConroller release];
}

/**
 フェッチのコントローラーを作成する。
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
	 */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // 取得するエンティティをタグとしてリクエストに指定
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 一度に取得するデータ量を指定
    [fetchRequest setFetchBatchSize:20];
    
    // 並び替えのキーを指定
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // コンテキストにリクエストを投げてフェッチコントローラーを取得
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                                managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    // フェッチの実行を行う
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        // エラー処理
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	    
    return fetchedResultsController;
}    

@end

