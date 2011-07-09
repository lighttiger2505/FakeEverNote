    //
//  DetailViewController.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/06/16.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "MemoDetailViewController.h"

#import "Memo.h"
#import "Tag.h"
#import "TagViewController.h"

#define TITLE_CELL_HEIGHT 40
#define TAG_CELL_HEIGHT   40
#define TEXT_CELL_HEIGHT  418

@implementation MemoDetailViewController

@synthesize titleView, textView;
@synthesize memo;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	titleView = nil;
	textView = nil;
}


- (void)dealloc {
	[titleView release];
	[textView release];
	[memo release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

/**
 ビューのロード後に呼び出される。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = memo.title;
	
	// ナビゲーションバー右にキーボードを画すボタンを追加
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																							target:self action:@selector(finish:)] autorelease];
	
	self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	
	// タイトル入力のビューを作成して親のビューに追加
	UITextField *aTitleView = [[UITextField alloc] init];
	aTitleView.font = [UIFont systemFontOfSize:20.0f];
	self.titleView = aTitleView;
	[aTitleView release];
	
	// テキスト入力のビューを作成して親のビューに追加。
	UITextView *aTextView = [[UITextView alloc] init];
	aTextView.delegate = self;
	aTextView.frame = [[UIScreen mainScreen] bounds];
	aTextView.font = [UIFont systemFontOfSize:20.0f];
	aTextView.scrollEnabled = YES;
	self.textView = aTextView;
	[aTextView release];
	
}

/**
 ビューを開いた際に呼び出される。
 渡されたメモの内容を反映。
 */
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	
	// 渡されたオブジェクトからメモの内容を表示させる。
	self.titleView.text = memo.title;
	self.textView.text = memo.text;
	
	[self.tableView reloadData];
	[self.titleView becomeFirstResponder];
}

/**
 ビューを閉じた際に呼び出される。
 メモの保存を実行。
 */
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:YES];
	
	// メモの保存を実行。
	[self saveMemo:nil];
}

/**
 メモを保存する。
 */
- (void)saveMemo:(id)sender {
	// 変更内容をデータオブジェクトに反映。
	memo.title = self.titleView.text;
	memo.text = self.textView.text;
	memo.timestamp = [[NSDate date] retain];
	
	// コンテキストに保存内容を反映。
	NSError *error;
	if (![[memo managedObjectContext] save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

/**
 テキスト編集開始時に呼び出されるメソッド
 */
- (void)textViewDidBeginEditing:(UITextView *)handleTextView {
	// このメソッドの送信元がメモの編集ビューならば
	if(handleTextView == self.textView) {
		// ビューのサイズをキーボードで隠れない程度に小さくする
		CGRect  frame;
		frame.origin.x = 0 ;
		frame.origin.y = 0 ;
		frame.size.width = 320 ;
		frame.size.height = 232 ;
		
		handleTextView.frame = frame ;
	}
}

/**
 テキスト編集終了時に呼び出されるメソッド
 */
- (void)textViewDidEndEditing:(UITextView *)handleTextView {
	// このメソッドの送信元がメモの編集ビューならば
	if(handleTextView == self.textView) {
		// ビューのサイズを画面一杯のサイズに戻す
		CGRect  frame;
		frame.origin.x = 0 ;
		frame.origin.y = 0 ;
		frame.size.width = 320 ;
		frame.size.height = 480 ;
		
		handleTextView.frame = frame ;
	}
}

/**
 右上のボタンを押すことでで実行されるコマンド
 */
-(IBAction)finish:(id)sender {
	// キーボードを隠す処理
	[self.titleView resignFirstResponder];
	[self.textView resignFirstResponder];
}

#pragma mark -
#pragma mark Table view data source

/**
 セクション数を返すデリゲートの実装。
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 セクション内のデータ数を返すデリゲートの実装。
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   
	// 各セルに合った高さを設定
	if (indexPath.row == 0) {
		return TITLE_CELL_HEIGHT;
	}
	if (indexPath.row == 1) {
		return TAG_CELL_HEIGHT;
	}
	if (indexPath.row == 2) {
		return TEXT_CELL_HEIGHT;
	}
	return 0;
}

/**
 引数に渡されたセルの情報を編集して返すデリゲートの実装。
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// 各セルに合わせたセルを作成
	if (indexPath.row == 0) {
		[self configureTitleCell:cell atIndexPath:indexPath];
	}
	if (indexPath.row == 1) {
		[self configureTagCell:cell atIndexPath:indexPath];
	}
	if (indexPath.row == 2) {
		[self configureTextCell:cell atIndexPath:indexPath];
	}
    return cell;
}

/**
 タイトル入力セルの内容を編集
 */
- (void)configureTitleCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
	// セルに最適なサイズを取得してタイトル入力フィールドに設定
	CGRect frame = CGRectInset(cell.contentView.bounds, 16, 8);
	titleView.frame = frame;
	// タイトル入力フィールドをセルに追加
	[cell.contentView addSubview:titleView];
}

/**
 タグ入力セルの内容を編集
 */
- (void)configureTagCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	NSString* tagListStr = @"";
	for (Tag* entryTag in memo.tag) {
		tagListStr = [tagListStr stringByAppendingFormat:@"'%@'", entryTag.name];
	}
	cell.textLabel.text = tagListStr;
}

/**
 テキスト入力セルの内容を編集
 */
- (void)configureTextCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// テキスト入力ビューをセルに追加
	[cell.contentView addSubview:self.textView];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	// タグのセルが選択された場合、タグを選択する画面へと遷移する。
	if (indexPath.row == 1) {
		TagViewController *aTagViewController = [[TagViewController alloc] initWithStyle:UITableViewStyleGrouped];
		aTagViewController.memo = memo;
		aTagViewController.managedObjectContext = self.memo.managedObjectContext;
		[self.navigationController pushViewController:aTagViewController animated:YES];
		[aTagViewController release];
	}
}

@end
