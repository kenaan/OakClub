//
//  AppDelegate.m
//  oakclubbuild
//
//  Created by VanLuu on 3/27/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>
#import "AFHTTPClient+OakClub.h"
#import "AFHTTPRequestOperation.h"

#import "HistoryMessage.h"
#import "FacebookSDK/FBWebDialogs.h"
NSString *const SCSessionStateChangedNotification =
@"com.facebook.Scrumptious:SCSessionStateChangedNotification";
@interface AppDelegate()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end
@implementation AppDelegate
{
    NSString* s_DeviceToken;
}
NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";
// for Chatting
@synthesize _messageDelegate;
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize window;
@synthesize navigationController;
@synthesize settingsViewController;
@synthesize loginButton;
// end Chatting
@synthesize myFBProfile = _myFBProfile;
@synthesize myProfile = _myProfile;
//@synthesize hangoutView = _hangout;
@synthesize loginView = _loginView;
@synthesize myLink = _myLink;
@synthesize chat = _chat;
@synthesize snapShoot = _snapShoot;
#if ENABLE_DEMO
@synthesize simpleSnapShot = _simpleSnapShot;
@synthesize snapShotSettings = _snapShotSettings;
@synthesize mutualMatches = _mutualMatches;
#endif
@synthesize visitor = _visitor;
@synthesize rootVC = _rootVC;
@synthesize hangOut = _hangOut;
@synthesize myProfileVC = _myProfileVC;
@synthesize getPoints = _getPoints;

@synthesize friendChatList;
@synthesize accountSetting;
@synthesize activeVC;

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
//==============================================================//
#pragma mark UIApplicationDelegate
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self changeFontStyle];

    
//    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _messageDelegate = nil;
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    self.chat = [self createNavigationByClass:@"VCChat" AndHeaderName:@"Chat History" andRightButton:nil andIsStoryBoard:NO];
    self.myLink = [self createNavigationByClass:@"VCMyLink" AndHeaderName:@"My Links" andRightButton:nil andIsStoryBoard:NO];
    self.snapShoot = [self createNavigationByClass:@"VCSnapshoot" AndHeaderName:@"Snapshot" andRightButton:@"SnapshotSetting" andIsStoryBoard:YES];
#if ENABLE_DEMO
    self.simpleSnapShot = [self createNavigationByClass:@"VCSimpleSnapshot" AndHeaderName:@"Snapshot" andRightButton:@"VCChat" andIsStoryBoard:NO];
//     self.snapShotSettings = [self.storyboard instantiateViewControllerWithIdentifier:@"SnapshotSettings"];
        self.snapShotSettings = [self createNavigationByClass:@"VCSimpleSnapshotSetting" AndHeaderName:@"Settings" andRightButton:nil andIsStoryBoard:NO];
    self.mutualMatches = [self createNavigationByClass:@"VCMutualMatch" AndHeaderName:@"Mutual Matches" andRightButton:nil andIsStoryBoard:NO];
#endif
    self.visitor = [self createNavigationByClass:@"VCVisitor" AndHeaderName:@"Visitors" andRightButton:nil andIsStoryBoard:NO];
    self.hangOut = [self createNavigationByClass:@"VCHangOut" AndHeaderName:@"Meet people around" andRightButton:@"HangoutSetting" andIsStoryBoard:YES];
    self.myProfileVC = [self createNavigationByClass:@"VCMyProfile" AndHeaderName:@"Edit Profile" andRightButton:@"VCMyProfile" andIsStoryBoard:NO];
    self.getPoints = [self createNavigationByClass:@"VCGetPoints" AndHeaderName:@"Get Coins" andRightButton:nil andIsStoryBoard:NO];
    self.loginView = [[SCLoginViewController alloc] initWithNibName:@"SCLoginViewController" bundle:nil];

//    menuViewController *leftController = [[menuViewController alloc] init];
    // PKRevealController
