//
//  VLTTableViewController.m
//  iVolunteer
//
//  Created by Marcus Vinicius Kuquert on 3/10/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "VLTTableViewController.h"
#import "VLTDetailViewController.h"

@interface VLTTableViewController ()

@property NSString *titleAuxiliar;

@end

@implementation VLTTableViewController
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // This table displays items in the Todo class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Local"];
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.textLabel.textColor = [UIColor colorWithRed:30.0f/255.0f green:116.0f/255.0f blue:51.0f/255.0f alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:103.0f/255.0f green:194.0f/255.0f blue:154.0f/255.0f alpha:1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Address: %@",
                                 [object objectForKey:@"Address"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _titleAuxiliar = [[self.objects objectAtIndex:[indexPath row]] valueForKey:@"name"];
    [self performSegueWithIdentifier:@"gotoDetail" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoDetail"]){
        VLTDetailViewController *vc = (VLTDetailViewController *)segue.destinationViewController;
        vc.annotationTitle = _titleAuxiliar;
    }
}
@end
