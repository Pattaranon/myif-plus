//
//  OilGasMainTableViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/14/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "OilGasMainTableViewController.h"
#import "SWRevealViewController.h"

@interface OilGasMainTableViewController ()
{
    NSMutableArray *VehicleArray;
}

@end

@implementation OilGasMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //Start load
    [super viewDidLoad];
    
    //CGSize size = self.navigationController.view.frame.size;
    //UIImageView *Logo;
	UINavigationItem *navItem;
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    navItem = self.parentViewController.navigationItem;
    
    self.navigationController.navigationBar.topItem.title = @"Vehicle";
}
/*
-(void)viewDidAppear:(BOOL)animated
{
    //When load complete
    [super viewDidAppear:animated];
    //Set title.
    self.navigationController.navigationBar.topItem.title = @"Vehicle";
    //Pass vehicle value.
    NSString *add_vehicle = self.Addvehicle == nil ? @"" : self.Addvehicle;
    if(![add_vehicle isEqualToString:@""])
    {
        VehicleArray = [[NSMutableArray alloc] init];
        
        [VehicleArray addObject:self.Addvehicle];
    }
}
 */
-(void)viewWillAppear:(BOOL)animated
{
    //Set title.
    self.navigationController.navigationBar.topItem.title = @"Vehicle";
    
    //Pass vehicle value.
    NSString *add_vehicle = self.Addvehicle;
    if(![add_vehicle isEqualToString:@""] && add_vehicle != nil)
    {
        VehicleArray = [[NSMutableArray alloc] init];
        
        [VehicleArray addObject:self.Addvehicle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 0;
}

@end