#if ENABLE_DEMO
    activeVC = _simpleSnapShot;
    self.rootVC = [PKRevealController revealControllerWithFrontViewController:self.simpleSnapShot
                                                           rightViewController:self.chat
                                                                      options:nil];
#else
    activeVC = _snapShoot;
    self.rootVC = [PKRevealController revealControllerWithFrontViewController:self.snapShoot
                                                           leftViewController:nil
                                                                      options:nil];
#endif
    
//    UIViewController * test = [[VCHangoutSetting alloc] initWithNibName:@"VCHangoutSetting" bundle:nil];
//    self.window.rootViewController = test;
    self.window.rootViewController = self.loginView;
    [self.window makeKeyAndVisible];

    BOOL hasInternet = [self checkInternetConnection];
    // See if we have a valid token for the current state.
    if (hasInternet && (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded || FBSession.activeSession.state == FBSessionStateOpen)) {
        // To-do, show logged in view
        [self.loginView startSpinner];
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)];
    
	// Check if the app was launched in response to the user tapping on a
	// push notification. If so, we add the new message to the data model.
	if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
	}
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	// We have received a new device token. This method is usually called right
	// away after you've registered for push notifications, but there are no
	// guarantees. It could take up to a few seconds and you should take this
	// into consideration when you design your app. In our case, the user could
	// send a "join" request to the server before we have received the device
	// token. In that case, we silently send an "update" request to the server
	// API once we receive the token.
    
	NSString* oldToken;//[dataModel deviceToken];
    
	NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	s_DeviceToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", s_DeviceToken);
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	// If we get here, the app could not obtain a device token. In that case,
	// the user can still send messages to the server but the app will not
	// receive any push notifications when other users send messages to the
	// same chat room.
    
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	// This method is invoked when the app is running and a push notification
	// is received. If the app was suspended in the background, it is woken up
	// and this method is invoked as well. We add the new message to the data
	// model and add it to the ChatViewController's table view.
    
	NSLog(@"Received notification: %@", userInfo);
    
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	// Create a new Message object
    
	// The JSON payload is already converted into an NSDictionary for us.
	// We are interested in the contents of the alert message.
    NSDictionary *dict = [userInfo valueForKey:@"aps"] ;
	NSString* alertValue = [dict valueForKey:@"alert"];
    NSString* type = [dict valueForKey:@"type"];
    
    if (updateUI)
    {
        
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url
                                      sourceApplication:(NSString *)sourceApplication
                                             annotation:(id)annotation {
     return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(UINavigationController*)activeViewController
{
    return activeVC;
}
-(void)changeFontStyle{
//     [[UILabel appearance] setFont:FONT_NOKIA(17.0)];
//    [[UILabel appearance] setAdjustsFontSizeToFitWidth:YES];
}
-(void)showChat {
//    [self.rootVC setRootController:self.chat animated:YES];
//    [self.rootVC setContentViewController:self.chat snapToContentViewController:YES animated:YES];
    activeVC = _chat;
#if ENABLE_DEMO
    [self.rootVC showViewController:self.chat];
#else
    [self.rootVC setFrontViewController:self.chat focusAfterChange:YES completion:^(BOOL finished) {
    }];
#endif
    
        
}
#if ENABLE_DEMO
-(void)showSnapshotSettings {
    //    [self.rootVC setRootController:self.snapShoot animated:YES];
    //    [self.rootVC setContentViewController:self.snapShoot snapToContentViewController:YES animated:YES];
    activeVC = _snapShotSettings;
    [self.rootVC setFrontViewController:self.snapShotSettings focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}
-(void)showSimpleSnapshot {
    //    [self.rootVC setRootController:self.snapShoot animated:YES];
    //    [self.rootVC setContentViewController:self.snapShoot snapToContentViewController:YES animated:YES];
    activeVC = _simpleSnapShot;
    [self.rootVC setFrontViewController:self.simpleSnapShot focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}
-(void)showMutualMatches {
    //    [self.rootVC setRootController:self.myLink animated:YES];
    //    [self.rootVC setContentViewController:self.myLink snapToContentViewController:YES animated:YES];
    activeVC = _mutualMatches;
    [self.rootVC setFrontViewController:self.mutualMatches focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}
#endif
-(void)showSnapshoot {
//    [self.rootVC setRootController:self.snapShoot animated:YES];
//    [self.rootVC setContentViewController:self.snapShoot snapToContentViewController:YES animated:YES];
    activeVC = _snapShoot;
    [self.rootVC setFrontViewController:self.snapShoot focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}



-(void)showMylink {
//    [self.rootVC setRootController:self.myLink animated:YES];
//    [self.rootVC setContentViewController:self.myLink snapToContentViewController:YES animated:YES];
    activeVC = _myLink;
    [self.rootVC setFrontViewController:self.myLink focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}

-(void)showVisitor {
//    [self.rootVC setRootController:self.visitor animated:YES];
//    [self.rootVC setContentViewController:self.visitor snapToContentViewController:YES animated:YES];
    activeVC = _visitor;
    [self.rootVC setFrontViewController:self.visitor focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}

-(void)showHangOut {
//    [self.rootVC setRootController:self.hangOut animated:YES];
//    [self.rootVC setContentViewController:self.hangOut snapToContentViewController:YES animated:YES];
    activeVC = _hangOut;
    [self.rootVC setFrontViewController:self.hangOut focusAfterChange:YES completion:^(BOOL finished) {
        
    }];
}
-(void)showMyProfile {
    activeVC = _myProfileVC;
    NSLog(@" 000 - %@",self.myProfile.s_relationShip.rel_text);
    [[self.myProfileVC.viewControllers objectAtIndex:0] setDefaultEditProfile:self.myProfile];
    [self.rootVC setFrontViewController:self.myProfileVC focusAfterChange:YES completion:^(BOOL finished) {
    }];
}
-(void)showGetPoints {
    activeVC = _getPoints;
    [self.rootVC setFrontViewController:self.getPoints focusAfterChange:YES completion:^(BOOL finished) {
    }];
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
-(void)showInvite{
    NSError *error;
     NSMutableArray *suggestedFriends = [[NSMutableArray alloc] init];
    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=installed" parameters:nil HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
//        NSLog(@"Found: %i friends", friends.count);
       
        for (NSDictionary<FBGraphUser>* friend in friends) {
            if([[friend objectForKey:@"installed"] integerValue]==0)
                [suggestedFriends addObject:friend.id];
//            NSLog(@"I have a friend named %@ with id %@", [[friend objectForKey:@"installed"] integerValue]==1?@"true":@"false", friend.id);
        }
//        NSArray *friendIDs = [friends collect:^id(NSDictionary<FBGraphUser>* friend) {
//            return friend.id;
//        }];
        
    }];
//    NSData *jsonData = [NSJSONSerialization
//                        dataWithJSONObject:@{
//                        @"social_karma": @"5",
//                        @"badge_of_awesomeness": @"1"}
//                        options:0
//                        error:&error];
//    if (!jsonData) {
//        NSLog(@"JSON error: %@", error);
//        return;
//    }
//    NSString *giftStr = [[NSString alloc]
//                         initWithData:jsonData
//                         encoding:NSUTF8StringEncoding];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [suggestedFriends componentsJoinedByString:@","], @"to",
                                   nil];
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"Learn how to make your iOS apps social."
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              NSString *requestID = [urlParams valueForKey:@"request"];
                                                              NSLog(@"Request ID: %@", requestID);
                                                              NSLog(@"Request Sent.");
                                                          }
                                                      }}];
}
-(void)showLeftView {
    [self.rootVC showViewController:self.rootVC.leftViewController];
}

-(void)logOut {
    [self.loginView stopSpinner];
    [self showLoginView];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self teardownStream];
    [self  disconnect];
	[[self  xmppvCardTempModule] removeDelegate:self];
}

- (void)showLoginView {
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    
    if(!self.loginView.isBeingPresented) {
//        self.loginView = [[SCLoginViewController alloc] initWithNibName:@"SCLoginViewController" bundle:nil];
//        [self.rootVC presentModalViewController:self.loginView animated:YES];
        self.window.rootViewController = self.loginView;
    }
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            NSLog(@"Logged in!");
            
            [self.loginView dismissModalViewControllerAnimated:YES];
//            self.loginView = nil;
            
            [FBRequestConnection startForMeWithCompletionHandler:
             ^(FBRequestConnection *connection, id result, NSError *error)
             {
                 self.myFBProfile = (id<FBGraphUser>)result;
                 [self loadDataForList];
//                 NSLog(@"%@",[result objectForKey:@"gender"]);
//                 NSLog(@"%@",[result objectForKey:@"gender"]);
//                 NSLog(@"%@",[result objectForKey:@"relationship_status"]);
//                 NSLog(@"%@",[result objectForKey:@"about"]);
#if ENABLE_DEMO
                 [self  getProfileInfo];
                 [self loadLikeMeList];
#else
                 UIStoryboard *registerStoryboard = [UIStoryboard
                                                     storyboardWithName:@"RegisterConfirmation"
                                                     bundle:nil];
                 UIViewController *registerViewConroller = [registerStoryboard
                                                            instantiateInitialViewController];
                 self.window.rootViewController = registerViewConroller;
#endif
                 
                 NSLog(@"FB Login request completed!");
             }];
        }
            break;
        case FBSessionStateClosed:
            [self logOut];
            
            NSLog(@"Logged out!");
            
            break;
        case FBSessionStateClosedLoginFailed:
            //[self showLoginView];
            [self logOut];
            
            NSLog(@"Login failed! %@",[error description] );

            break;
        default:
            
            NSLog(@"Not login yet!");
            break;
    }
    // show WARNING when confirm login with FB is FAILD
    /*[[NSNotificationCenter defaultCenter] postNotificationName:SCSessionStateChangedNotification object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }  */  
}

