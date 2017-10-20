//
//  ViewController.m
//  AEPassword
//
//  Created by Alonso on 2017/10/12.
//  Copyright © 2017年 Alonso. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.showtextview setHidden:YES];
    [self getWeb:@"https://172.31.63.232/AE"];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

-(void)getWeb:(NSString *)urlstr{
    [self.pswBtn setEnabled:NO];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:2];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求出错:%@", error);
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.pswBtn.image = [NSImage imageNamed:@"fail"];
                [self.pswBtn setEnabled:YES];
                [self.showtextview setHidden:NO];
                [self.pswLabel setHidden:YES];
                self.showtextview.string = error.localizedDescription;
            });
            return;
        }
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([dataString containsString:@"It works!"]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.pswBtn.image = [NSImage imageNamed:@"pass"];
                [self.pswBtn setEnabled:YES];
                [self.showtextview setHidden:YES];
                [self.pswLabel setHidden:NO];
                [self password];
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.pswBtn.image = [NSImage imageNamed:@"default"];
                [self.showtextview setHidden:NO];
                self.showtextview.string = @"Network password error";
                [self.pswBtn setEnabled:YES];
                [self.pswLabel setHidden:YES];
            });
        }
    }];
    [dataTask resume];
}

-(void)password
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    long weekday = (theComponents.weekday == 1) ? 7 : theComponents.weekday-1;
    long psw = labs((theComponents.year - theComponents.day*100 - theComponents.month)* weekday);
    //密码规则 |年份-日期月|*周几，ex：|2017-2010|*5=35转16进制23
    NSString *finalpsw = [self int64ToHex:psw];
    self.pswLabel.stringValue = finalpsw;
    //NSLog(@"%@",finalpsw);
}

- (NSString *)int64ToHex:(int64_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    int64_t ttmpig;
    for (int i = 0; i<19; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig) {
            case 10:
                nLetterValue =@"a";break;
            case 11:
                nLetterValue =@"b";break;
            case 12:
                nLetterValue =@"c";break;
            case 13:
                nLetterValue =@"d";break;
            case 14:
                nLetterValue =@"e";break;
            case 15:
                nLetterValue =@"f";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%lld",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

- (IBAction)Btn:(NSButton *)sender {
    NSMutableDictionary *InfoConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
    NSString *backupURL = [InfoConfig objectForKey:@"Backup"];
    [self getWeb:backupURL];
}
@end
