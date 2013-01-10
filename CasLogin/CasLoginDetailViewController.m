//
//  CasLoginDetailViewController.m
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "CasLoginDetailViewController.h"

@interface CasLoginDetailViewController ()

@end

@implementation CasLoginDetailViewController{
    NSMutableData *responseData;
}

@synthesize serviceTicket = _serviceTicket;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.toolbarHidden = NO;
    [self loadAttributes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self setAttributesWebView:nil];
    responseData = nil;
}

- (void)loadAttributes;
{
    [self.attributesWebView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?service=%@&ticket=%@",serverURL, serverValidatePath, serviceURL, self.serviceTicket]]]];
    
    // to get the attributes instead of showing
   //(void)[[NSURLConnection alloc] initWithRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@?service=%@&ticket=%@",serverURL, serverValidatePath, serviceURL, self.serviceTicket]]] delegate:self];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    responseData = [[NSMutableData alloc] init];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *data = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *separator = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *stringComponents = [[data componentsSeparatedByCharactersInSet:separator] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
       
    //[self.attributesWebView  loadHTMLString:[stringComponents componentsJoinedByString:@"\n"] baseURL:[[NSURL alloc] initWithString:serverURL]];
}
@end