-(void)getProfileInfo{
    NSDictionary *params  = [[NSDictionary alloc]initWithObjectsAndKeys:s_DeviceToken, @"device_token", nil];
    
    AFHTTPClient *request = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
    [request getPath:URL_getAccountSetting parameters:params success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        
        self.myProfile = [[Profile alloc]init];
        accountSetting = [self.myProfile parseForGetAccountSetting:JSON];
        menuViewController *leftController = [[menuViewController alloc] init];
        [leftController setUIInfo:self.myProfile];
        [self.rootVC setRightViewController:self.chat];
        [self.rootVC setLeftViewController:leftController];
        self.window.rootViewController = self.rootVC;
        
        [self updateProfile ];
//        [self updateChatList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"GetAccountSetting Error Code: %i - %@",[error code], [error localizedDescription]);
    }];

}
- (void)updateProfile
{
    AFHTTPClient *requestHangout = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
    
    [requestHangout getPath:URL_getHangoutProfile parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON)
     {
         //self.myProfile = [[Profile alloc]init];
         [self.myProfile parseForGetHangOutProfile:JSON];
         [self setFieldValue:[NSString stringWithFormat:DOMAIN_AT_FMT,self.myProfile.s_usenameXMPP] forKey:kXMPPmyJID];
         [self setFieldValue:self.myProfile.s_passwordXMPP forKey:kXMPPmyPassword];
         // Configure logging framework
         
         [DDLog addLogger:[DDTTYLogger sharedInstance]];
         
         // Setup the XMPP stream
         
         //int count = [self.myProfile.a_RosterList count];
         //NSLog(@"URL_getHangoutProfile ****** Number of roster list: %d", count);
         
         [self setupStream];
         [self connect];
         
         //Set number of unread message;
         menuViewController* menuVC = (menuViewController*)self.rootVC.leftViewController;
         [menuVC setChatNotification:self.myProfile.unread_message];
         
         [Profile getListPeople:URL_getListWhoCheckedMeOut handler:^(NSMutableArray* list, int count)
         {
             menuViewController* menuVC = (menuViewController*)self.rootVC.leftViewController;
             [menuVC setVisitorsNotification:count];
             
             self.myProfile.new_visitors = count;
             //NSLog(@"new visitors: %d", count);
             
             NavBarOakClub* navbar = (NavBarOakClub*)self.snapShoot.navigationBar;
             [navbar setNotifications:[self countTotalNotifications]];
         }];
         
         [Profile getListPeople:URL_getListMutualMatch handler:^(NSMutableArray* list, int count)
          {
              menuViewController* menuVC = (menuViewController*)self.rootVC.leftViewController;
              [menuVC setMyLinksNotification:count];
              
              self.myProfile.new_mutual_attractions = count;
              //NSLog(@"new visitors: %d", count);
              
              NavBarOakClub* navbar = (NavBarOakClub*)self.snapShoot.navigationBar;
              [navbar setNotifications:[self countTotalNotifications]];
          }];
         
         AFHTTPClient *requestPhoto = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
         NSDictionary *params  = [[NSDictionary alloc]initWithObjectsAndKeys:self.myProfile.s_ID, key_profileID, nil];
         self.myProfile.arr_photos = [[NSMutableArray alloc] init];
         [requestPhoto getPath:URL_getListPhotos parameters:params
                       success:^(__unused AFHTTPRequestOperation *operation, id JSON)
          {
              self.myProfile.arr_photos = [Profile parseListPhotos:JSON];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
          }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"URL_getHangoutProfile Error Code: %i - %@",[error code], [error localizedDescription]);
     }];
    
}
//- (void) updateChatList{
//    NSMutableArray *_arrRoster = [[NSMutableArray alloc] init];
//    
//    AFHTTPClient *request = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
//    [request getPath:URL_getListChat parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
//        NSError *e=nil;
//        NSMutableDictionary *dict_ListChat = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
//        //        NSMutableDictionary * data= [dict valueForKey:key_data];
//        
//        self.myProfile.unread_message = 0;
//        NSMutableArray* rosterList = [dict_ListChat valueForKey:key_data];
//        
//        for (int i = 0; rosterList!=nil && i < [rosterList count]; i++) {
//            NSMutableDictionary *objectData = [rosterList objectAtIndex:i];
//            
//            if(objectData != nil)
//            {
//                NSString* profile_id = [objectData valueForKey:key_profileID];
//                bool deleted = [[objectData valueForKey:@"is_deleted"] boolValue];
//                bool blocked = [[objectData valueForKey:@"is_blocked"] boolValue];
//                //bool deleted_by = [[objectData valueForKey:@"is_deleted_by_user"] boolValue];
//                bool blocked_by = [[objectData valueForKey:@"is_blocked_by_user"] boolValue];
//                // vanancyLuu : cheat for crash
//                if(!deleted && !blocked && !blocked_by )
//                {
//                    [_arrRoster addObject:profile_id];
//                    
//                    int unread_count = [[objectData valueForKey:@"unread_count"] intValue];
//                    
//                    NSLog(@"%d. unread message: %d", i, unread_count);
//                    
//                    self.myProfile.unread_message += unread_count;
//                }
//            }
//        }
//        
//        NSLog(@"unread message: %d", self.myProfile.unread_message);
//        
//        self.myProfile.a_RosterList = [NSArray arrayWithArray:_arrRoster];
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error Code: %i - %@", [error code], [error localizedDescription]);
//    }];
//}
- (void)openSession
{
    NSArray *permission = [[NSArray alloc] initWithObjects:@"email",@"user_birthday",@"user_location",nil];
    [FBSession openActiveSessionWithReadPermissions:permission
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
//    NSArray *permissions =[NSArray arrayWithObjects:@"email",@"user_birthday",@"user_location",@"user_photos", @"friends_photos", nil];
//    
//    [[FBSession activeSession] reauthorizeWithReadPermissions:permissions
//                                            completionHandler:^(FBSession *session, NSError *error) {
//                                                /* handle success + failure in block */
//                                                NSDictionary* params = [NSDictionary dictionaryWithObject:@"id,name,gender,relationship_status,about,location,interested_in,birthday,email" forKey:@"fields"];
//                                                [FBRequestConnection startWithGraphPath:@"me" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                                    NSLog(@"USER INFO _ %@",result);
//                                                }];
//                                            }];
}


-(NavConOakClub *) createNavigationByClass:(NSString *)className AndHeaderName:(NSString*) headerName andRightButton:(NSString*)rightViewControll andIsStoryBoard:(BOOL)isStoryBoard{
    NavConOakClub *nvOakClub = [[NavConOakClub alloc] initWithNavigationBarClass:[NavBarOakClub class] toolbarClass:nil];
    Class _class = NSClassFromString(className);
    NSArray *array = [NSArray arrayWithObject:[[_class alloc] initWithNibName:className bundle:nil]];
    [nvOakClub setViewControllers:array];

    NavBarOakClub *tempBar = (NavBarOakClub*) nvOakClub.navigationBar;
    [tempBar setHeaderName:headerName];
    [tempBar setCurrentViewController:[array objectAtIndex:0]];

    if(isStoryBoard){
        UIStoryboard *settingsStoryboard = [UIStoryboard
                                            storyboardWithName:rightViewControll
                                            bundle:nil];
        UIViewController *settingsViewConroller = [settingsStoryboard
                                                   instantiateInitialViewController];
        [tempBar setRightViewController:settingsViewConroller];
    }
    else{
        if(rightViewControll != nil)
            [tempBar setRightButton:rightViewControll]; 
    }
    return nvOakClub;
}
-(BOOL)checkInternetConnection{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
        return NO;
    }
    return YES;
}
-(void)loadDataForList{
    self.cityList = [[NSMutableDictionary alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:@"Never" forKey:@"key_EmailSetting"] ;
    if(self.relationshipList != nil && [self.relationshipList count] > 0)
        return;
    AFHTTPClient *request = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
    
    [request getPath:URL_getListLangRelWrkEth parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON)
     {
         
         NSError *e=nil;
         NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
         NSMutableDictionary * data= [dict valueForKey:key_data];
         self.ethnicityList =[data valueForKey:key_ethnicity];
         self.workList = [data valueForKey:key_WorkCate];
         self.languageList = [data valueForKey:key_language];
         self.relationshipList = [data valueForKey:key_relationship];
         self.genderList = GenderList;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
     }];


}
#if ENABLE_DEMO
-(void)loadLikeMeList{
    self.likedMeList = [[NSArray alloc] init];
    AFHTTPClient *request = [[AFHTTPClient alloc] initWithOakClubAPI:DOMAIN];
    
    [request getPath:URL_getListWhoLikeMe parameters:nil success:^(__unused AFHTTPRequestOperation *operation, id JSON)
     {
         NSError *e=nil;
         NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:&e];
         self.likedMeList= [dict valueForKey:key_data];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error Code: %i - %@",[error code], [error localizedDescription]);
     }];
    
