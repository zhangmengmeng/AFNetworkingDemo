//
//  QYHTTPReqOpMgr.m
//  AFNetworkingDemo
//
//  Created by qingyun on 15-3-19.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYHTTPReqOpMgr.h"
#import "AFHTTPRequestOperationManager.h"
#import "QYCommon.h"

@interface QYHTTPReqOpMgr ()

@end

@implementation QYHTTPReqOpMgr

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
- (IBAction)getRequest:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"request_get.json"];
//    NSDictionary *parameters = @{@"foo":@"bar"};
    
    NSString *urlStr = @"http://www.baidu.com";
    NSDictionary *parameters = nil;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [manager.responseSerializer.acceptableContentTyself.acceptableContentTypespes setByAddingObject:@"text/html"];
    
    [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        NSLog(@"%@", operation.responseString);
    }];
}

- (IBAction)postURLFormEncodedReq:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"request_post_body_json.json"];
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


- (IBAction)postMultiPartReq:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"upload2server.json"];
    
    NSURL *file1URL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
    NSURL *file2URL = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        [formData appendPartWithFileURL:file1URL name:@"image" fileName:@"xxx1.jpg" mimeType:@"image/jpeg" error:&error];
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        
        [formData appendPartWithFileURL:file2URL name:@"image" fileName:@"xxx2.jpg" mimeType:@"image/jpeg" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


@end
