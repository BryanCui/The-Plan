//
//  AddNewThingToDo.m
//  The Plan
//
//  Created by Tianying Cui on 1/21/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import "AddNewThingToDo.h"
#import "Database.h"

@interface AddNewThingToDo ()

@end

@implementation AddNewThingToDo
//@synthesize previousTableViewController;
- (void)viewDidLoad {
    
    //self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    //self.popUpView.layer.cornerRadius = 5;
    //self.popUpView.layer.shadowOpacity = 0.8;
    //self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
   // self.view.frame = CGRectMake(0, 0+rectInSuperView.origin.y, self.view.frame.size.width, self.view.frame.size.height);


    //NSLog(@"%f", self.superView.frame.size.height);
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    UIScreenEdgePanGestureRecognizer *recognizer;
    recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backToPreviousPage:)];
    //There is a direction property on UISwipeGestureRecognizer. You can set that to both right and left swipes
    recognizer.edges = UIRectEdgeRight;
    //recognizer.delegate = self;
    //[self addGestureRecognizer:recognizer];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [self.view center];
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    NSArray *indexPathForVisible = [self.superView indexPathsForVisibleRows];
    CGRect rectInTableView = [self.superView rectForRowAtIndexPath:[indexPathForVisible objectAtIndex:(NSUInteger)1]];
    CGRect rectInSuperView = [self.superView convertRect:rectInTableView toView:[self.superView superview]];
    NSLog(@"%f", rectInTableView.origin.y);
    NSLog(@"%f", rectInSuperView.origin.y);
    self.view.frame = CGRectMake(0, 0+rectInTableView.origin.y-69, self.view.frame.size.width, self.view.frame.size.height);

}


- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
    
}



- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    self.superView = (UITableView *)aView;
    
    if (animated) {
        [self showAnimate];
    }
}
*/

- (IBAction)confirmAddNewThingButton:(UIButton *)sender
{
    Database *db = [[Database alloc] init];
    if(![self.newThingTextField.text isEqual: @""])
    {
        [db addNewThingToDo:self.newThingTextField.text];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.previousTableViewController.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationBottom];

    }
    [self popView];
    [self.previousTableViewController.tableView reloadData];

    }


- (IBAction)backToPreviousPage:(UIScreenEdgePanGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [self popView];
    }
}


- (void)popView
{
    CATransition* transition = [CATransition animation];
    transition.duration = .45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype= kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)getPreviousTableViewController:(ThingsToDoTableViewController *)tableViewController
{
    
    self.previousTableViewController = tableViewController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_newThingTextField release];
    [_addThingButton release];
    [super dealloc];
}
@end
