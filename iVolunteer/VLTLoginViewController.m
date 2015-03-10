//
//  ViewController.m
//  iVolunteer
//
//  Created by Marcus Vinicius Kuquert on 3/6/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "VLTLoginViewController.h"

@interface VLTLoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@end

@implementation VLTLoginViewController{
    CGFloat _initialConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    UIColor *color = [UIColor lightTextColor];
    _usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    //Chack if it is iPhone or not to place the gif
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bgf" ofType:@"gif"];
        NSData *gif = [NSData dataWithContentsOfFile:filePath];
        [_webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [self.view sendSubviewToBack:_webView];
    }
    else
        [_webView removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated{
    _usernameField.text = nil;
    _passwordField.text =nil;
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
static CGFloat keyboardHeightOffset = 0.0f;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButton:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text
                                    block:^(PFUser *user, NSError *error)
     {
         if (user) {
             [self performSegueWithIdentifier:@"gotoMain" sender:sender];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:[error.userInfo valueForKey:@"error"]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
     }];
}

-(IBAction)facebookButton:(UIButton *)sender{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"publish_stream"];
    NSLog(@"Entrou");
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:[errorMessage.description valueForKey: @"error"]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self performSegueWithIdentifier:@"gotoMain" sender:nil];
        }
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _constraintBottom.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _constraintBottom.constant = MAX(keyboardFrame.size.height + keyboardHeightOffset, _initialConstant);
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        // This method will automatically animate all views to satisfy new constants.
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Putting everything back to place.
    _constraintBottom.constant = _initialConstant;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}


@end
