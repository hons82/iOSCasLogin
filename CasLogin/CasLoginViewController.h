//
//  CasLoginViewController.h
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "CasLogin.h"

@interface CasLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *domain;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *status;

- (void) loginStatusChanged:(NSNotification *)notification;

@end
