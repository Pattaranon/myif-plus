//
//  AddVehicleViewController.h
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/15/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddVehicleViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *txtAddVehicle;

- (IBAction)btnAdd:(id)sender;
@end
