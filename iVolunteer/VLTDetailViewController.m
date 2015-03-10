//
//  DetailViewController.m
//  iVolunteer
//
//  Created by Pietro Degrazia on 3/9/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "VLTDetailViewController.h"
#import <Parse/Parse.h>

@interface VLTDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property PFObject *local;
@property NSString *userEmail;


@end

@implementation VLTDetailViewController
@synthesize annotationTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    _label.text = self.annotationTitle;

    [_label sizeToFit];
    //    [_descriptionText set]
    PFQuery *query = [PFQuery queryWithClassName:@"Local"];
    query = [query whereKey:@"name" equalTo:self.annotationTitle];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _descriptionText.text =  [objects.firstObject valueForKey:@"placeDescription"];
        _local = objects.firstObject;
    }];
}

- (IBAction)participarButton:(UIButton *)sender {
    NSString *message = [[NSString alloc]initWithFormat:@"We will contact you soon at %@", [[PFUser currentUser]valueForKey:@"email"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

@end