//    self.likedMeList = [[NSArray alloc] initWithObjects:@"1lxx2uvvxk",@"1lxx8s7w83",@"1lxwqp7lql",@"1lxx4x6iv6",@"1lxx56o0ht",@"1lxx7aat12", nil];
}
#endif
-(int)countTotalNotifications
{
    return [self.myProfile countTotalNotifications];
}


-(void)loadFriendsList
{
    if (![xmppStream isAuthenticated]) {
        return;
    }
    
    int count = [self.myProfile.dic_Roster count];
    
    friendChatList = [[NSMutableDictionary alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSArray *IDs = [self.myProfile.dic_Roster allKeys];
    
    for (int i = 0; i < count; i++)
    {
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithOakClubAPI:DOMAIN];
        
        
        Profile *profile = [[Profile alloc] init];
        profile.s_ID = [IDs objectAtIndex:i];
        
        NSString* xmpp_id = [NSString stringWithFormat:@"%@%@", profile.s_ID, DOMAIN_AT];
        
        XMPPJID* jid = [XMPPJID jidWithString:xmpp_id];
        
        [friendChatList setObject:profile forKey:xmpp_id];
        
        NSLog(@"%d. Add friend id: %@", i, profile.s_ID);
        
        NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:profile.s_ID , key_profileID, nil];
        
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:URL_getHangoutProfile
                                                          parameters:params];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *e=nil;
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
            
            NSMutableDictionary * data= [dict valueForKey:key_data];
            
            NSString* profile_id = [data valueForKey:key_profileID];
            
            NSString* xmpp_id = [NSString stringWithFormat:@"%@%@", profile_id, DOMAIN_AT];
            
            Profile* friend = [friendChatList objectForKey:xmpp_id];
            
            [friend parseProfileWithDictionary:data];
            
            
            if(friend.s_Name == nil || [friend.s_Name isEqualToString:@""] || [friend.s_ID isEqualToString:self.myProfile.s_ID])
            {
                //[xmppRoster removeUser:jid];
                ///NSLog(@"%d.1 Remove user: %s for user_id: %s", i, friend.s_Name.UTF8String, xmpp_id.UTF8String);
                
            }
            else
            {
                [xmppRoster addUser:jid withNickname:friend.s_Name];
                //[xmppRoster setNickname:friend.s_Name forUser:jid];
                NSLog(@"%d.2 Set nick name: %s for user_id: %s", i, friend.s_Name.UTF8String, xmpp_id.UTF8String);
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        
        
        //[operation start];
        [queue addOperation:operation];
        
        
    }
}

