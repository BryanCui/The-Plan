//
//  Database.m
//  The Plan
//
//  Created by Tianying Cui on 1/13/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import "Database.h"

@implementation Database

-(id)init
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent: @"thingsToDo.sqlite"];
    const char *fileNameOfC = fileName.UTF8String;
    //NSLog(@"%@",fileName);
    //sqlite3 *db = self->db;
    int fileOpenOrNot = sqlite3_open(fileNameOfC,&db);
    if(fileOpenOrNot == SQLITE_OK)
    {
        NSLog(@"Database opens successfully!");
        const char *createToDoListDBTable = "CREATE TABLE IF NOT EXISTS things_to_do (id integer PRIMARY KEY AUTOINCREMENT, thingsToDo text NOT NULL, time text NOT NULL, isCompleted int NOT NULL);";
        char *errorMessage = NULL;
        int tableCreatedOrNot = sqlite3_exec(db, createToDoListDBTable, NULL, NULL, &errorMessage);
        if(tableCreatedOrNot == SQLITE_OK)
        {
            NSLog(@"Table creates successfully!");
            //return YES;
        }
        else
        {
            NSLog(@"Table creation encounters problems!");
            //return NO;
        }
    }
    else
    {
        NSLog(@"Database encounters problems!");
        //return NO;
        
    }
    

    return self;
}



-(BOOL)completeThing:(NSString *)idOfThing
{
    sqlite3_stmt *completeThingStatement;
    static char *completeSQL = "UPDATE things_to_do SET isCompleted = ? WHERE id = ?";
    if(sqlite3_prepare_v2(db, completeSQL, -1, &completeThingStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(completeThingStatement, 1, [@"1" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(completeThingStatement, 2, [idOfThing intValue]);
        
        int isCompleteSuccess = sqlite3_step(completeThingStatement);
        sqlite3_finalize(completeThingStatement);
        if(isCompleteSuccess != SQLITE_ERROR)
        {
            NSLog(@"Complete succeed!!!");
            return YES;
        }
        else
        {
            NSLog(@"Complete failed!!!");
            return NO;
        }
    }
    return NO;

}


-(NSArray *)getThingsToDo
{
    const char * getThingsToDo = "SELECT id,thingsToDo,time FROM things_to_do";
    NSMutableArray *things = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;

    if(sqlite3_prepare_v2(db, getThingsToDo, -1, &statement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            int content_id = sqlite3_column_int(statement,0);
            char *content_thing = (char*)sqlite3_column_text(statement,1);
            char *content_time = (char*)sqlite3_column_text(statement, 2);
            NSString *split_part = @",";
            NSString *content_id_NS = [[NSString alloc] initWithFormat:@"%d",content_id];
            NSString *content_thing_NS = [[NSString alloc] initWithUTF8String:content_thing];
            NSString *content_time_NS = [[NSString alloc] initWithUTF8String:content_time];
            NSString *content_part_1 = [content_id_NS stringByAppendingString:split_part];
            NSString *content = [content_part_1 stringByAppendingString:content_thing_NS];
            NSString *content_part_2 = [content stringByAppendingString:split_part];
            NSString *content_complete = [content_part_2 stringByAppendingString:content_time_NS];
            [things insertObject:content_complete atIndex:0];
        }
    }
    return things;
}

-(int)getCompleteStatus:(int)thingId
{
    const char * getCompleteStatus = "SELECT isCompleted FROM things_to_do WHERE id = ?";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, getCompleteStatus, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, 1, thingId);
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            int status = sqlite3_column_int(statement, 0);
            //NSLog(@"%d", status);
            if(status == 0)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
    }
    return 0;
}


- (BOOL)addNewThingToDo:(NSString *)thing currentTime:(NSString *)time
{
    int isCompleted = 0;
    NSString *addNewThing = [NSString stringWithFormat:@"INSERT INTO things_to_do (thingsToDo, time, isCompleted) VALUES ('%@','%@', %d);", thing, time, isCompleted];
    
    char *errorMessage = NULL;
    sqlite3_exec(db, addNewThing.UTF8String, NULL, NULL, &errorMessage);
    
    if(errorMessage)
    {
        NSLog(@"Insert failed! --%s", errorMessage);
        return NO;
    }
    else
    {
        NSLog(@"Insert successfully!");
        return YES;
    }
    
}


- (BOOL)updateThing:(int)thingId content:(NSString *)content currentTime:(NSString *)time
{
    sqlite3_stmt *updateThingStatement;
    static char *updateSQL = "UPDATE things_to_do SET thingsToDo = ?, time = ? WHERE id = ?";
    if(sqlite3_prepare_v2(db, updateSQL, -1, &updateThingStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(updateThingStatement, 1, [content UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateThingStatement, 2, [time UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(updateThingStatement, 3, thingId);
        NSLog(@"--%d--%@--%s",thingId,content,[time UTF8String]);

        int isUpdateSuccess = sqlite3_step(updateThingStatement);
        sqlite3_finalize(updateThingStatement);
        if(isUpdateSuccess != SQLITE_ERROR)
        {
            NSLog(@"Update succeed!!!");
            return YES;
        }
        else
        {
            NSLog(@"Update failed!!!");
            return NO;
        }
    }
    return NO;
}


- (BOOL)deleteThing:(int)thingId
{
    sqlite3_stmt *deleteThingStatement;
    static char *deleteSQL = "DELETE FROM things_to_do WHERE id = ?";
    if(sqlite3_prepare_v2(db, deleteSQL, -1, &deleteThingStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_int(deleteThingStatement, 1, thingId);
        int isDeleteSuccess = sqlite3_step(deleteThingStatement);
        sqlite3_finalize(deleteThingStatement);
        if(isDeleteSuccess != SQLITE_ERROR)
        {
            NSLog(@"Delete succeed!!!");
            return YES;
        }
        else
        {
            NSLog(@"Delete failed!!!");
            return NO;
        }
    }
    return NO;
}

-(BOOL)closeDatabase
{
    if(sqlite3_close(db))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
