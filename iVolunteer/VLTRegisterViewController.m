//
//  RegisterViewController.m
//  iVolunteer
//
//  Created by Marcus Vinicius Kuquert on 3/8/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "VLTRegisterViewController.h"
#import "MBProgressHUD.h"

@interface VLTRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@end

@implementation VLTRegisterViewController{
    CGFloat _initialConstant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Start listening keyboar notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Change placeholder color
    UIColor *color = [UIColor lightTextColor];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full name" attributes:@{NSForegroundColorAttributeName: color}];
    _usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"E-mail" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _confirmPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm password" attributes:@{NSForegroundColorAttributeName: color}];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bgf" ofType:@"gif"];
        NSData *gif = [NSData dataWithContentsOfFile:filePath];
        [_webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [self.view sendSubviewToBack:_webView];
    }
    else
        [_webView removeFromSuperview];
}

- (IBAction)confirmButton:(id)sender {
    
    if ([_passwordField.text isEqualToString:_confirmPasswordField.text]) {
        PFUser *newUser = [PFUser user];
        newUser.username = _usernameField.text;
        newUser.email = _emailField.text;
        newUser.password = _passwordField.text;
        newUser[@"name"] = _nameField.text;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Success on register" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [self performSegueWithIdentifier:@"gotoMap" sender:nil];
                [hud hide:YES];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:[error.userInfo valueForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [hud hide:YES];
            }
        }];
    }
    
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password does not match" message:@"Check your password and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    
    // Getting the keyboard frame and animation duration.
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (!_initialConstant) {
        _initialConstant = _constraintBottom.constant;
    }
    
    // If screen can fit everything, leave the constant untouched.
    _constraintBottom.constant = MAX(keyboardFrame.size.height, _initialConstant);
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

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
