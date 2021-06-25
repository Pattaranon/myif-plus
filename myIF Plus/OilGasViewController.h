//
//  OilGasViewController.h
//  myIF Plus
//
//  Created by THAICOM-MAC on 7/4/2557 BE.
//  Copyright (c) 2557 Thaicom Plc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQFlatButton.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface OilGasViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarOilgas;

@property (weak, nonatomic) IBOutlet UITextField *txtToDay;
@property (weak, nonatomic) IBOutlet UITextField *cmbType;
@property (weak, nonatomic) IBOutlet UITextField *txtUnit;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet JSQFlatButton *propSave;
@property (weak, nonatomic) IBOutlet JSQFlatButton *propView;
@property (weak, nonatomic) IBOutlet JSQFlatButton *propSearch;


- (IBAction)onePickerViewClicked:(id)sender;

- (IBAction)btnSave:(id)sender;
- (IBAction)btnView:(id)sender;
- (IBAction)btnSearch:(id)sender;

@end
