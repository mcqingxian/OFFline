//
//  GameView.m
//  SkyFighting
//
//  Created by 孙昕 on 15/12/27.
//  Copyright © 2015年 孙昕. All rights reserved.
//

#import "GameView.h"
#import "RaderView.h"
#import "Header.h"
#import "EnemyNode.h"
@import GLKit;
@import AVFoundation;
@import CoreMotion;
@import AudioToolbox;
@import OpenGLES;
@import ImageIO;
#define PLAYFLAG (0x1<<0)
#define ENEMYFLAG (0x1<<1)
#define BULLETFLAG (0x1<<2)
#define BOMBFLAG (0x1<<3)
#define LASERFLAG (0x1<<4)
#define ENEMYBULLETFLAG (0x1<<5)
CGFloat const gestureMinimumTranslation = 20.0 ;
typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;
@interface GameView()<SCNPhysicsContactDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    SCNNode *camera;
    NSTimeInterval currentTime;
    CMAttitude *atti;
    SCNNode *ship;
    NSTimer *timer;
    NSTimer *timerDispaly;
    NSMutableArray *arrEnemy;
    NSMutableArray *arrPan;
    CADisplayLink *link;
    CAShapeLayer *layerPan;
    UIBezierPath *panPath;
    CameraMoveDirection direction;
    NSMutableArray *arrDirection;
    RaderView *viewRader;
    SCNView *viewScene;
    NSInteger enemyCount;
    NSInteger enemyOriginCount;
    float gapDisplay;
    float gapFire;
    NSInteger bloodPlayer;//玩家血量
    NSInteger bloodOriginPlayer;
    NSInteger bloodEnemy;//敌人血量
    UILabel *lbBlood;//血量标签
    NSInteger bulletCount;//子弹数
    NSInteger BombCount;
    NSInteger LaserCount;
    NSInteger protectCount;
    UILabel *lbBullet;//子弹标签

    NSLayoutConstraint * topContraint;
    NSLayoutConstraint * leftContraint;
    NSLayoutConstraint * rightContraint;
    NSLayoutConstraint * bottomContraint;
    CADisplayLink *linkUpdate;
    NSMutableArray *arrEnemyBullet;
    BOOL bProtect;
    AVCaptureMetadataOutput *output;
    BOOL bFace;
    CMAttitude *initialAttitude;
    SCNAudioSource *audioEnemy;
}
@property (nonatomic, strong)       AVCaptureSession            * session;
@property (nonatomic, strong)       AVCaptureDeviceInput        * videoInput;
@property (nonatomic, strong)       AVCaptureStillImageOutput   * stillImageOutput;
@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  * previewLayer;
@property (nonatomic, strong)       UIBarButtonItem             * toggleButton;
@property (nonatomic, strong)       UIButton                    * shutterButton;
@property (nonatomic, strong)       UIView                      * cameraShowView;
@property (nonatomic,strong) CMMotionManager* manager;
@end
@implementation GameView

#pragma  mark - 初始化设置
-(void)setup
{
    [self initUI];
    [self initialSession];
    bProtect=NO;
    _manager=[[CMMotionManager alloc]init];
    if ([_manager isAccelerometerAvailable]) {
        [_manager setDeviceMotionUpdateInterval:1/60.0f];
        currentTime= [[NSDate date] timeIntervalSince1970]*1000;
        initialAttitude = _manager.deviceMotion.attitude;
        __weak GameView *weakSelf=self;
        if (_manager.deviceMotionAvailable) {
            [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                          withHandler:^(CMDeviceMotion *data, NSError *error) {
                                              [weakSelf updateMotion:data];
                                          }];
        }
    }
    arrEnemy=[[NSMutableArray alloc] initWithCapacity:30];
    arrPan=[[NSMutableArray alloc] initWithCapacity:30];
    arrDirection=[[NSMutableArray alloc] initWithCapacity:30];
    arrEnemyBullet=[[NSMutableArray alloc] initWithCapacity:30];
    layerPan=[CAShapeLayer layer];
    layerPan.lineWidth =  8.0f;
    layerPan.lineCap = kCALineCapRound;
    layerPan.lineJoin = kCALineJoinRound;
    layerPan.fillColor=[UIColor clearColor].CGColor;
    [self.layer addSublayer:layerPan];
    [self setUpCameraLayer];
    if (self.session) {
        [self.session startRunning];
    }
    audioEnemy=[SCNAudioSource audioSourceNamed:@"plane.wav"];
    audioEnemy.positional = YES;
    audioEnemy.loops = YES;
    [audioEnemy load];
}

