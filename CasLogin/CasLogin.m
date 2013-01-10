//
//  CasLogin.m
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "CasLogin.h"

@interface CasLogin ()
/**
 *	The address to the RESTful API on the CAS server.
 */
@property (nonatomic, strong) NSString *server;
/**
 *	The domain to use to generate a ticket-granting ticket.
 */
@property (nonatomic, strong) NSString *domain;
/**
 *	The username to use to generate a ticket-granting ticket.
 */
@property (nonatomic, strong) NSString *username;
/**
 *	The password associated with the username to generate a ticket-granting ticket.
 */
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RKObjectManager* sharedManager;

@end

@implementation CasLogin

@synthesize serviceTicket = _serviceTicket;

- (CasLogin *) initWithServer: (NSString *)theServer
{
	return [self initWithServer:theServer withDomain:nil withUsername:nil andPassword:nil];
}


- (CasLogin *) initWithServer: (NSString *)theServer withDomain: (NSString *)theDomain withUsername: (NSString *)theUsername andPassword: (NSString *)thePassword
{
	self = [super init];
	
	if (self) {
		self.server		=	theServer;
        self.domain     =   theDomain;
		self.username	=	theUsername;
		self.password	=	thePassword;
	}
	
	return self;
}

- (void) generateTicketGrantingTicket
{
	[self generateTicketGrantingTicketForDomain:self.domain Username:self.username andPassword:self.password];
}


- (void) generateTicketGrantingTicketForDomain: (NSString *)theDomain Username: (NSString *)theUsername andPassword: (NSString *)thePassword
{
    // TODO check if server!=nil
	self.sharedManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.server]];
    // TODO not for production
	
    [[self.sharedManager client] setDisableCertificateValidation:YES];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[theDomain, theUsername, thePassword] forKeys:@[@"domain", @"username", @"password"]];
	
	[[self.sharedManager client] post:@"/" params:params delegate:self];
}


/*
- (NSString *) generateServiceTicketForService: (NSString *)service
{
	return [self generateServiceTicketForService:service withTGT:[self generateTicketGrantingTicket]];
}
 */

- (void) generateServiceTicketForService: (NSString *)service withTGT: (NSString *)tgt
{
	//Verify the existance of a ticket-granting ticket
	if (!tgt) {
		NSLog(@"Invalid ticket-granting ticket.");
		return;
	}
    
    // TODO check if server!=nil
	self.sharedManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.server]];
    // TODO not for production
	[[self.sharedManager client] setDisableCertificateValidation:YES];
    
	 NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[service] forKeys:@[@"service"]];
	[[self.sharedManager client] post:[NSString stringWithFormat:@"/%@",tgt] params:params delegate:self];
	
	/*switch ([response statusCode]) {
		case 200:
			NSLog(@"Success.");
			return [request responseString];
			break;
		case 400:
			NSLog(@"Invalid credentials.");
			break;
		case 0:
			NSLog(@"Connection failed.");
			NSLog(@"%@", [request error]);
			break;
		default:
			NSLog(@"Invalid response (%d).", [request responseStatusCode]);
			break;
	}*/
}

#pragma mark - RESTkit callbacks

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error{
    //TODO
    NSLog(@"\nError :\n%@\n",error.description);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSString *detail = nil;
	switch ([response statusCode]) {
		case 201:
        {
			detail =  @"TGT Created";
			
			//The ticket granting ticket is the last part of the URL via
			//https://wiki.jasig.org/display/CASUM/RESTful+API#RESTfulAPI-SuccessfulResponse
			//(e.g. http://www.whatever.com/cas/v1/tickets/{TGT id})
			NSString *location	=	[[response allHeaderFields] objectForKey:@"Location"];
			NSString *tgt		=	[[location componentsSeparatedByString:@"/"] lastObject];
            
			[self generateServiceTicketForService:serviceURL withTGT:tgt];
		}
            break;
        case 200:
        {
            [self setServiceTicket:[response bodyAsString]];
            detail = @"Logged In";
        }
            break;
		case 400:
			detail = @"invalid Credentials";
			break;
		case 0:
			detail = @"Connection failed.";
			NSLog(@"%@", [response failureErrorDescription]);
			break;
		default:
			detail = @"Invalid response (%d).", [response statusCode];
			break;
	}
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginStatusChanged" object:self userInfo:@{@"status": [NSString stringWithFormat:@"%i",[response statusCode]], @"detail" : detail!=nil?detail:@""}];
}


@end
