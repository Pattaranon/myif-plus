//
//  OilGasListTableViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/4/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "OilGasListTableViewController.h"
#import <sqlite3.h>
#import "OilGasListTableCell.h"

@interface OilGasListTableViewController (){
    NSString *to_day;
}

@end

@implementation OilGasListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString *) getDbFilePath
{
    NSString * docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [docsPath stringByAppendingPathComponent:@"myIF.db"];
}
-(NSMutableArray *) getPrice:(NSString*) filePath where:(NSString *)whereStmt {
    NSMutableArray * reports =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT date_use, SUM(price) as price FROM oilGas GROUP BY date_use";
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString *item_id = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
                NSInteger price =  sqlite3_column_int(stmt, 1);
                
                NSDictionary *report =[NSDictionary dictionaryWithObjectsAndKeys:item_id,@"date_use",
                                       [NSNumber numberWithInteger:price],@"price",nil];
                
                [reports addObject:report];
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return reports;
}
-(NSMutableArray *) groupDate:(NSString*) filePath where:(NSString *)whereStmt {
    NSMutableArray * reports =[[NSMutableArray alloc] init];
    sqlite3* db = NULL;
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT DISTINCT date_use FROM oilGas";
        if(whereStmt)
        {
            query = [query stringByAppendingFormat:@" WHERE %@",whereStmt];
        }
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString *item_id = [NSString stringWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
                // NSString location =  sqlite3_column_int(stmt, 3);
                
                NSDictionary *report =[NSDictionary dictionaryWithObjectsAndKeys:item_id,@"date_use",nil];
                
                [reports addObject:report];
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
    return reports;
}
-(int) deleteByname:(NSString*) filePath withName:(NSString*) name
{
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM oilGas where date_use=\"%@\"",name];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultOilGas = [self groupDate:[self getDbFilePath] where:nil];
    self.priceTotal = [self getPrice:[self getDbFilePath] where:nil];
    
//    UIBarButtonItem *NewButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(self)];
//    
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
//    
//    [[self navigationItem] setBackBarButtonItem:NewButtonItem];
    
    //[self setTitle:@"By Date"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
        //[titleView release];
    }
    titleView.text = title;
    [titleView sizeToFit];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.resultOilGas == nil){
        return 0;
    }
    
    return self.resultOilGas.count;
}
//Message Show
-(void) showMessage:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OilGasListTableCell";
    
    OilGasListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *result = [self.resultOilGas objectAtIndex:indexPath.row];
    NSDictionary *priceTotal = [self.priceTotal objectAtIndex:indexPath.row];
    
    cell.TitleLabel.text = [result objectForKey:@"date_use"];
    cell.priceTotal.text = [[priceTotal objectForKey:@"price"] stringValue];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        //Delete
        to_day = [self.resultOilGas[0] objectForKey:@"date_use"];
        if([to_day length] > 0)
        {
            int rc= [self  deleteByname:[self getDbFilePath] withName:to_day];
            if(rc == SQLITE_OK)
            {
                // Delete the row from the data source.
                [self.resultOilGas removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                [self.tableView reloadData];
            }
            else
            {
                [self showMessage:@"ERROR" withMessage:@"Failed to insert record"];
            }
        }
    }
}

@end