#pragma mark - 陀螺仪数据更新
-(void)updateMotion:(CMDeviceMotion *)data
{
    if(initialAttitude==nil)
    {
        initialAttitude = _manager.deviceMotion.attitude;
        [self initScene];
        return;
    }
    [data.attitude multiplyByInverseOfAttitude:initialAttitude];
    atti=data.attitude;
    if(data.attitude.roll<-M_PI_2 || data.attitude.roll>M_PI_2)
    {
        [camera runAction:[SCNAction rotateToX: -data.attitude.pitch y:data.attitude.roll z:data.attitude.yaw duration:0]];
    }
    else
    {
        [camera runAction:[SCNAction rotateToX: data.attitude.pitch y:data.attitude.roll z:data.attitude.yaw duration:0]];
    }
    
    [viewRader setRorate:data.attitude.roll];
}

#pragma mark - 场景UI初始化
-(void)initUI
{
    //游戏场景
    viewScene=[[SCNView alloc] initWithFrame:self.bounds];
    viewScene.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:viewScene];
    //雷达
    viewRader=[[RaderView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    viewRader.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:viewRader];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[viewRader(==100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewRader)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[viewRader(==100)]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(viewRader)]];
    
    //玩家血量
    lbBlood=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 10)];
    [self addSubview:lbBlood];
    lbBlood.backgroundColor= MyBlueColor;
    lbBlood.layer.masksToBounds=YES;
    lbBlood.layer.cornerRadius=5;
    
    //子弹图片
    UIImageView *img=[[UIImageView alloc] init];
    img.image=[UIImage imageNamed:@"bullet"];
    img.contentMode=UIViewContentModeScaleAspectFit;
    img.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:img];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[img(==30)]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(img)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[img(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(img)]];
    
    //子弹标签
    lbBullet=[[UILabel alloc] init];
    lbBullet.translatesAutoresizingMaskIntoConstraints=NO;
    lbBullet.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lbBullet];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lbBullet(==50)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbBullet)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[lbBullet(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lbBullet)]];
    
    //十字瞄准器
    UILabel *lb=[[UILabel alloc] init];//上
    lb.backgroundColor=[UIColor darkGrayColor];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:lb];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    topContraint= [NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15];
    [self addConstraint:topContraint];
    
    lb=[[UILabel alloc] init];//下
    lb.backgroundColor=[UIColor darkGrayColor];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:lb];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    bottomContraint= [NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:15];
    [self addConstraint:bottomContraint];
    
    lb=[[UILabel alloc] init];//左
    lb.backgroundColor=[UIColor darkGrayColor];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:lb];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20]];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    leftContraint= [NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-15];
    [self addConstraint:leftContraint];
    
    lb=[[UILabel alloc] init];//右
    lb.backgroundColor=[UIColor darkGrayColor];
    lb.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:lb];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:20]];
    [lb addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    rightContraint= [NSLayoutConstraint constraintWithItem:lb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:15];
    [self addConstraint:rightContraint];
    
}

#pragma mark - 初始化
-(instancetype)init
{
    if(self=[super init])
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

#pragma mark - 相机
- (void)initialSession
{
    self.session = [[AVCaptureSession alloc] init];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:nil];
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    output = [[AVCaptureMetadataOutput alloc] init];
    if([self.session canAddOutput:output])
    {
        [self.session addOutput:output];
    }
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    [output setMetadataObjectsDelegate:self queue:queue];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position)
        {
            return device;
        }
    }
    return nil;
}


- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

//相机图层
- (void) setUpCameraLayer
{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        UIView * view = self;
        CALayer * viewLayer = [view layer];
        [viewLayer setMasksToBounds:YES];
        [self.previewLayer setFrame:[UIScreen mainScreen].bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:self.previewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        
    }
}

