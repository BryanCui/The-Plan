//
//  ThingsToDoTableViewController.h
//  The Plan
//
//  Created by Tianying Cui on 1/18/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomCell.h"
#import "Database.h"

@interface ThingsToDoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, CellDelegate>
{
    //NSMutableArray *things;
    Database *db;
    NSUInteger count;
    
}
@property (nonatomic, strong) Database *db;
@property (nonatomic,strong) NSMutableArray *things;
@property (nonatomic) NSUInteger count;
@property (retain, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (strong,nonatomic) UIView *editingCover;
@property (strong,nonatomic) UITextField *editingCell;

@end
