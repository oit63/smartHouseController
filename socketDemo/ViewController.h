//
//  ViewController.h
//  socketDemo
//
//  Created by Forrest Alfred on 15/7/30.
//  Copyright © 2015年 Forehead Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface ViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate> {
    GCDAsyncSocket *socket;
    int count;
}

@property(strong)  GCDAsyncSocket *socket;
@property (weak, nonatomic) IBOutlet UITextField *host;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITextView *status;

- (IBAction)connect:(id)sender;
- (IBAction)send:(id)sender;

@end

