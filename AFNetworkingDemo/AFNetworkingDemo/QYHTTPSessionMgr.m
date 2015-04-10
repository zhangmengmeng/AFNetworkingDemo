//
//  QYHTTPSessionMgr.m
//  AFNetworkingDemo
//
//  Created by qingyun on 15-3-19.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYHTTPSessionMgr.h"
#import "AFHTTPSessionManager.h"
#import "QYCommon.h"

@interface QYHTTPSessionMgr ()

@end

@implementation QYHTTPSessionMgr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getRequest:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"request_get.json"];
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    [manager GET:urlStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)postRequest:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"request_post_body_http.json"];
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    [manager POST:urlStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)postWithMultiPartReq:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"upload2server.json"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
        [formData appendPartWithFileURL:fileURL name:@"image" fileName:@"prettyGirl.jpg" mimeType:@"image/jpeg" error:nil];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
