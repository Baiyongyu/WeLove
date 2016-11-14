//
//  UserManager.m
//  anz
//
//  Created by KevinCao on 16/7/5.
//  Copyright © 2016年 ahqianmo. All rights reserved.
//

#import "UserManager.h"
#import "UserInfo.h"
#import "ANZKeyChain.h"

@interface UserManager ()
@property (nonatomic,copy,readwrite) NSString *errorMessage;
@property(nonatomic,copy,readwrite)NSString *session;
@end

@implementation UserManager
@synthesize errorMessage;

+ (instancetype)sharedInstance
{
    static dispatch_once_t AJKHDLocationManagerOnceToken;
    static UserManager *sharedInstance = nil;
    dispatch_once(&AJKHDLocationManagerOnceToken, ^{
        sharedInstance = [[UserManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paramSource = (id)self;
        self.validator = (id)self;
        self.delegate = (id)self;
    }
    return self;
}

- (void)saveUserInfo
{
    [QMUtil deleteCoreDataWithEntity:@"UserInfo"];
    NSManagedObjectContext *workContext = [NSManagedObjectContext generatePrivateContextWithParent:rootContext];
    UserInfo *item = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:workContext];
    item.userId = _userInfo.userId;
    item.userName = _userInfo.userName;
    item.isLogin = [NSNumber numberWithBool:_userInfo.isLogin];
    item.phoneNumber = _userInfo.phoneNumber;
    NSError *error;
    if(![workContext save:&error])
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    else
    {
        [kAppDelegate saveContextWithWait:YES];
    }
}

- (void)clearUserInfo
{
    [QMUtil deleteCoreDataWithEntity:@"UserInfo"];
    self.userInfo.userId = nil;
    self.userInfo.userName = nil;
    self.userInfo.isLogin = NO;
    self.userInfo.avatarImageUrl = nil;
}

- (void)updatePassword:(NSString *)password
{
    if (!password.length) {
        return;
    }
    self.userInfo.password = password;
    [ANZKeyChain save:kKeyPassword data:password];
}

#pragma mark - APIManagerValidator
- (BOOL)manager:(BaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    self.userInfo.userId = [QMUtil checkString:data[@"people_id"]];
    self.userInfo.userName = [QMUtil checkString:data[@"people_name"]];
    self.userInfo.phoneNumber = [QMUtil checkString:data[@"people_phone"]];
    [self saveUserInfo];
    return YES;
}

#pragma mark - APIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager
{

}

- (void)managerCallAPIDidFailed:(BaseAPIManager *)manager
{
    if (manager==self) {
        [MBProgressHUD showTip:self.errorMessage];
        return;
    }
}

#pragma mark - APIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(BaseAPIManager *)manager
{
    return nil;
}

#pragma mark - APIManager
- (NSString *)methodName
{
    return User_Info_Url;
}

- (APIManagerRequestType)requestType
{
    return APIManagerRequestTypeGet;
}

#pragma mark - getters and setters
- (UserModel *)userInfo
{
    if (!_userInfo) {
        _userInfo = [[UserModel alloc] init];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:rootContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *fetchedObjects = [rootContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects.count)
        {
            UserInfo *item = [fetchedObjects firstObject];
            _userInfo.userId = item.userId;
            _userInfo.userName = item.userName;
            _userInfo.isLogin = item.isLogin.boolValue;
            _userInfo.phoneNumber = item.phoneNumber;
        }
        _userInfo.password = [QMUtil checkString:[ANZKeyChain load:kKeyPassword]];
    }
    return _userInfo;
}

- (NSString *)session
{
    NSString *sessionStr = @"";
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"SESSION"]) {
            sessionStr = cookie.value;
        }
    }
    return sessionStr;
}

@end
