//
//  ViewController.m
//  ios二维码
//
//  Created by 方世沛 on 2017/4/11.
//  Copyright © 2017年 方世沛. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeView.h"
@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    UILabel *lab;
    QRCodeView *qrCodeView;
}
@property(nonatomic,strong)AVCaptureDevice *device;
@property(nonatomic,strong)AVCaptureDeviceInput *input;
@property(nonatomic,strong)AVCaptureMetadataOutput *output;
@property(nonatomic,strong)AVCaptureSession *session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;


@property(nonatomic,strong)CALayer *containerLayer;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
    NSMutableDictionary *dictText = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
                                     [UIFont systemFontOfSize:16],NSFontAttributeName,
                                     nil];
    [self.navigationController.navigationBar setTitleTextAttributes:dictText];
    self.navigationItem.title=@"扫描二维码";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    qrCodeView = [[QRCodeView alloc] initWithFrame:self.view.frame];
    self.view=qrCodeView;
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor whiteColor];
    [self.view addSubview:lab];
    
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"未能获取到相机授权，是否前往打开?"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"前往", nil];
        [alert show];
        //无权限
        
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 50)];
    [button setTitle:@"扫    码" forState:UIWindowLevelNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self
               action:@selector(scanf)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }
            break;
            
        default:
            return;
            break;
    }
}

- (AVCaptureDevice *)device {
    if (_device==nil) {
        _device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input {
    if (_input==nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
    }
    return _input;
}

- (AVCaptureSession *)session {
    if (_session==nil) {
        _session=[[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer==nil) {
        _previewLayer=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
    return _previewLayer;
}

- (AVCaptureMetadataOutput *)output {
    if (_output==nil) {
        _output=[[AVCaptureMetadataOutput alloc] init];
        CGRect containRect = CGRectMake(50, (SCREEN_HEIGHT-SCREEN_WIDTH+100)/2, SCREEN_WIDTH-100, SCREEN_WIDTH-100);
        CGFloat x = containRect.origin.y / SCREEN_HEIGHT;
        CGFloat y = containRect.origin.x / SCREEN_WIDTH;
        CGFloat width = containRect.size.height / SCREEN_HEIGHT;
        CGFloat height = containRect.size.width / SCREEN_WIDTH;
        _output.rectOfInterest = CGRectMake(x, y, width, height);
    }
    return _output;
}

- (CALayer *)containerLayer {
    if (_containerLayer == nil) {
        _containerLayer = [[CALayer alloc] init];
    }
    return _containerLayer;
}

- (void)scanf {
    if (![self.session canAddInput:self.input]) {
        return;
    }
    [self.session addInput:self.input];
    
    if (![self.session canAddOutput:self.output]) {
        return;
    }
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=self.output.availableMetadataObjectTypes;
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame=self.view.bounds;
    [self.view.layer addSublayer:self.containerLayer];
    self.containerLayer.frame=self.view.bounds;
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
    if (object==nil) {
        return;
    }
    lab.text=object.stringValue;
    
    //显示聚焦小框框
//    [self clearLayers];
//    AVMetadataMachineReadableCodeObject *obj = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:object];;
//    [self drawLine:obj];
}

- (void)clearLayers {
    if (self.containerLayer.sublayers) {
        for (CALayer *subLayer in self.containerLayer.sublayers) {
            [subLayer removeFromSuperlayer];
        }
    }
}

- (void)drawLine:(AVMetadataMachineReadableCodeObject *)objc {
    NSArray *array = objc.corners;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth=2;
    layer.strokeColor=[UIColor greenColor].CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint point = CGPointZero;
    int index = 0;
    CFDictionaryRef dict = (__bridge CFDictionaryRef)(array[index++]);
    CGPointMakeWithDictionaryRepresentation(dict, &point);
    [path moveToPoint:point];
    for (int i=1; i<array.count; i++) {
        CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)array[i], &point);
        [path addLineToPoint:point];
    }
    [path closePath];
    layer.path=path.CGPath;
    [self.containerLayer addSublayer:layer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
    }
}


@end
