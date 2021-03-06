

#ifndef MacroDefinition_h
#define MacroDefinition_h

#define HOME_PAGE @"http://101.78.230.95:8082/microbroadcastDEV"
#define SET_PROXY 0
#define WEIBO_ID @"1989424925"

#define SELF_USERINFO @"self_UserInfo"

#define ACTIVITY_LABEL_HEIGHT 40  //stand for the height of locationLabel and activityTimeLabel

//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44

//ToolBar 高度
#define TOOLBAR_HEIGHT 40

//键盘高度
#define KEYBOARD_HEIGHT 216

//获取屏幕 宽度、高度
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//-------------------获取设备大小-------------------------

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//-------------------七牛-------------------------
#define QiniuAccessKey  @"89DgnUvGmfOxOBnQeVn1z99ypLdGoC2JKsvs8aOU"
#define QiniuSecretKey  @"FsTqp2yKJwtz5dI9vjhmzK16K6X8r9dzDa65mf23"
#define QiniuBucketName @"microbroadcast"
#define QiniuDomian     [NSString stringWithFormat:@"http://%@.qiniudn.com/", QiniuBucketName]

//-------------------七牛-------------------------
typedef enum
{
    SpeakerMessage  = 1,
    ActivityMessage = 2,
    BuyMessage      = 3,
    SaleMessage     = 4,
} MessageType;

//com.sina.weibo.SNWeiboSDKDemo
#define kSinaAppKey         @"504571936"
#define kSinaRedirectURI    @"https://api.weibo.com/oauth2/default.html"

//tencen qq
#define kTencentQQAppKey        @"101049592"
#define kTencentQQRedirectURI   @"www.qq.com"

typedef enum
{
    kGirl    = 0,
    kBoy     = 1,
    kUnKnown = 2,
}Gender;

typedef enum
{
    kFuDan = 1,
    kHuaLi = 2,
}AreaType;

typedef enum
{
    kSinaWeiBoLogIn = 1,
    kTencentQQLogIn = 2,
}LogInMethod;

#endif