#pragma mark - 更新雷达
-(void)updateRader
{
    for(EnemyNode *node in arrEnemy)
    {
        float len=sqrt(pow(node.position.x, 2)+pow(node.position.z, 2));
        [viewRader updateSpot:node.raderID Len:len];
    }
}

//初始化游戏场景
-(void)initScene
{
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];//飞机模型
    scene.physicsWorld.gravity=SCNVector3Make(0, -20, 0);
    scene.physicsWorld.contactDelegate=self;
    camera = [SCNNode node];
    camera.camera=[SCNCamera camera];
    camera.camera.automaticallyAdjustsZRange=YES;
    camera.camera.zFar=100;
    camera.camera.xFov=45;
    camera.camera.yFov=45;
    [scene.rootNode addChildNode:camera];
    camera.position = SCNVector3Make(0, 0, 0);
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 0, 0);
    lightNode.light.color=[UIColor whiteColor];
    [scene.rootNode addChildNode:lightNode];
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    ship.hidden=YES;
    SCNView *scnView = (SCNView *)viewScene;
    scnView.scene = scene;
    scnView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
    
}

#pragma mark - 点击屏幕手势,发射子弹
- (void)handleTap:(UIGestureRecognizer*)gestureRecognize
{
    if(bulletCount==0)
    {
        return;
    }
    bulletCount--;
    lbBullet.text=[NSString stringWithFormat:@"%ld",bulletCount];
    [self animateTap];
    SCNView *scnView = viewScene;
    [viewScene.scene.rootNode runAction:[SCNAction playAudioSource:[SCNAudioSource audioSourceNamed:@"bullet.wav"] waitForCompletion:NO]];
    SCNBox *box=[SCNBox boxWithWidth:0.1 height:0.1 length:0.2 chamferRadius:5];
    box.firstMaterial.diffuse.contents= MyBlueColor;
    SCNNode *node=[SCNNode nodeWithGeometry:box];
    node.name=[NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]*1000];
    node.physicsBody=[SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithNode:node options:nil]];
    node.physicsBody.categoryBitMask=BULLETFLAG;
    node.physicsBody.collisionBitMask=0x0;
    node.physicsBody.contactTestBitMask=ENEMYFLAG;
    node.position=SCNVector3Make(0, -0.5, 0);
    node.physicsBody.affectedByGravity=NO;
    [scnView.scene.rootNode addChildNode:node];
    float y,temp;
    if(atti.roll<-M_PI_2 || atti.roll>M_PI_2)
    {
        y=200*sin(-atti.pitch);
        temp=200*cos(-atti.pitch);
    }
    else
    {
        y=200*sin(atti.pitch);
        temp=200*cos(atti.pitch);
    }
    float x=-temp*sin(atti.roll);
    float z=-temp*cos(atti.roll);
    GLKVector3 vec=GLKVector3Make(x, y, z);
    GLKMatrix4 mat=GLKMatrix4MakeRotation(atti.yaw, 0, 0, 1);
    vec=GLKMatrix4MultiplyVector3(mat, vec);
    [node runAction:[SCNAction sequence:@[[SCNAction rotateToX: atti.pitch y:atti.roll z:atti.yaw duration:0],[SCNAction moveTo:SCNVector3Make(vec.x,vec.y, vec.z) duration:6],[SCNAction removeFromParentNode]]]];
}