//==============================================================//
#pragma mark Private
- (void)setFieldValue:(NSString *)field forKey:(NSString *)key
{
    if (field != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.
	
	//xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
	
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	
	xmppRoster.autoFetchRoster = NO; // auto get history chat list - Vanancy
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
	
	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
	
	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
	
	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
	
	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
    
    xmppCapabilities.autoFetchHashedCapabilities = YES;
    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
	// Activate xmpp modules
    
	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
	[xmppvCardTempModule   activate:xmppStream];
	[xmppvCardAvatarModule activate:xmppStream];
	[xmppCapabilities      activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:HOSTNAME];
    //	[xmppStream setHostPort:5222];
	
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	[xmppvCardTempModule   deactivate];
	[xmppvCardAvatarModule deactivate];
	[xmppCapabilities      deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
	xmppvCardStorage = nil;
    xmppvCardTempModule = nil;
	xmppvCardAvatarModule = nil;
	xmppCapabilities = nil;
	xmppCapabilitiesStorage = nil;
}

- (void)goOnline
{
//	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
//	
//	[[self xmppStream] sendElement:presence];
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [xmppStream sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}
//==============================================================//
#pragma mark Core Data
- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}
//==============================================================//



#pragma mark Connect/disconnect
- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	//[xmppStream setMyJID:[XMPPJID jidWithString:@"1lxvf4wfg3@doolik.com"]];
	//password = @"fdT2vs0QTLHN4XZaRFvYNuH6L6v64lLJ+I6atCcf2ujxKXatm0XWNgzSzBqDTb8VGPubfIjr4sTW0ddFCIx8Mg==";
    
    [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    password = myPassword;
    
    NSLog(@"JID: %s", [myJID UTF8String]);
    NSLog(@"Password: %s", [password UTF8String]);
    
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}
//==============================================================//
#pragma mark XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

-(BOOL)isAuthenticated
{
    return [xmppStream isAuthenticated];
}


- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    NSLog(@"xmppStreamDidAuthenticate");

    [self loadFriendsList ];
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}


-(void)sendMessageState:(NSString*)state to:(NSString*)xmpp_id
{
    NSXMLElement *stateXML = [NSXMLElement elementWithName:state];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:xmpp_id];
    [message addChild:stateXML];
    
    [self.xmppStream sendElement:message];
}

