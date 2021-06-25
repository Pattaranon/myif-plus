//
//  MainTabBarViewController.m
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/15/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "SWRevealViewController.h"

@interface MainTabBarViewController ()
{
    UIView* leftButtonView;
}

@end

@implementation MainTabBarViewController

@synthesize plusController;
@synthesize centerButton;

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
    
    self.title = @"Vehicle";
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"hood.png"] highlightImage:[UIImage imageNamed:@"hood-selected.png"] target:self action:@selector(buttonPressed:)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self NavBar];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}
- (void)buttonPressed:(id)sender
{
    [self setSelectedIndex:1];
    [self performSelector:@selector(doHighlight:) withObject:sender afterDelay:0];
}

- (void)doHighlight:(UIButton*)b
{
    [b setHighlighted:YES];
}

- (void)doNotHighlight:(UIButton*)b
{
    [b setHighlighted:NO];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(self.tabBarController.selectedIndex != 2){
        [self performSelector:@selector(doNotHighlight:) withObject:centerButton afterDelay:0];
    }
}

- (BOOL)tabBarHidden
{
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
}

-(void)NavBar
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
        for(UIView* view in self.navigationController.navigationBar.subviews)
        {
            if(view.tag == 99997)
            {
                [view removeFromSuperview];
            }
        }
    }
    
    leftButtonView = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, 100, 47)];
    
    UIImageView *leftButton = [[UIImageView alloc]initWithFrame:CGRectMake(1, 12, 28, 20)];
    leftButton.image = [UIImage imageNamed:@"menu.png"];
    leftButton.tintColor = [UIColor whiteColor];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(12, -2, 100, 50)];
    lbl.text= @"";
    lbl.font=[UIFont systemFontOfSize:16];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    [leftButtonView addSubview:leftButton];
    [leftButtonView addSubview:lbl];
    
    UITapGestureRecognizer *tapRe;
	tapRe = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(revealToggle:)];
	tapRe.numberOfTapsRequired = 1;
    
    
	[leftButtonView addGestureRecognizer:tapRe];
    //CGSize size = CGSizeMake(self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
	
    //UIImageView *Logo;
	UINavigationItem *navItem;
    
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//	{
//		Logo = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 46, 36)];
//		Logo.image = [UIImage imageNamed:@"logoapp.png"];
//	}
//	else
//	{
//		Logo = [[UIImageView alloc] initWithFrame:CGRectMake(32, 0, 178, 36)];
//		Logo.image = [UIImage imageNamed:@"MconnectLogo.png"];
//	}
	navItem = self.navigationItem;
	//UIView* containerL = [[UIView alloc] initWithFrame:CGRectMake(size.width, 0, (size.width / 2) + 109, 47)];
    
	//[containerL addSubview:Logo];
	//[containerL bringSubviewToFront:Logo];
    
	//UITapGestureRecognizer *tapRecognizer;
	//tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.revealViewController action:@selector(revealToggle:)];
	//tapRecognizer.numberOfTapsRequired = 1;
    
	//[Logo addGestureRecognizer:tapRecognizer];
	//[Logo setUserInteractionEnabled:YES];
    
   	//navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerL];
    
    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButtonView];
    
    //  self.forward.image = nil;
    navItem.leftBarButtonItem = leftBarButton;
}

@end