-(void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact
{
    SCNNode *node1,*node2;
    if(contact.nodeA.physicsBody.categoryBitMask<contact.nodeB.physicsBody.categoryBitMask)
    {
        node1=contact.nodeA;
        node2=contact.nodeB;
    }
    else
    {
        node1=contact.nodeB;
        node2=contact.nodeA;
    }
    if(node1.physicsBody.categoryBitMask==PLAYFLAG && node2.physicsBody.categoryBitMask==ENEMYFLAG)
    {
        NSLog(@"1");
    }
    else if(node1.physicsBody.categoryBitMask==PLAYFLAG && node2.physicsBody.categoryBitMask==ENEMYBULLETFLAG)
    {
        NSLog(@"2");
    }
    else if(node1.physicsBody.categoryBitMask==ENEMYFLAG && node2.physicsBody.categoryBitMask==BOMBFLAG)
    {
        SCNVector3 vec=contact.contactPoint;
        [node2 removeAllActions];
        [node2 runAction:[SCNAction removeFromParentNode]];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:30];
        for(EnemyNode *node in arrEnemy)
        {
            float len=sqrtf(pow(node.position.x-vec.x, 2)+pow(node.position.y-vec.y, 2)+pow(node.position.z-vec.z, 2));
            if(len<=20)
            {
                node.blood-=100;
                if(node.blood<=0)
                {
                    [arr addObject:node];
                    [viewRader removeSpot:node.raderID];
                    [node fire];
                    node.physicsBody.categoryBitMask=0;
                    [node removeAllActions];
                    node.physicsBody.affectedByGravity=YES;
                    [node runAction:[SCNAction sequence:@[[SCNAction waitForDuration:6],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
                        [node removeAllAudioPlayers];
                    }],[SCNAction removeFromParentNode]]]];
                }
            }
        }
        [arrEnemy removeObjectsInArray:arr];
    }
    else if(node1.physicsBody.categoryBitMask==ENEMYFLAG && node2.physicsBody.categoryBitMask==BULLETFLAG)
    {
        [node2 removeAllActions];
        [node2 runAction:[SCNAction removeFromParentNode]];
        EnemyNode *node=(EnemyNode*)node1;
        node.blood-=20;
        if(node.blood<=0)
        {
            [arrEnemy removeObject:node];
            [viewRader removeSpot:node.raderID];
            [node fire];
            node.physicsBody.categoryBitMask=0;
            [node removeAllActions];
            node.physicsBody.affectedByGravity=YES;
            [node runAction:[SCNAction sequence:@[[SCNAction waitForDuration:6],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
                [node removeAllAudioPlayers];
            }],[SCNAction removeFromParentNode]]]];
        }
    }
    else if(node1.physicsBody.categoryBitMask==ENEMYFLAG && node2.physicsBody.categoryBitMask==LASERFLAG)
    {
        EnemyNode *node=(EnemyNode*)node1;
        node.blood-=100;
        if(node.blood<=0)
        {
            [arrEnemy removeObject:node];
            [viewRader removeSpot:node.raderID];
            [node fire];
            node.physicsBody.categoryBitMask=0;
            [node removeAllActions];
            node.physicsBody.affectedByGravity=YES;
            [node runAction:[SCNAction sequence:@[[SCNAction waitForDuration:6],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
                [node removeAllAudioPlayers];
            }],[SCNAction removeFromParentNode]]]];
        }
    }
}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateRader) userInfo:nil repeats:YES];
    timerDispaly=[NSTimer scheduledTimerWithTimeInterval:gapDisplay target:self selector:@selector(generateEnemy) userInfo:nil repeats:YES];
    linkUpdate=[CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    linkUpdate.frameInterval=2;
    [linkUpdate addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)update:(CADisplayLink*)disLink
{
    if(enemyCount==0 && arrEnemy.count==0)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(GameViewFinish:KillCount:)])
        {
            [_delegate GameViewFinish:YES KillCount:enemyOriginCount-enemyCount];
        }
        [self stop];
        return;
    }
    else if(bloodPlayer<=0)
    {
        if(_delegate && [_delegate respondsToSelector:@selector(GameViewFinish:KillCount:)])
        {
            [_delegate GameViewFinish:NO KillCount:enemyOriginCount-enemyCount];
        }
        [self stop];
        return;
    }
    NSMutableArray *arr=[[NSMutableArray alloc] initWithCapacity:30];
    for(EnemyNode *node in arrEnemy)
    {
        float len=sqrtf(pow(node.position.x, 2)+pow(node.position.y, 2)+pow(node.position.z, 2));
        if(!bProtect && len<=10)
        {
            bloodPlayer-=node.blood;
            [viewRader removeSpot:node.raderID];
            [node fire];
            [arr addObject:node];
            node.physicsBody.categoryBitMask=0;
            [node removeAllActions];
            node.physicsBody.affectedByGravity=YES;
            [node runAction:[SCNAction sequence:@[[SCNAction waitForDuration:6],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
                [node removeAllAudioPlayers];
            }],[SCNAction removeFromParentNode]]]];
            [self setPlayerBlood:bloodPlayer];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            UIView *view=[[UIView alloc] initWithFrame:viewScene.bounds];
            view.backgroundColor=[UIColor clearColor];
            [viewScene addSubview:view];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                view.backgroundColor=COL(177, 17, 22, 0.7);
            }  completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    view.backgroundColor=[UIColor clearColor];
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }];
        }
        else if(bProtect && len<=30)
        {
            [viewRader removeSpot:node.raderID];
            [node fire];
            [arr addObject:node];
            node.physicsBody.categoryBitMask=0;
            [node removeAllActions];
            node.physicsBody.affectedByGravity=YES;
            [node runAction:[SCNAction sequence:@[[SCNAction waitForDuration:6],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
                [node removeAllAudioPlayers];
            }],[SCNAction removeFromParentNode]]]];
        }
    }
    [arrEnemy removeObjectsInArray:arr];
    [arr removeAllObjects];
    for(SCNNode *node in arrEnemyBullet)
    {
        float len=sqrtf(pow(node.position.x, 2)+pow(node.position.y, 2)+pow(node.position.z, 2));
        if(len<=2)
        {
            bloodPlayer-=40;
            [arr addObject:node];
            [node removeAllActions];
            [node runAction:[SCNAction removeFromParentNode]];
            [self setPlayerBlood:bloodPlayer];
            UIView *view=[[UIView alloc] initWithFrame:viewScene.bounds];
            view.backgroundColor=[UIColor clearColor];
            [viewScene addSubview:view];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                view.backgroundColor=COL(177, 17, 22, 0.7);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    view.backgroundColor=[UIColor clearColor];
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            }];
        }
        else if(bProtect && len<=30)
        {
            [arr addObject:node];
            [node removeAllActions];
            [node runAction:[SCNAction  removeFromParentNode]];
        }
    }
    [arrEnemyBullet removeObjectsInArray:arr];
}

