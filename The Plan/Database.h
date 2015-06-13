//
//  Database.h
//  The Plan
//
//  Created by Tianying Cui on 1/13/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
{
    sqlite3 *db;
}

@property (nonatomic) sqlite3 *db;

//- (BOOL)connectDB;

- (BOOL)addNewThingToDo:(NSString *)thing currentTime:(NSString *)time;

- (BOOL)completeThing:(NSString *)idOfThing;

- (NSArray *)getThingsToDo;

- (int)getCompleteStatus:(int)thingId;

- (BOOL)deleteThing:(int)thingId;

- (BOOL)updateThing:(int)thingId content:(NSString *)content currentTime:(NSString *)time;

- (BOOL)closeDatabase;


@end
