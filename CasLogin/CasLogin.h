//
//  CasLogin.m
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Constants.h"

@interface CasLogin : NSObject<RKObjectLoaderDelegate>

@property (strong, nonatomic) NSString *serviceTicket;

/**
 * Creates a CAS object while defining the URL to the RESTful API on the CAS server.
 *
 * @param (NSString *)	theServer
 *		The URL to the RESTful API on the CAS server.
 *		(e.g. https://example.com/cas/tickets/v1 )
 *
 * @return
 *		Initialized CAS object.
 */
- (CasLogin *) initWithServer: (NSString *)theServer;

/**
 *	Creates CAS object with server, username, and password.
 *
 *	@param (NSString *) theServer
 *		The URL to the RESTful API on the CAS server.
 *		(e.g. https://example.com/cas/tickets/v1 )
 *	@param (NSString *) theUsername
 *		The username to use to generate a ticket-granting ticket.
 *	@param (NSString *) thePassword
 *		The password associated with the username to generate a ticket-granting ticket.
 *
 *	@return
 *		Initialized CAS object.
 */
- (CasLogin *) initWithServer: (NSString *)theServer
withDomain: (NSString *)theDomain
		   withUsername: (NSString *)theUsername 
			andPassword: (NSString *)thePassword;

/**
 *	Generates a ticket-granting ticket using the username and password stored in the CAS object.
 *
 */
- (void) generateTicketGrantingTicket;

/**
 *	Generates a TGT (ticket-granting ticket) for a specified username/password.
 *	
 *	@param (NSString *) theUsername
 *		The username to use to generate a ticket-granting ticket.
 *	@param (NSString *) thePassword
 *		The password associated with the username to generate a ticket-granting ticket.
 *
 */
- (void) generateTicketGrantingTicketForDomain: (NSString *)theDomain Username: (NSString *)theUsername
										   andPassword: (NSString *)thePassword;

/**
 *	Generates a service ticket for the specified service by first generating a ticket-granting ticket
 *	using the username and password stored in the object and then using the TGT to generate the service ticket.
 *
 *	@param (NSString *) service
 *		The service (likely a URL) to generate a ticket for.
 *
 *	@return (NSString *)
 *		The service ticket to pass to the service to verify the login.
 */
//- (NSString *) generateServiceTicketForService: (NSString *)service;

/**
 *	Generates a service ticket for the specified service using a specified ticket-granting ticket;
 *	useful if the program got the TGT from another source, or if it was generated using a username
 *	and password different from what is stored in the instance.
 *
 *	@param (NSString *) service
 *		The service (likely a URL) to generate a ticket for.
 *	@param (NSString *) tgt
 *		The ticket-granting ticket to use to generate the ticket.
 *
 */
- (void) generateServiceTicketForService: (NSString *)service
									   withTGT: (NSString *)tgt;

@end
