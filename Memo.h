//
//  Memo.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/05.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Tag;

@interface Memo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet* tag;

@end


@interface Memo (CoreDataGeneratedAccessors)
- (void)addTagObject:(Tag *)value;
- (void)removeTagObject:(Tag *)value;
- (void)addTag:(NSSet *)value;
- (void)removeTag:(NSSet *)value;

@end

