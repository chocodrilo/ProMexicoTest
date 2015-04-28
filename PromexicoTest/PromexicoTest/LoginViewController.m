//
//  LoginViewController.m
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "LoginViewController.h"
#import "SurveyViewController.h"

@implementation LoginViewController

#pragma mark
#pragma mark  Initialization override methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        syncManager = [[PromexicoSynchronizationManager alloc] initWithDelegate:self];
    }
    return self;
}

#pragma mark
#pragma mark  UIViewController override methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initializeForm];
}

#pragma mark
#pragma mark  User interaction methods

-(IBAction)doLogin:(id)sender
{
    if([userNameTextfield.text isEqualToString:@""] && [passwordTextfield.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:NSLocalizedString(@"ALERT_MESSAGE_EMPTY_CREDENTIALS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"HUD_TITLE_LOADING", nil);
        [hud show:YES];
        [syncManager loadOffices];
    }
}

-(IBAction)dismissTextfields:(id)sender
{
    [userNameTextfield resignFirstResponder];
    [passwordTextfield resignFirstResponder];
}

#pragma mark
#pragma mark Private methods

-(void)initializeForm
{
    userNameTextfield.text = @"";
    passwordTextfield.text = @"";
}

-(void)setupLabels
{
    userNameTextfield.placeholder = NSLocalizedString(@"TEXTFIELD_PLACEHOLDER_USERNAME", nil);
    passwordTextfield.placeholder = NSLocalizedString(@"TEXTFIELD_PLACEHOLDER_PASSWORD", nil);
    [loginButton setTitle:NSLocalizedString(@"BUTTON_TITLE_LOGIN", nil) forState:UIControlStateNormal];
}

#pragma mark
#pragma mark  UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == userNameTextfield)
    {
        [passwordTextfield becomeFirstResponder];
    }
    else
    {
        [self doLogin:nil];
    }
    return YES;
}

#pragma mark
#pragma mark  PromexicoSynchronizationDelegate methods

-(void)finishedLoadingOffices
{
    [hud hide:YES];
    SurveyViewController *surveyController = [[SurveyViewController alloc] initWithNibName:@"SurveyViewController" bundle:nil];
    [self.navigationController pushViewController:surveyController animated:YES];
}

-(void)failedLoadingOfficesWithError:(NSError *)error
{
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
    [alert show];
}

@end
