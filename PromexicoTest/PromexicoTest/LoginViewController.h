//
//  LoginViewController.h
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PromexicoSynchronizationManager.h"

@interface LoginViewController : UIViewController <PromexicoSynchronizationDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *userNameTextfield;
    IBOutlet UITextField *passwordTextfield;
    
    IBOutlet UIButton *loginButton;
    
    MBProgressHUD *hud;
    PromexicoSynchronizationManager *syncManager;
}

-(IBAction)doLogin:(id)sender;
-(IBAction)dismissTextfields:(id)sender;

@end
