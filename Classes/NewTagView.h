//
//  NewTagView.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/04.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewTagViewDelegate;

@interface NewTagView : UIView {
	id<NewTagViewDelegate> delegate;
	UITextField *newTagName;
}

@property (nonatomic, retain) id<NewTagViewDelegate> delegate;
@property (nonatomic, retain) UITextField *newTagName;

- (IBAction) saveNewTag;

@end

@protocol NewTagViewDelegate

- (void)newTagView:(NewTagView*)createNewTag :(NSString*)newTagName;

@end