-(void)sendMessageContent:(NSString*)content to:(NSString*)xmpp_id
{
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:content];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:xmpp_id];
    [message addChild:body];
    
    [self.xmppStream sendElement:message];
}

-(void)showLocalNotification:(NSString*) displayName and:(NSString*)body
{
    // We are not active, so use a local notification instead
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertAction = @"Ok";
    localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName, body];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (XMPPMessage *)xmppStream:(XMPPStream *)sender willReceiveMessage:(XMPPMessage *)message
{
    
    
    return message;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
    NSString* jid = [NSString stringWithFormat:@"%@@%@",[message from].user, [message from].domain];
    
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
    
    NSLog(@"didReceiveMessage: type=%@", type);
    
    if(msg == nil)
    {
        msg = [[message elementForName:@"composing"] stringValue];
        
        if(msg == nil)
            msg = [[message elementForName:@"paused"] stringValue];            
    }
    NSLog(@"didReceiveMessage: msg=%@", msg);
    
    
    
    if(msg == nil || type == nil || [type isEqualToString:@"error"])
    {
        NSLog(@"send error.");
        return;
    }
	//NSString *from = [[message attributeForName:@"from"] stringValue];
    
	NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
	[m setObject:msg forKey:@"msg"];
	//[m setObject:from forKey:@"sender"];
    [m setObject:jid forKey:@"sender"];
	
    if(_messageDelegate != nil)
        [_messageDelegate newMessageReceived:m];
//    else
//    {
//        XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
//		                                                         xmppStream:xmppStream
//		                                               managedObjectContext:[self managedObjectContext_roster]];
//		
//		NSString *body = [[message elementForName:@"body"] stringValue];
//		NSString *displayName = [user displayName];
//        
//        [self showLocalNotification:displayName and:body];
//    }
    
	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];
		
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
            
