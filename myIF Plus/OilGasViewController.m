//
//  OilGasViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/4/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "OilGasViewController.h"
#import "SWRevealViewController.h"
#import "ActionSheetStringPicker.h"
#import <sqlite3.h>

@interface OilGasViewController ()
{
    NSString *paramMsg;
}

@end

@implementation OilGasViewController

@synthesize txtToDay;
@synthesize cmbType;
@synthesize txtUnit;
@synthesize txtPrice;
@synthesize txtLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
-(int) createTable:(NSString*) filePath {
    sqlite3* db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * query ="CREATE TABLE IF NOT EXISTS oilGas ( date_use TEXT, type_use TEXT, item TEXT, price INTEGER, location TEXT )";
        //char * query = "DROP TABLE IF EXISTS reports";
        char * errMsg;
        rc = sqlite3_exec(db, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
}
-(int) insert:(NSString *)filePath
   withToDay:(NSString *)to_day
     type_use:(NSString *)type_use
         unit:(NSString *)unit
        price:(NSInteger)price
     location:(NSString *)location {
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
                             stringWithFormat:@"INSERT INTO oilGas (date_use, type_use, item, price, location) VALUES (\"%@\", \"%@\", \"%@\",%ld,\"%@\")",to_day, type_use, unit, (long)price, location];
        
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}
-(NSMutableArray *) groupDate:(NSString*) filePath where:(NSString *)whereStmt
{
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
                //NSLog(@"item_id: %@, type_use: %@, item: %@, price=%ld , location:%@" ,item_id, type_use, item,(long)price,location);
                
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set Navigation Menu.
    self.title = @"Oil & Gas";
    // Change button color
    _slideBarOilgas.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _slideBarOilgas.target = self.revealViewController;
    _slideBarOilgas.action = @selector(revealToggle:);
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //Set custom button.
    //Button save
    self.propSave.normalBackgroundColor = [UIColor clearColor];
    self.propSave.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSave.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSave.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.propSave.cornerRadius = 12.0f;
    self.propSave.borderWidth = 1.0f;
    self.propSave.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSave.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.propSave setFlatTitle:@"Save"];
    
    //Button view
    self.propView.normalBackgroundColor = [UIColor clearColor];
    self.propView.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propView.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propView.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.propView.cornerRadius = 12.0f;
    self.propView.borderWidth = 1.0f;
    self.propView.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propView.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.propView setFlatTitle:@"View"];
    
    //Button Search
    self.propSearch.normalBackgroundColor = [UIColor clearColor];
    self.propSearch.highlightedBackgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSearch.normalForegroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSearch.highlightedForegroundColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    self.propSearch.cornerRadius = 12.0f;
    self.propSearch.borderWidth = 1.0f;
    self.propSearch.normalBorderColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    self.propSearch.highlightedBorderColor = [UIColor colorWithHue:0.0f saturation:0.0f brightness:1.0f alpha:1.0f];
    [self.propSearch setFlatTitle:@"Search"];
    
    //[self createTable:[self getDbFilePath]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath]]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
    }

    //Back bar button navigation comtroler.
    UIBarButtonItem *NewButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(self)];
    //Call function.
    [[self navigationItem] setBackBarButtonItem:NewButtonItem];
    
    //Set DateTime format
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyyMMdd"];
    txtToDay.text = [date stringFromDate:[NSDate date]];
    //Set keybroad.
    txtUnit.keyboardType = UIKeyboardTypeDecimalPad;
    txtPrice.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if([self.txtUnit isFirstResponder] && [touch view] != self.txtUnit){
        [self.txtUnit resignFirstResponder];
    }
    if([self.txtPrice isFirstResponder] && [touch view] != self.txtPrice){
        [self.txtPrice resignFirstResponder];
    }
    if([self.txtLocation isFirstResponder] && [touch view] != self.txtLocation){
        [self.txtLocation resignFirstResponder];
    }
}

- (IBAction)onePickerViewClicked:(UIControl *)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if ([sender respondsToSelector:@selector(setText:)])
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        else
            cmbType.text = selectedValue;
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    NSArray *colors = [NSArray arrayWithObjects:@"", @"95 GOLD", @"91 RED", @"Gasohol 95", @"Gasohol 91", @"Gasohol E20", @"Gasohol E85", @"LPG", @"NGV or CNG", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}
//Method message
-(void) showMessage:(NSString *)title withMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}
-(void) showMsgConfirm:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil]  show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1)
    {
        if([paramMsg isEqualToString:@"SAVE"])
        {
            //Click save
            NSString *to_day = txtToDay.text;
            NSString *type_use = cmbType.text;
            NSString *unit = txtUnit.text;
            double dPrice = [txtPrice.text doubleValue];
            NSString *location = txtLocation.text;
            
            int rc= [self insert:[self getDbFilePath] withToDay:to_day type_use:type_use unit:unit price:dPrice location:location];
            if(rc != SQLITE_OK)
            {
                [self showMessage:@"ERROR" withMessage:@"Failed to insert record"];
            }
            else
            {
                cmbType.text = @"";
                txtUnit.text = @"";
                txtPrice.text = @"";
                txtLocation.text = @"";
            }
        }
    }
    else
    {
        paramMsg = @"";
    }
}

-(BOOL)Validation:(NSString *)to_day
         type_use:(NSString *)type_use
             unit:(NSString *)unit
            price:(NSString *)price
         location:(NSString *)location
{
    if(to_day.length == 0)
        return NO;
    if(type_use.length == 0)
        return NO;
    if(unit.length == 0)
        return NO;
    if(price.length == 0)
        return NO;
    if(location.length == 0)
        return NO;
    else
        return YES;
}

- (IBAction)btnSave:(id)sender {
    paramMsg = @"SAVE";
    NSString *to_day = txtToDay.text;
    NSString *type_use = cmbType.text;
    NSString *unit = txtUnit.text;
    NSString *location = txtLocation.text;
    
    
    if(![self Validation:to_day type_use:type_use unit:unit price:txtPrice.text location:location])
    {
        [self showMessage:@"" withMessage:@"Please select data"];
    }
    else
    {
        [self showMsgConfirm:@"Confirm" withMessage:@"Do you want to save."];
    }
}

- (IBAction)btnView:(id)sender {
    
    NSMutableArray * reports = [self groupDate:[self getDbFilePath] where:nil];
    
    if(reports == nil)
    {
        [self showMessage:@"Warning" withMessage:@"Invalid data to show."];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)btnSearch:(id)sender {
    
}
@end