-(void)pause
{
    [viewScene.scene setPaused:YES];
    [timer pause];
    [timerDispaly pause];
}

-(void)resume
{
    [viewScene.scene setPaused:NO];
    [timer resume];
    [timerDispaly resume];
}

-(void)stop
{
    if (self.session) {
        [self.session stopRunning];
    }
    [_manager stopDeviceMotionUpdates];
    [viewScene.scene.rootNode removeAllAudioPlayers];
    [viewScene.scene setPaused:YES];
    [timer invalidate];
    timer=nil;
    [timerDispaly invalidate];
    timerDispaly=nil;
    [link invalidate];
    link=nil;
    [linkUpdate invalidate];
    linkUpdate=nil;
}

-(void)setup:(NSInteger)count PlayerBlood:(NSInteger)playerBlood EnemyBlood:(NSInteger)enemyBlood DispalyGap:(float)displayGap FireGap:(float)fireGap BulletCount:(NSInteger)bullet BombCount:(NSInteger)bomb LaserCount:(NSInteger)laser ProtectCount:(NSInteger)protect
{
    enemyCount=count;
    enemyOriginCount=count;
    gapDisplay=displayGap;
    gapFire=fireGap;
    bloodPlayer=playerBlood;
    bloodOriginPlayer=playerBlood;
    bloodEnemy=enemyBlood;
    bulletCount=bullet;
    BombCount=bomb;
    LaserCount=laser;
    protectCount=protect;
    lbBullet.text=[NSString stringWithFormat:@"%ld",bulletCount];
}

