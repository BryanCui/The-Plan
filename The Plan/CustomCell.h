//
//  CustomCell.h
//  The Plan
//
//  Created by Tianying Cui on 1/20/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"

@protocol CellDelegate <NSObject>

-(void)deleteCellWhenPan:(NSIndexPath *)indexPath commitEditingStyle:(UITableViewCellEditingStyle)editingStyle;
-(void)longPressEditCell:(NSIndexPath *)indexPath longPressGesture:(UILongPressGestureRecognizer *)recognizer;
-(void)tapCellToEditContent:(NSIndexPath *)indexPath tapGesture:(UITapGestureRecognizer *)recognizer;
-(void)completeThingWhenPan:(NSIndexPath *)indexPath;


@end

@interface CustomCell : UITableViewCell <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    id<CellDelegate> cellDelegate;
}

@property (retain,nonatomic) id<CellDelegate> cellDelegate;
@property (retain, nonatomic) IBOutlet UIView *underView;
@property (retain, nonatomic) IBOutlet UIImageView *completeCheckMark;
@property (retain, nonatomic) IBOutlet UIImageView *deleteMark;
@property (retain, nonatomic) IBOutlet UIView *aboveView;
@property (retain, nonatomic) IBOutlet UITextField *thingContent;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (strong, nonatomic) UIPanGestureRecognizer *deleteCellGesture;
@property (strong, nonatomic) UILongPressGestureRecognizer *editCellGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapToEditContentGesture;



@end