//             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
//             message:body
//             delegate:nil
//             cancelButtonTitle:@"Ok"
//             otherButtonTitles:nil];
//             [alertView show];
            
		}
		else
		{
			[self showLocalNotification:displayName and:body];
		}
	}
}

-(void)sendPresence:(NSString*)jid withType:(NSString*)type
{
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    [presence addAttributeWithName:@"to" stringValue:jid];
    [presence addAttributeWithName:@"type" stringValue:type];
    [xmppStream sendElement:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    NSString* jid = [NSString stringWithFormat:@"%@@%@",[presence from].user, [presence from].domain];
    //NSLog(@"---- didReceivePresence: %@ %@", jid, [presence name]);
    
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
    Profile* profile = [friendChatList objectForKey:jid];
    
    if( profile == nil)
        return;
    
    if( ![jid isEqualToString:[[xmppStream myJID] bare]])
    {
        NSLog(@"Presence type: %@", [presence type]);
        
        if([[presence type] isEqual: @"subscribe"])
        {
            [self sendPresence:jid withType:@"available"];
        }
        else
        if([[presence type] isEqual: @"available"])
        {
            [user setSectionNum:[NSNumber numberWithInt:0]];
            
            if(! profile.is_available )
            {
                [self sendPresence:jid withType:@"available"];
                profile.is_available = true;
            }
            
            NSLog(@"---- user go available: %@ %@", jid, [presence name]);
        }
        else
        {
            [user setSectionNum:[NSNumber numberWithInt:2]];
            
            NSLog(@"---- user go un-available: %@ %@", jid, [presence name]);
            
            profile.is_available = false;
        }
//        else 
//        {
//            [user setSectionNum:[NSNumber numberWithInt:1]];
//        }
        

    }

    [[self.chat.viewControllers objectAtIndex:0] reloadFriendList];

}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSLog(@"didReceiveError: %@", error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}
//==============================================================
#pragma mark XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];
	
	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;
	
	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}
	
	
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}
@end