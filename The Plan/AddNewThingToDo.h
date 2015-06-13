//
//  AddNewThingToDo.h
//  The Plan
//
//  Created by Tianying Cui on 1/21/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThingsToDoTableViewController.h"

@interface AddNewThingToDo : UIViewController

@property (nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UITextField *newThingTextField;
@property (strong, nonatomic) IBOutlet UIButton *addThingButton;
@property (nonatomic,strong) ThingsToDoTableViewController *previousTableViewController;

//- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (void)getPreviousTableViewController:(ThingsToDoTableViewController *)tableViewController;

@end
