//
//  ViewController.m
//  LinUtil
//
//  Created by lin on 9/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import <sqlite3.h>
#import "SQLite.h"


@interface Database(){
    @private
    sqlite3 * database;
}

-(id)initWithSqlite:(sqlite3 *) sqlite;

@end

@implementation Database

-(id)initWithSqlite:(sqlite3*)sqlite{
    self = [super init];
    if(self){
        self->database = sqlite;
    }
    return self;
}

+(Database*)open: (NSString *)path{
    
    NSString * ceateSQL = @"CREATE TABLE IF NOT EXISTS DATA_STRORAGE(ID INTEGER PRIMARY KEY AUTOINCREMENT, KEY TEXT, VALUE TEXT)";
    
    sqlite3 * database;
    if (sqlite3_open([path UTF8String], &database)!=SQLITE_OK) {
            sqlite3_close(database);
            
            NSAssert(0, @"open database faid!");
            NSLog(@"数据库创建失败！");
        }
        sqlite3_exec(database, [ceateSQL UTF8String],NULL,NULL,NULL);
    
    return [[Database alloc] initWithSqlite:database];
}


-(int)getItemID:(NSString*)key{
//    [self openDatabase];
    NSString *quary = @"SELECT ID FROM DATA_STRORAGE WHERE KEY = ? ORDER BY ID";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    int id = -1;
    char *errorMsg = NULL;
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, &errorMsg) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [key UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            id = sqlite3_column_int(stmt, 0);
        }
        
        sqlite3_finalize(stmt);
    }else{
        //NSLog(@"error:%@",[[NSString alloc] initWithUTF8String:errorMsg]);
    }
    return id;
}



-(void)setItem:(NSString*)key value:(NSString*)value{
//    [self openDatabase];
    
    char *update;// = "INSERT OR REPLACE INTO DATA_STRORAGE(KEY,VALUE)VALUES(?,?);";
    
    int id = [self getItemID:key];
    if (id == -1){
        update = "INSERT OR REPLACE INTO DATA_STRORAGE(KEY,VALUE)VALUES(?,?);";
    }else{
        update = "UPDATE DATA_STRORAGE SET KEY=?,VALUE=? WHERE ID = ?;";
    }
    //    //上边的update也可以这样写：
    //    //NSString *insert = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PERSIONINFO('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?)",NAME,AGE,SEX,WEIGHT,ADDRESS];
    //
    //char *errorMsg = NULL;
    sqlite3_stmt *stmt;
    //
    if (sqlite3_prepare_v2(database, update, -1, &stmt, NULL) == SQLITE_OK) {
        //
        //        //【插入数据】在这里我们使用绑定数据的方法，参数一：sqlite3_stmt，参数二：插入列号，参数三：插入的数据，参数四：数据长度（-1代表全部），参数五：是否需要回调
        sqlite3_bind_text(stmt, 1, [key UTF8String], -1, NULL);
        //        sqlite3_bind_int(stmt, 2, [self.ageTextField.text intValue]);
        sqlite3_bind_text(stmt, 2, [value UTF8String], -1, NULL);
        if (id != -1){
            sqlite3_bind_int(stmt, 3, id);
        }
        //        sqlite3_bind_int(stmt, 4, [self.weightTextField.text integerValue]);
        //        sqlite3_bind_text(stmt, 5, [self.addressTextField.text UTF8String], -1, NULL);
    }
    if (sqlite3_step(stmt) != SQLITE_DONE){
        NSLog(@"数据更新失败");
    }
    //   NSAssert(0, @"error updating :%s",errorMsg);
    //
    sqlite3_finalize(stmt);
    //
    //sqlite3_close(database);
}

-(NSString *)getItem:(NSString*)key{
//    [self openDatabase];
    NSString *quary = @"SELECT KEY,VALUE FROM DATA_STRORAGE WHERE KEY = ? ORDER BY ID";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    NSString * valueString;
    char *errorMsg = NULL;
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, &errorMsg) == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [key UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt)==SQLITE_ROW) {
            char *value = (char *)sqlite3_column_text(stmt, 1);
            //            value = (char *)sqlite3_column_text(stmt, 1);
            //            value = (char *)sqlite3_column_text(stmt, 3);
            if(value == NULL){
                NSLog(@"error:");
            }else{
                valueString = [[NSString alloc] initWithUTF8String:value];
            }
            
        }
        
        sqlite3_finalize(stmt);
    }else{
        NSLog(@"error:%@",[[NSString alloc] initWithUTF8String:errorMsg]);
    }
    return valueString;
}

-(void)removeItem:(NSString*)key{
//    [self openDatabase];
    NSString *quary = @"DELETE FROM DATA_STRORAGE WHERE KEY = ?";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        //        //【插入数据】在这里我们使用绑定数据的方法，参数一：sqlite3_stmt，参数二：插入列号，参数三：插入的数据，参数四：数据长度（-1代表全部），参数五：是否需要回调
        sqlite3_bind_text(stmt, 1, [key UTF8String], -1, NULL);
        
        if (sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"数据删除失败");
        }
        
        
        
        sqlite3_finalize(stmt);
    }
    
}

-(void)removeAll{
//    [self openDatabase];
    NSString *quary = @"SDELETE FROM DATA_STRORAGE";//SELECT ROW,FIELD_DATA FROM FIELDS ORDER BY ROW
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, [quary UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        
        sqlite3_step(stmt);
        
        sqlite3_finalize(stmt);  
    }
    
}

@end
