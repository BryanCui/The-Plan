//
//  ThingsToDoTableViewController.m
//  The Plan
//
//  Created by Tianying Cui on 1/18/15.
//  Copyright (c) 2015 Tianying Cui. All rights reserved.
//

#import "ThingsToDoTableViewController.h"
#import "Database.h"
#import "CustomCell.h"
#import "AddNewThingToDo.h"

@interface ThingsToDoTableViewController ()

@end

@implementation ThingsToDoTableViewController
{
    BOOL pullDownInProgress;
    CustomCell *placeholderCell;
    UITextField *addNewThingTextField;
}
@synthesize things;
@synthesize count;
@synthesize db;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    pullDownInProgress = NO;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }


    
    [self.tableView reloadData];
    self.db = [[Database alloc] init];
    self.things = (NSMutableArray *)[self.db getThingsToDo];
    
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        placeholderCell = [[CustomCell alloc] init];
        placeholderCell.backgroundColor = [UIColor redColor];
    }
    return self;

}



- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    count = [[self.db getThingsToDo] count];
    
    return count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThingCellIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];
    //CustomCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath:indexPath];


    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil] lastObject];
    }
    
    // Configure the cell...
    //cell.textLabel.text = [self.things objectAtIndex:indexPath.row];
    [cell.aboveView setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.firstLineHeadIndent = 24.f;
    //NSLog(@"%@", self.things);
    NSArray *thingAndId = [[self.things objectAtIndex:indexPath.row] componentsSeparatedByString:@","];
    cell.thingContent.text = [thingAndId objectAtIndex:1];
    cell.timeLabel.text = [thingAndId objectAtIndex:2];
    cell.cellDelegate = self;
    
    NSString *idPart = [thingAndId objectAtIndex:0];
    cell.cellIndexPath = indexPath;
    cell.tag = [idPart intValue];
    cell.thingContent.tag = [idPart intValue];
    cell.thingContent.accessibilityLabel = [[NSString alloc] initWithFormat:@"%ld",(long)indexPath.row];
    UIColor *backgroundColor= [UIColor colorWithRed:200/255.0 green:(10+20*indexPath.row)/255.0 blue:(10+12*indexPath.row)/255.0 alpha:1];
    
    NSLog(@"%d", [db getCompleteStatus:[idPart intValue]]);
    
    
    if([db getCompleteStatus:[idPart intValue]] != 0)
    {
        cell.aboveView.backgroundColor = [UIColor grayColor];
    }
    else
    {
        cell.aboveView.backgroundColor = backgroundColor;
    }
    

    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //cell.textLabel.text = @"";
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // Delete the row from the data source
        [self.tableView beginUpdates];
        [self.db deleteThing: [[[[self.things objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] intValue]];
        [self.things removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.editing == YES)
    {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];
        
    NSString *object = [[NSString alloc] initWithString:[things objectAtIndex:fromRow]];
    [things removeObjectAtIndex:fromRow];
    [things insertObject:object atIndex:toRow];
    [self.tableView reloadData];
}

- (IBAction)longPressEditCell:(NSIndexPath *)indexPath longPressGesture:(UILongPressGestureRecognizer *)recognizer
{
    //[self setEditing:YES];
    //UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = recognizer.state;
    
    CGPoint location = [recognizer locationInView:self.tableView];
    NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (currentIndexPath) {
                sourceIndexPath = currentIndexPath;
                NSLog(@"%ld", (long)indexPath.row);
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    //cell.backgroundColor = [UIColor blackColor];
                    [cell setHidden:YES];
                } completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (currentIndexPath && ![currentIndexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [self.things exchangeObjectAtIndex:currentIndexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:currentIndexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = currentIndexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                [cell setHidden:NO];
                [self.tableView reloadData];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            break;
        }
    }


}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


- (IBAction)tapCellToEditContent:(NSIndexPath *)indexPath tapGesture:(UITapGestureRecognizer *)recognizer
{
    
    UIGestureRecognizerState state = recognizer.state;

    if(state == UIGestureRecognizerStateEnded)
    {
        //CGPoint currentCellLocation = [recognizer locationInView:self.tableView];
        //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentCellLocation];
        CustomCell *currentCell = (CustomCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        self.editingCover = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];

        [self.editingCover setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        self.editingCover.tag = currentCell.tag;
        UITapGestureRecognizer *stopEditingGesture;
        stopEditingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStopEditing:)];
        //stopEditingGesture.direction = UISwipeGestureRecognizerDirectionUp;
        //recognizer.delegate = self;
        //[self addGestureRecognizer:recognizer];
        [self.editingCover addGestureRecognizer:stopEditingGesture];
        [stopEditingGesture release];
        
        CGRect frame = CGRectMake(0, 0, currentCell.frame.size.width, currentCell.frame.size.height);
        self.editingCell = [[UITextField alloc] initWithFrame:frame];
        self.editingCell.tag = indexPath.row;
        self.editingCell.font = [UIFont systemFontOfSize:29.0];
        self.editingCell.alpha = 1.0;
        [self.editingCell setText:currentCell.thingContent.text];
        self.editingCell.backgroundColor = currentCell.aboveView.backgroundColor;
        self.editingCell.autocorrectionType = UITextAutocorrectionTypeYes;
        self.editingCell.keyboardType = UIKeyboardTypeDefault;
        self.editingCell.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.editingCell.delegate = self;
        self.editingCell.returnKeyType = UIReturnKeyDone;

        CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.editingCover.layer addAnimation:transition forKey:nil];
        
        
        [self.editingCover addSubview:self.editingCell];
        [self.view.window addSubview:self.editingCover];
        [self.editingCell performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1f];

        
    }

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    int thingId = (int)sender.superview.tag;
    NSString *thingContent = sender.text;
    //NSLog(@"%@",thingContent);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss MM-dd-yyyy"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    
    [db updateThing:thingId content:thingContent currentTime:time];
    [sender resignFirstResponder];
    
    NSString *split_part = @",";
    NSString *updateContentIdNS = [[NSString alloc] initWithFormat:@"%d",thingId];
    NSString *updateContentNS = [[NSString alloc] initWithFormat:@"%@",thingContent];
    NSString *updateContentPart1 = [updateContentIdNS stringByAppendingString:split_part];
    NSString *content = [updateContentPart1 stringByAppendingString:updateContentNS];
    NSString *content_part_2 = [content stringByAppendingString:split_part];
    NSString *content_complete = [content_part_2 stringByAppendingString:time];

    
    int positionInThings = (int)sender.tag;
    [self.things replaceObjectAtIndex:positionInThings withObject:content_complete];
    //NSLog(@"%ld",(long)sender.superview.tag);
    [UIView animateWithDuration:.4 animations:^{
        self.editingCover.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        //self.editingCell.frame = CGRectMake(0, self.view.frame.size.height, self.editingCell.frame.size.width, 0);
        
        
    } completion:^(BOOL finished){
        //[self.editingCell removeFromSuperview];
        [self.editingCover removeFromSuperview];
    }];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0f];
    return YES;
}

