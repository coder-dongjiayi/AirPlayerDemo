//
//  ViewController.m
//  AirPlayerDemo
//
//  Created by shimly on 16/6/29.
//  Copyright © 2016年 shimly. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()
@property(nonatomic,strong) AVPlayer        * avPlayer;

@property(nonatomic,strong) AVPlayerItem    * playerItem;

@property(nonatomic,strong) AVPlayerLayer   * playerLayer;

@property(nonatomic,strong) MPVolumeView     * volumeView;

@property(nonatomic,strong) UILabel          * airPlayerLable;

@property(nonatomic,strong) UILabel          * deviceLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor blueColor];
    [self addNotification];
    [self initPlayer];
    
    
}
-(void)addNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    //检测当前是否正在投影
    [center addObserver:self selector:@selector(wirelessRouteActiveNotification:)
                   name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    
    //检测当前是否 有支持airPlayer的无线设备
    [center addObserver:self selector:@selector(wirelessAvailableNotification:)
                   name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
}
-(void)initPlayer
{
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
    self.avPlayer = [AVPlayer playerWithPlayerItem:_playerItem];

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
 
    self.playerLayer.frame = CGRectMake(0, 20, 400, 150);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:_playerLayer];
    
     [self.avPlayer play];
    
    
    self.volumeView = [[MPVolumeView alloc]init];
    [self.volumeView setShowsVolumeSlider:NO];
    [self.volumeView sizeToFit];
    
    //自定义投影图片
   // [self.volumeView setRouteButtonImage:nil forState:UIControlStateNormal];
    
    self.volumeView.center = CGPointMake(self.view.frame.size.width/2-20, 200);
    [self.view addSubview:_volumeView];
    
    self.airPlayerLable = [UILabel new];
    self.airPlayerLable.textColor = [UIColor whiteColor];
    [self.view addSubview:_airPlayerLable];
    
    self.airPlayerLable.frame = CGRectMake(self.view.frame.size.width/2-100, self.volumeView.frame.size.height+self.volumeView.frame.origin.y+100, 200, 60);
    
    self.deviceLabel = [UILabel new];
    self.deviceLabel.textColor = [UIColor whiteColor];
    
     self.deviceLabel.frame = CGRectMake(self.view.frame.size.width/2-100, self.airPlayerLable.frame.size.height+self.airPlayerLable.frame.origin.y+100, 200, 60);
    
    [self.view addSubview:_deviceLabel];
    

    
}

-(void)wirelessRouteActiveNotification:(NSNotification*) notification
{
    MPVolumeView* volumeView = (MPVolumeView*)notification.object;
    
    //当前投影的设备是否 可以 投影
    if(volumeView.isWirelessRouteActive) {
        //正在投影 获取到投影设备的名字
        
        NSString * airPlayerName = [self activeAirplayOutputRouteName];
        
        if (airPlayerName) {
            
            self.airPlayerLable.text = airPlayerName;
        }
        
        
    } else {
        //没有投影或者是 取消了投影
        self.airPlayerLable.text = @"没有投影";
    }
    
    
}

-(void)wirelessAvailableNotification:(NSNotification*) notification
{
    MPVolumeView* volumeView = (MPVolumeView*)notification.object;
    
    if (volumeView.wirelessRoutesAvailable) {
       self.deviceLabel.text = @"有投影设备";
        
    }else{
        self.deviceLabel.text = @"没有投影设备";
    }
}

- (NSString*)activeAirplayOutputRouteName
{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription* currentRoute = audioSession.currentRoute;
    for (AVAudioSessionPortDescription* outputPort in currentRoute.outputs){
        if ([outputPort.portType isEqualToString:AVAudioSessionPortAirPlay])
            return outputPort.portName;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
