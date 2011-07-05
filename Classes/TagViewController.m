//
//  TagViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/26.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "TagViewController.h"


@implementation TagViewController

@synthesize fetchedResultsController, managedObjectContext;
@synthesize newTagView;
@synthesize memo;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NewTagView *aNewTagView = [[NewTagView alloc] init];
	aNewTagView.delegate = self;
	self.newTagView = aNewTagView;
	self.tableView.tableHeaderView = self.newTagView;
	[aNewTagView release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
		
	[self.fetchedResultsController performFetch:nil];
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[self configureTagNameCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureTagNameCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [tag valueForKey:@"name"];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -
#pragma mark NewTagView delegate

- (void)newTagView:(NewTagView*)createNewTag :(NSString*)newTagName 
{
	NSManagedObject *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" 
														 inManagedObjectContext:self.managedObjectContext];
	
	[tag setValue:newTagName forKey:@"name"];
	
	NSError *error;
	if (![self.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	[self.fetchedResultsController performFetch:nil];
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