- (IBAction)tapStopEditing:(UITapGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:.1 animations:^{
            //self.editingCover.frame = CGRectMake(self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height, 0, 0);
            self.editingCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);

            
        } completion:^(BOOL finished){
            //[self.editingCell removeFromSuperview];
            [self.editingCover removeFromSuperview];
        }];

    }
}

- (IBAction)tapStopEditingAndDelete:(UITapGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:.4 animations:^{
            //self.editingCover.frame = CGRectMake(self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height, 0, 0);
            //self.editingCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
            
            
        } completion:^(BOOL finished){
            //[self.editingCell removeFromSuperview];
            [self.editingCover removeFromSuperview];
        }];
        
        [self.tableView beginUpdates];
        NSIndexPath *newThingDelete = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.db deleteThing: [[[[self.things objectAtIndex:0] componentsSeparatedByString:@","] objectAtIndex:0] intValue]];
        [self.things removeObjectAtIndex:0];
        [self.tableView deleteRowsAtIndexPaths:@[newThingDelete] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
    }
    
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pullDownInProgress = scrollView.contentOffset.y <= -self.navigationController.navigationBar.frame.size.height;
    addNewThingTextField.alpha = 1.0;
    [addNewThingTextField setText:@""];
  
    if(pullDownInProgress)
    {
        [self.tableView insertSubview:placeholderCell atIndex:0];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if(scrollView.contentOffset.y <= 0 && pullDownInProgress)
    {
        placeholderCell.frame = CGRectMake(0, -self.tableView.rowHeight, self.view.frame.size.width, self.tableView.rowHeight);

        if(-scrollView.contentOffset.y-self.navigationController.navigationBar.frame.size.height < self.tableView.rowHeight)
        {
            placeholderCell.thingContent.text = @"Pull to add";
        }
        else
        {
            placeholderCell.thingContent.text = @"Release to add";
        }

        placeholderCell.alpha = MIN(1.0, (-scrollView.contentOffset.y-44)/self.tableView.rowHeight);
    }
    else
    {
        pullDownInProgress = NO;
    }

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(pullDownInProgress && -scrollView.contentOffset.y-self.navigationController.navigationBar.frame.size.height> self.tableView.rowHeight)
    {
        [self.tableView beginUpdates];
        
        [self.db addNewThingToDo:@"" currentTime:@""];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [indexPaths addObject:indexPath];
        
        [self.things insertObject:[[self.db getThingsToDo] lastObject] atIndex:0];
        
        self.things = (NSMutableArray *)[self.db getThingsToDo];
        [self.tableView reloadData];
        
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        //[self.tableView reloadData];
        [self.tableView endUpdates];
        [[self.tableView cellForRowAtIndexPath:indexPath] setEditing:YES];
        [self.tableView reloadData];
        
        NSIndexPath *currentAddedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CustomCell *currentAddedCell = (CustomCell *)[self.tableView cellForRowAtIndexPath:currentAddedIndexPath];
        NSLog(@"%@",currentAddedCell.thingContent.text);
        [currentAddedCell.aboveView setFrame:CGRectMake(0, 0, currentAddedCell.frame.size.width, currentAddedCell.frame.size.height)];

        self.editingCover = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.editingCover setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
        self.editingCover.tag = currentAddedCell.tag;
        UITapGestureRecognizer *stopEditingGesture;
        stopEditingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStopEditingAndDelete:)];
        //stopEditingGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self.editingCover addGestureRecognizer:stopEditingGesture];
        [stopEditingGesture release];

        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableView.rowHeight);
        addNewThingTextField = [[UITextField alloc] initWithFrame:frame];
        addNewThingTextField.tag = indexPath.row;
        addNewThingTextField.font = [UIFont systemFontOfSize:29.0];
        addNewThingTextField.alpha = 1.0;
        [addNewThingTextField setText:@""];
        addNewThingTextField.backgroundColor = currentAddedCell.aboveView.backgroundColor;
        addNewThingTextField.autocorrectionType = UITextAutocorrectionTypeYes;
        addNewThingTextField.keyboardType = UIKeyboardTypeDefault;
        addNewThingTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        addNewThingTextField.delegate = self;
        addNewThingTextField.returnKeyType = UIReturnKeyDone;

        CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.editingCover.layer addAnimation:transition forKey:nil];
        
        
        [self.editingCover addSubview:addNewThingTextField];
        [self.view.window addSubview:self.editingCover];
        [addNewThingTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0f];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1f];

        
        //[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0f];
    }
    else
    {
        pullDownInProgress = NO;
        [placeholderCell removeFromSuperview];
    }


}


-(void)deleteCellWhenPan:(NSIndexPath *)indexPath commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"%ld------%ld",(long)indexPath.row,(long)indexPath.section);
        // Delete the row from the data source
        [self.tableView beginUpdates];
        [self.db deleteThing: [[[[self.things objectAtIndex:indexPath.row] componentsSeparatedByString:@","] objectAtIndex:0] intValue]];
        [self.things removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];
    }
}

-(void)completeThingWhenPan:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];

    CustomCell *currentCell = (CustomCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *thingId = [[NSString alloc] initWithFormat:@"%ld", (long)currentCell.tag];
    [db completeThing:thingId];
    currentCell.aboveView.backgroundColor = [UIColor grayColor];
    [self.tableView endUpdates];
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];

}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
    [_longPressGesture release];
    [super dealloc];
}
@end
