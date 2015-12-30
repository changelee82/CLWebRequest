//
//  ViewController.m
//  CLWebRequest
//
//  Created by 李辉 on 15/12/6.
//  Copyright © 2015年 李辉. All rights reserved.
//

#import "ViewController.h"
#import "CLWebRequest.h"
#import "CLWebRequestGroup.h"
#import "CLWebRequestQueue.h"
#import "CLWebRequestAPI.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *weatherField;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *airLabel;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)singleClick:(id)sender
{
    // 登陆参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_num"] = @"13000000001";
    params[@"passwd"] = @"123456";
    params[@"rarea"] = @"010";

    // 过去请求
    CLWebRequest *request = [CLWebRequestAPI requestUserRegisters:params];
    request.requestFinishBlock = ^(id json, CLWebRequestError *error)
    {
        if (error == nil)
        {
            //self.weatherField.text = [NSString stringWithFormat:@"%@", json[0][@"pollutants"][0][@"value"]];
        }
        else
        {
            NSLog(@"错误信息：%d  %@", error.errorCode, error.errorMessage);
        }
    };
    [request startRequest];
}

- (IBAction)groupClick:(id)sender
{
    // 请求天气
    CLWebRequest *requestWeather = [CLWebRequestAPI requestWeather:@"101010100"];
    requestWeather.requestFinishBlock = ^(id json, CLWebRequestError *error)
    {
        if (json != nil)
        {
            self.weatherLabel.text = [NSString stringWithFormat:@"%@", json[@"f"][@"f1"][0][@"fd"]];
        }
    };
    
    // 请求空气质量
    CLWebRequest *requestAirQuality = [CLWebRequestAPI requestAirQuality];
    requestAirQuality.requestFinishBlock = ^(id json, CLWebRequestError *error)
    {
        if (json != nil)
        {
            self.airLabel.text = [NSString stringWithFormat:@"%@ : %@", json[0][@"pollutants"][0][@"pol"],  json[0][@"pollutants"][0][@"value"]];
        }
    };
    
    // 将请求组成并行组
    CLWebRequestGroup *requestGroup = [[CLWebRequestGroup alloc] init];
    requestGroup.requestName = @"请求组";
    [requestGroup addSubRequest:requestWeather];
    [requestGroup addSubRequest:requestAirQuality];
    requestGroup.requestFinishBlock = ^(id json, id error)
    {
        if (json != nil)
        {
            NSLog(@"%@", json);
        }
    };
    
    
    [requestGroup startRequest];
}

- (IBAction)queueClick:(id)sender
{
    // 请求天气
//    CLWebRequest *requestWeather = [CLWebRequestAPI requestPM25:@"beijing"];
//    requestWeather.requestFinishBlock = ^(id json, CLWebRequestError *error)
//    {
//        if (json != nil)
//        {
//            NSLog(@"%@", json);
//        }
//    };
//    
//    [requestWeather startRequest];
}

- (IBAction)unionClick:(id)sender
{
    // 登陆参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone_num"] = @"13000000002";
    params[@"passwd"] = @"123456";

    
    // 请求空气质量
    CLWebRequest *request = [CLWebRequestAPI requestUserLogins:params];
    request.requestFinishBlock = ^(id json, CLWebRequestError *error)
    {
        if (json != nil)
        {
            NSLog(@"%@", json);
        }
    };
    [request startRequest];
}

@end
