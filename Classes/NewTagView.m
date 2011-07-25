//
//  NewTagView.m
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/04.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import "NewTagView.h"


@implementation NewTagView

@synthesize delegate;
@synthesize newTagName;

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 100);
		self.backgroundColor = [UIColor groupTableViewBackgroundColor];
		
        // タグの名称を入力するフィールドを作成
		UITextField *aNewTagName = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
		aNewTagName.font = [UIFont systemFontOfSize:20.0f];
		aNewTagName.borderStyle = UITextBorderStyleRoundedRect;
		self.newTagName = aNewTagName;
		[self addSubview:self.newTagName];
		[aNewTagName release];
		
        // セーブボタンを作成
		UIButton *save = [UIButton buttonWithType:111];
		[save addTarget:self action:@selector(saveNewTag) forControlEvents:UIControlEventTouchUpInside];
		save.frame = CGRectMake(10, 50, 300, 40);
		[save setTitle:[NSString stringWithUTF8String:"タグを新規作成"] forState:UIControlStateNormal];
		[self addSubview:save];
    }
    return self;
}

- (void)endEditing {
    [self.newTagName resignFirstResponder];
}

- (IBAction) saveNewTag {
	if (!self.newTagName.text.length == 0) {
        // デリゲートに保存内容を投げる
		[delegate newTagView:self :self.newTagName.text];
		[self endEditing];
	}
}

@end