#pragma mark - 生成敌人
-(void)generateEnemy
{
    if(enemyCount==0)
    {
        return;
    }
    enemyCount--;
    EnemyNode *newNode=[EnemyNode node];
    newNode.name=[NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]*1000];
    SCNNode *node= [ship clone];
    node.hidden=NO;
    [newNode addChildNode:node];
    float xPos=arc4random()%20+60;
    xPos=arc4random()%2?xPos:-xPos;
    float yPos=arc4random()%100;
    float zPos=arc4random()%20+60;
    zPos=arc4random()%2?zPos:-zPos;
    newNode.position=SCNVector3Make(xPos,yPos, zPos);
    newNode.physicsBody=[SCNPhysicsBody dynamicBody];
    newNode.physicsBody.categoryBitMask=ENEMYFLAG;
    newNode.physicsBody.collisionBitMask=0x0;
    newNode.physicsBody.contactTestBitMask=PLAYFLAG|BULLETFLAG;
    newNode.physicsBody.affectedByGravity=NO;
    [viewScene.scene.rootNode addChildNode:newNode];
    float rX,rY;
    rX=fabs(atanf(newNode.position.y/sqrt(pow(newNode.position.x,2)+pow(newNode.position.z,2))));
    if(newNode.position.y>0 && newNode.position.z>0)
    {
        rX=rX;
    }
    else if(newNode.position.y>0 && newNode.position.z<0)
    {
        rX=rX;
    }
    else if(newNode.position.y<0 && newNode.position.z>0)
    {
        rX=-rX;
    }
    else if(newNode.position.y<0 && newNode.position.z<0)
    {
        rX=-rX;
    }
    rY=fabs(atanf(newNode.position.x/newNode.position.z));
    if(newNode.position.x>0 && newNode.position.z>0)
    {
        rY=M_PI+ rY;
    }
    else if(newNode.position.x>0 && newNode.position.z<0)
    {
        rY=-rY;
    }
    else if(newNode.position.x<0 && newNode.position.z>0)
    {
        rY=M_PI- rY;
    }
    else if(newNode.position.x<0 && newNode.position.z<0)
    {
        rY=rY;
    }
    GLKMatrix4 mat=GLKMatrix4MakeRotation(rY, 0, 1, 0);
    mat=GLKMatrix4InvertAndTranspose(mat, NULL);
    GLKVector3 normal=GLKVector3Make(1, 0, 0);
    normal=GLKMatrix4MultiplyVector3(mat, normal);
    [newNode runAction:[SCNAction sequence:@[[SCNAction rotateByX:0 y:rY z:0 duration:0],[SCNAction rotateByAngle:rX aroundAxis:SCNVector3Make(normal.x, normal.y, normal.z) duration:0]]]];
    GLKVector3 vec=GLKVector3Make(0-xPos, 0-yPos, 0-zPos);
    vec=GLKVector3Normalize(vec);
    [newNode runAction:[SCNAction repeatActionForever:[SCNAction moveBy:SCNVector3Make(vec.x, vec.y, vec.z) duration:0.3]]];
    [viewRader setRadius:100];
    float len=sqrt(pow(newNode.position.x, 2)+pow(newNode.position.z, 2));
    NSInteger id= [viewRader addSpot:rY Len:len];
    newNode.raderID=id;
    newNode.blood=bloodEnemy;
    [arrEnemy addObject:newNode];
    [newNode runAction:[SCNAction sequence:@[[SCNAction waitForDuration:gapFire],[SCNAction runBlock:^(SCNNode * _Nonnull node) {
        [self generateEnemyBullet:newNode.position RX:rX RY:rY RotationNormal:SCNVector3Make(normal.x, normal.y, normal.z)];
    }]]]];
    SCNAudioPlayer *play=[SCNAudioPlayer audioPlayerWithSource:audioEnemy];
    [newNode addAudioPlayer:play];
}

//发射子弹时,瞄准器小动画
-(void)animateTap
{
    topContraint.constant=-25;
    leftContraint.constant=-25;
    rightContraint.constant=25;
    bottomContraint.constant=25;
    [UIView animateWithDuration:0.1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished)
        {
            topContraint.constant=-15;
            leftContraint.constant=-15;
            rightContraint.constant=15;
            bottomContraint.constant=15;
            [UIView animateWithDuration:0.1 animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }
    }];
}

//玩家血量设置,变颜色
-(void)setPlayerBlood:(float)blood
{
    CGRect frame=lbBlood.frame;
    float per=blood/bloodOriginPlayer;
    frame.size.width=per*([UIScreen mainScreen].bounds.size.width-20);
    lbBlood.frame=frame;
    if(per>=0.8)
    {
        lbBlood.backgroundColor=MyBlueColor;
    }
    else if(per>=0.5 && per<0.8)
    {
        lbBlood.backgroundColor=[UIColor redColor];
    }
    else if(per>=0.3 && per<0.5)
    {
        lbBlood.backgroundColor=[UIColor orangeColor];
    }
    else
    {
        lbBlood.backgroundColor=[UIColor colorWithRed:0.412 green:0.114 blue:0.000 alpha:1.000];
    }
}

