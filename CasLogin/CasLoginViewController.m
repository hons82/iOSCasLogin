//
//  CasLoginViewController.m
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "CasLoginViewController.h"

@interface CasLoginViewController ()

@end

@implementation CasLoginViewController{
    CasLogin *loginModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    loginModel = [[CasLogin alloc] initWithServer:[NSString stringWithFormat:@"%@%@",serverURL,serverRestPath]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:@"loginStatusChanged"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setStatus:nil];
    loginModel=nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAttributes"]) {
                
        [[segue destinationViewController] setServiceTicket:[loginModel serviceTicket]];
    }
}

- (IBAction)login:(id)sender {
    [loginModel generateTicketGrantingTicketForDomain:[self.domain text] Username:[self.username text] andPassword:[self.password text]];
}

#pragma mark - Notification Callback

- (void) loginStatusChanged:(NSNotification *)notification;
{
    NSString *status = (notification.userInfo)[@"status"];
    NSString *detail = (notification.userInfo)[@"detail"];
    
    [self.status setText:detail];
    
    if ([status isEqualToString:@"200"]) {
        [self performSegueWithIdentifier:@"showAttributes" sender:self];
    }
}

@end
