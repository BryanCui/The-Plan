//
//  CustomCell.m
//  The Plan
//
//  Created by Tianying Cui on 1/20/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import "CustomCell.h"
#import "Database.h"

@implementation CustomCell
{
    int statusOfThing;
}
@synthesize deleteCellGesture;
@synthesize cellDelegate;
@synthesize editCellGesture;
@synthesize tapToEditContentGesture;

- (void)awakeFromNib
{
    // Initialization code
    //self.thingContent.delegate = self;
    
    Database *database = [[Database alloc] init];
    statusOfThing = [database getCompleteStatus:(int)self.tag];
    [database closeDatabase];
    [self.thingContent setEnabled:NO];
    [self.thingContent setFrame:CGRectMake(8, 37, 304, 51)];
    
    //[self.deleteMark setHidden:YES];
    //[self.completeCheckMark setHidden:YES];
    
    //self.aboveView = [[UIView alloc] init];
    [self.aboveView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.aboveView setHidden:NO];
    [self.aboveView setOpaque:YES];
    
    deleteCellGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAboveView:)];
    [self addGestureRecognizer:deleteCellGesture];
    deleteCellGesture.delegate = self;
    deleteCellGesture.delaysTouchesBegan = YES;
    deleteCellGesture.cancelsTouchesInView = NO;
    [deleteCellGesture release];

    editCellGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editCell)];
    [self addGestureRecognizer:editCellGesture];
    [editCellGesture release];
    
    tapToEditContentGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToEditContent)];
    [self addGestureRecognizer:tapToEditContentGesture];
    [tapToEditContentGesture release];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)moveAboveView:(UIPanGestureRecognizer *)sender
{
    static CGPoint position;
    static CGFloat originPositionX;
    originPositionX = self.frame.origin.x;
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        position = [sender locationInView:self.contentView];

    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint movePosition = [sender locationInView:self.contentView];
        if((movePosition.x - position.x) < 0)
        {
            [self.aboveView setFrame:CGRectMake(originPositionX + movePosition.x - position.x, 0, self.frame.size.width, self.frame.size.height)];
            //[self.deleteMark setHidden:NO];

            self.deleteMark.alpha = -(movePosition.x - position.x)/30;
            self.underView.backgroundColor = [UIColor redColor];
            if(self.aboveView.frame.origin.x >= -self.frame.size.width/4)
            {
                self.underView.backgroundColor = [UIColor lightGrayColor];
                if(-(movePosition.x - position.x) > 30)
                {
                    [self.deleteMark setFrame:CGRectMake(297 + movePosition.x - position.x + 30, self.deleteMark.frame.origin.y, self.deleteMark.frame.size.width, self.deleteMark.frame.size.width)];

                }
            }
            else
            {
                self.underView.backgroundColor = [UIColor redColor];
                [self.deleteMark setFrame:CGRectMake(297 + movePosition.x - position.x + 30, self.deleteMark.frame.origin.y, self.deleteMark.frame.size.width, self.deleteMark.frame.size.width)];

            }
        }
        else
        {
            if(statusOfThing == 0)
            {
                [self.aboveView setFrame:CGRectMake(originPositionX + movePosition.x - position.x, 0, self.frame.size.width, self.frame.size.height)];
                //[self.completeCheckMark setHidden:NO];
                self.completeCheckMark.alpha = (movePosition.x - position.x)/30;
                self.underView.backgroundColor = [UIColor greenColor];
                if(self.aboveView.frame.origin.x <= self.frame.size.width/4)
                {
                    //self.completeLabel.text = @"Complete";
                    self.underView.backgroundColor = [UIColor lightGrayColor];

                    if((movePosition.x - position.x) > 30)
                    {
                        [self.completeCheckMark setFrame:CGRectMake(4 + movePosition.x - position.x - 30, self.completeCheckMark.frame.origin.y, self.completeCheckMark.frame.size.width, self.completeCheckMark.frame.size.width)];
                        
                    }

                }
                else
                {
                    //self.completeLabel.text = @"Release to Complete";
                    self.underView.backgroundColor = [UIColor greenColor];
                    [self.completeCheckMark setFrame:CGRectMake(4 + movePosition.x - position.x - 30, self.completeCheckMark.frame.origin.y, self.completeCheckMark.frame.size.width, self.completeCheckMark.frame.size.width)];

                }
                //NSLog(@"%f----",position.x);
            }
        }
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        
        if(self.aboveView.frame.origin.x >= -self.frame.size.width/4 && self.aboveView.frame.origin.x < 0)
        {
            [UIView animateWithDuration:.3 animations:^{
                
                [self.aboveView setFrame:CGRectMake(originPositionX, 0, self.frame.size.width, self.frame.size.height)];
                [self.deleteMark setFrame:CGRectMake(297, 24, self.deleteMark.frame.size.width, self.deleteMark.frame.size.height)];
                
            } completion:^(BOOL finished){
                
            }];
        }
        else if(self.aboveView.frame.origin.x < -self.frame.size.width/4 && self.aboveView.frame.origin.x < 0)
        {
            UITableViewCellEditingStyle editingStyle = UITableViewCellEditingStyleDelete;
            [cellDelegate deleteCellWhenPan:self.cellIndexPath commitEditingStyle:editingStyle];

        }
        
        if(self.aboveView.frame.origin.x <= self.frame.size.width/4 && self.aboveView.frame.origin.x > 0)
        {
            [UIView animateWithDuration:.3 animations:^{
                
                [self.aboveView setFrame:CGRectMake(originPositionX, 0, self.frame.size.width, self.frame.size.height)];
                [self.completeCheckMark setFrame:CGRectMake(4, 23, self.completeCheckMark.frame.size.width, self.completeCheckMark.frame.size.height)];
                
            } completion:^(BOOL finished){

            }];
            
        }
        else if(self.aboveView.frame.origin.x > self.frame.size.width/4 && self.aboveView.frame.origin.x > 0)
        {
            [UIView animateWithDuration:.3 animations:^{
                [self.aboveView setFrame:CGRectMake(originPositionX, 0, self.frame.size.width, self.frame.size.height)];
                [self.completeCheckMark setFrame:CGRectMake(4, 23, self.completeCheckMark.frame.size.width, self.completeCheckMark.frame.size.height)];
                [cellDelegate completeThingWhenPan:self.cellIndexPath];
                //[self.deleteCellGesture setEnabled:NO];

            } completion:^(BOOL finished){
                
            }];
        }
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}



-(IBAction)editCell
{
    [cellDelegate longPressEditCell:self.cellIndexPath longPressGesture:editCellGesture];
}

-(IBAction)tapToEditContent
{
    [cellDelegate tapCellToEditContent:self.cellIndexPath tapGesture:tapToEditContentGesture];
}

- (void)dealloc
{
    [_thingContent release];
    [_timeLabel release];
    [_underView release];
    //[_completeLabel release];
    [_aboveView release];
    [_completeCheckMark release];
    [_deleteMark release];
    [super dealloc];
}
@end
