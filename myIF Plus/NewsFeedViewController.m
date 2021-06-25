//
//  NewsFeedsViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/3/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "SWRevealViewController.h"

@interface NewsFeedViewController ()

@end

@implementation NewsFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"News Feed";
    
    // Change button color
    _slideNewsFeed.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _slideNewsFeed.target = self.revealViewController;
    _slideNewsFeed.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
