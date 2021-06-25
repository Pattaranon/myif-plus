//
//  AddVehicleViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/15/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "AddVehicleViewController.h"
#import "OilGasMainTableViewController.h"
#import "MainTabBarViewController.h"

@interface AddVehicleViewController ()

@end

@implementation AddVehicleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Method
-(void) showMessage:(NSString *)title withMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.topItem.title = @"Add Vehicle";
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.topItem.title = @"Add Vehicle";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    
    if([self.txtAddVehicle isFirstResponder] && [touch view] != self.txtAddVehicle){
        [self.txtAddVehicle resignFirstResponder];
    }
}

- (IBAction)btnAdd:(id)sender
{
    @try
    {
        if(! [self.txtAddVehicle.text isEqualToString:@""])
        {
            OilGasMainTableViewController *oilGas = [[OilGasMainTableViewController alloc] init];
            oilGas.Addvehicle = self.txtAddVehicle.text == nil ? @"" : self.txtAddVehicle.text;
            
            //Call page vehicle.
            self.tabBarController.selectedIndex = 0;
        }
        else
        {
            //Alert
            [self showMessage:@"Warning" withMessage:@"Please enter vehicle"];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error button add vehicle : %@", exception);
    }
    
}
@end
