//
//  MainTabBarViewController.h
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/15/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarViewController : UITabBarController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarTabBar;

@property(nonatomic, weak) IBOutlet UIViewController *plusController;
@property(nonatomic, weak) IBOutlet UIButton *centerButton;

@property(nonatomic, assign) BOOL tabBarHidden;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

@end
