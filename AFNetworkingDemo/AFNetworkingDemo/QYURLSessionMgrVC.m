//
//  QYURLSessionMgrVC.m
//  AFNetworkingDemo
//
//  Created by qingyun on 15-3-19.
//  Copyright (c) 2015年 hnqingyun.com. All rights reserved.
//

#import "QYURLSessionMgrVC.h"
#import "AFURLSessionManager.h"
#import "QYCommon.h"

#define kSongURLStr     @"http://music.baidu.com/data/music/file?link=http://yinyueshiting.baidu.com/data2/music/138444219/138443297147600128.mp3?xcode=31214765214f667ee5243e86f671058784f52a2bffbeff93&song_id=138443297"

@interface QYURLSessionMgrVC ()

@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgress;

@end

@implementation QYURLSessionMgrVC

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
- (IBAction)downloadMp3:(id)sender {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURL *url = [NSURL URLWithString:kSongURLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSProgress *progress;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:[@"/Users/qingyun/Desktop" stringByAppendingPathComponent:response.suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        
        NSLog(@"Download to :%@", filePath);
    }];
    
    [downloadTask resume];
    
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(__bridge void *)(_downloadProgress)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"completedUnitCount"]) {
        // 更新progress view
        UIProgressView *progressView = (__bridge UIProgressView *)(context);
        int64_t completed = [change[@"new"] longLongValue];
        
        int64_t total = [[object valueForKey:@"totalUnitCount"] longLongValue];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 更新progress view
            progressView.progress = completed / total;
        });

    }
}

- (IBAction)uploadTask:(id)sender {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlStr = [kBaseURLStr stringByAppendingPathComponent:@"upload2server.json"];
    
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    // 通过请求序列化器来创建request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
        NSURL *file2URL = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
        [formData appendPartWithFileURL:fileURL name:@"image" fileName:@"hello.jpg" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileURL:file2URL name:@"image" fileName:@"world.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    
    NSProgress *progress;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        
        NSLog(@"%@", responseObject);
    }];
    
    [uploadTask resume];
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:(__bridge void *)(_uploadProgress)];
}


@end
