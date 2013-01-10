//
//  CasLoginDetailViewController.h
//  CasLogin
//
//  Created by Hannes Tribus on 1/8/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface CasLoginDetailViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *attributesWebView;

@property (strong, nonatomic) NSString *serviceTicket;

@end
