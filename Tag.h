//
//  Tag.h
//  CoreDataMemo
//
//  Created by ohashi tosikazu on 11/07/05.
//  Copyright 2011 nagoya-bunri. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Tag :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* memo;

@end


@interface Tag (CoreDataGeneratedAccessors)
- (void)addMemoObject:(NSManagedObject *)value;
- (void)removeMemoObject:(NSManagedObject *)value;
- (void)addMemo:(NSSet *)value;
- (void)removeMemo:(NSSet *)value;

@end

