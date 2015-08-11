//
//  ViewController.m
//  socketDemo
//
//  Created by Forrest Alfred on 15/7/30.
//  Copyright © 2015年 Forehead Tech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize socket;
@synthesize host;
@synthesize message;
@synthesize port;
@synthesize status;

#pragma mark - View lifecycle

-(void)addText:(NSString *)str
{
    status.text = [status.text stringByAppendingFormat:@"%@\n",str];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    host.text = @"192.168.2.110";
    port.text = @"54321";
    message.delegate = self;
    message.clearsOnBeginEditing = YES;
//    status.textAlignment = UITextAlignmentRight;
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)connect:(id)sender {
    status.text = @"";
    socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //socket.delegate = self;
    [self tapToView:nil];
    NSError *err = nil;
    if(![socket connectToHost:host.text onPort:[port.text intValue] error:&err])
        {
            [self addText:err.description];
        }else {
            NSLog(@"ok");
            [self addText:@"打开端口"];
        }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self addText:[NSString stringWithFormat:@"连接到:%@",host]];
    [socket readDataWithTimeout:-1 tag:0];
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
   
}
- (IBAction)send:(id)sender
{
    [message resignFirstResponder];
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self addText:[NSString stringWithFormat:@"%@:%@",sock.connectedHost,newMessage]];
    //[socket readDataWithTimeout:-1 tag:0];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    count = 1;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=247;
    frame.size.height +=247;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];

}
- (IBAction)textFieldDoneEditing:(UITextField *)sender
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=247;
    frame.size. height -=247;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [self sendMessage];
    [sender resignFirstResponder];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapToView:(id)sender {
    [message resignFirstResponder];
    [host resignFirstResponder];
    [port resignFirstResponder];
    [message resignFirstResponder];
}

- (void)sendMessage
{
    if (count)
    {
        [socket writeData:[message.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        [self addText:[NSString stringWithFormat:@"我:%@",message.text]];
        [socket readDataWithTimeout:-1 tag:0];
        [message resignFirstResponder];
    }
    count = 0;
    message.text = @"";
}

@end
