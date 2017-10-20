//
//  ViewController.h
//  AEPassword
//
//  Created by Alonso on 2017/10/12.
//  Copyright © 2017年 Alonso. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *showtextview;
@property (weak) IBOutlet NSButton *pswBtn;
- (IBAction)Btn:(NSButton *)sender;
@property (weak) IBOutlet NSTextField *pswLabel;

@end