-(void)generateEnemyBullet:(SCNVector3)position RX:(float)rX RY:(float)rY RotationNormal:(SCNVector3)rotationNormal;
{
    SCNView *scnView = viewScene;
    SCNBox *box=[SCNBox boxWithWidth:0.1 height:0.1 length:0.2 chamferRadius:5];
    box.firstMaterial.diffuse.contents=[UIColor redColor];
    SCNNode *node=[SCNNode nodeWithGeometry:box];
    node.physicsBody=[SCNPhysicsBody dynamicBody];
    node.physicsBody.categoryBitMask=ENEMYBULLETFLAG;
    node.physicsBody.collisionBitMask=0x0;
    node.physicsBody.contactTestBitMask=PLAYFLAG;
    node.position=SCNVector3Make(position.x, position.y-1, position.z);
    node.physicsBody.affectedByGravity=NO;
    [scnView.scene.rootNode addChildNode:node];
    [node runAction:[SCNAction sequence:@[[SCNAction rotateByX:0 y:rY z:0 duration:0],[SCNAction rotateByAngle:rX aroundAxis:rotationNormal duration:0]]]];
    GLKVector3 normal=GLKVector3Make(0-node.position.x, 0-node.position.y, 0-node.position.z);
    normal=GLKVector3Normalize(normal);
    [node runAction:[SCNAction repeatActionForever:[SCNAction moveBy:SCNVector3Make(normal.x*2, normal.y*2, normal.z*2) duration:0.1]]];
    [arrEnemyBullet addObject:node];
}

//人脸识别
-(void)detectFace:(UIImage*)originalImage
{
    CIImage* inputImage = [[CIImage alloc] initWithImage:originalImage];
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    NSArray* faceFeatures = [detector featuresInImage:inputImage];
    CGSize inputImageSize = [inputImage extent].size;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1, -1);
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    
    for(CIFaceFeature* faceFeature in faceFeatures)
    {
        CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        float scale = MIN(self.bounds.size.width / inputImageSize.width,
                          self.bounds.size.height / inputImageSize.height);
        float offsetX = (self.bounds.size.width - inputImageSize.width * scale) / 2;
        float offsetY = (self.bounds.size.height - inputImageSize.height * scale) / 2;
        faceViewBounds = CGRectApplyAffineTransform(faceViewBounds, CGAffineTransformMakeScale(scale, scale));
        faceViewBounds.origin.x += offsetX;
        faceViewBounds.origin.y += offsetY;
        NSLog(@"%@",NSStringFromCGRect(faceViewBounds));
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if(bFace)
    {
        for (AVMetadataObject *metadataObject in metadataObjects)
        {
            if( metadataObject.type == AVMetadataObjectTypeFace )
            {
                AVMetadataObject* transformedMetadataObject = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                if(transformedMetadataObject!=nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(bloodPlayer<bloodOriginPlayer)
                        {
                            if(bloodPlayer+100<=bloodOriginPlayer)
                            {
                                bloodPlayer+=100;
                                [self setPlayerBlood:bloodPlayer];
                            }
                            else
                            {
                                bloodPlayer=bloodOriginPlayer;
                                [self setPlayerBlood:bloodOriginPlayer];
                            }
                            [viewScene.scene.rootNode runAction:[SCNAction playAudioSource:[SCNAudioSource audioSourceNamed:@"blood.wav"] waitForCompletion:NO]];
                            CGRect frame=transformedMetadataObject.bounds;
                            frame.origin.x-=20;
                            frame.size.width+=40;
                            UILabel *lb=[[UILabel alloc] initWithFrame:frame];
                            [self addSubview:lb];
                            lb.font=[UIFont fontWithName:@"Chalkduster" size:22];
                            lb.text=@"+100";
                            lb.textColor=[UIColor redColor];
                            lb.textAlignment=NSTextAlignmentCenter;
                            [UIView animateWithDuration:2 animations:^{
                                CGRect frame=lb.frame;
                                frame.origin.y-=200;
                                lb.frame=frame;
                                lb.alpha=0;
                            } completion:^(BOOL finished) {
                                [lb removeFromSuperview];
                            }];
                        }
                    });
                    
                }
            }
        }
    }
    bFace=NO;
}
@end










