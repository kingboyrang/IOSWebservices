//
//  ViewController.h
//  IosWebService
//
//  Created by rang on 13-6-29.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
@interface ViewController : BasicViewController

- (IBAction)SyncClick:(id)sender;
- (IBAction)asyncDelegatedClick:(id)sender;
- (IBAction)asyncBlockClick:(id)sender;
- (IBAction)queueClick:(id)sender;

@end
