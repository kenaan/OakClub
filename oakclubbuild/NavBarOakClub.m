//
//  NavBarOakClub.m
//  oakclubbuild
//
//  Created by hoangle on 4/3/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#import "NavBarOakClub.h"
#import "AppDelegate.h"

@implementation NavBarOakClub
@synthesize customView = _customView;
@synthesize badge = _badge;
@synthesize header = _header;
@synthesize btnRight = _btnRight;

@synthesize labelNotifications;
@synthesize imageNotifications;

- (id)initWithFrame:(CGRect)frame
{

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NavBarOakClub" owner:self options:nil];
    self = [array objectAtIndex:0];
    [self setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    
    UIView *view = [array objectAtIndex:1];
    
    self.customView = view;
    [self addSubview:view];
    
    [ (UIButton *)[self.customView viewWithTag:1] addTarget:self action:@selector(menuPressed:) forControlEvents:UIControlEventTouchUpInside];
    [(UIButton *)[self.customView viewWithTag:3] addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [(UILabel *) [self.customView viewWithTag:4] setFont:FONT_NOKIA(20.0)];
    return self;
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     // Drawing code
     UIImage *image = [UIImage imageNamed: @"header.png"];
     [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
     
     //for iOS5
     [self setBackgroundImage:[UIImage imageNamed: @"header.png"] forBarMetrics:UIBarMetricsDefault];
 }

-(void)initRightButtonBar{
    UIButton* rightButton=(UIButton *)[self.customView viewWithTag:3];
    [rightButton setHidden:NO];
#if ENABLE_DEMO
    if([rightButtonClass isEqualToString:@"VCChat"]){
        [rightButton setImage:[UIImage imageNamed:@"btn-chat.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btn-chat-pressed.png"] forState:UIControlStateHighlighted];
    }
    if([rightButtonClass isEqualToString:@"VCMyProfile"]){
        [rightButton setImage:[UIImage imageNamed:@"header_btn_save.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"header_btn_save_pressed.png"] forState:UIControlStateHighlighted];
    }
#else
    if([rightButtonClass isEqualToString:@"VCMyProfile"]){
        [rightButton setImage:[UIImage imageNamed:@"header_btn_save.png"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"header_btn_save_pressed.png"] forState:UIControlStateHighlighted];
    }
#endif
    
    
}
- (void)menuPressed:(id)sender {
    NSLog(@"openMenu");
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    [appDel showLeftView];    
}

- (void)rightItemPressed:(id)sender {
    NSLog(@"rightItemPressed");
    
    if(rightButtonClass != nil && [rightButtonClass length]>0 && ![rightButtonClass isEqualToString:@"VCMyProfile"]){
#if ENABLE_DEMO
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        [appDel.rootVC showViewController:appDel.chat];
#else
        Class _class = NSClassFromString(rightButtonClass);
        NSArray *array = [NSArray arrayWithObject:[[_class alloc] initWithNibName:rightButtonClass bundle:nil]];
        [currentView.navigationController pushViewController:array[0] animated:YES];
#endif
    }
    else{
        if(rightView != nil)
        {

            [currentView.navigationController pushViewController:rightView animated:YES];
   
        }
    }
    if([currentView isKindOfClass:[VCMyProfile class]])
    {
        VCMyProfile *profileView= (VCMyProfile*)currentView;
        [profileView saveSetting];
    }
}

- (void) setHeaderName:(NSString *)name{
    self.header = (UILabel *) [self.customView viewWithTag:4];
    self.header.text = name;
}

-(void) setRightViewController:(UIViewController *)view{
    rightView = view;
    [self initRightButtonBar];
}
-(void) setCurrentViewController:(UIViewController *)view{
    currentView = view;
}

-(void)setRightButton:(NSString*)className{
    rightButtonClass = className;
    [self initRightButtonBar];
}

-(void)addToHeader:(UIView*)subview
{
    if( [self.header subviews].count > 0 )
    {
        for (UIView *subView in [self.header subviews])
        {
            
            [subView removeFromSuperview];
            
        }
    }
    [self.header addSubview:subview];
}

-(void)setNotifications:(int)count
{
    self.labelNotifications = (UILabel *) [self.customView viewWithTag:5];
    self.imageNotifications = (UIImageView *) [self.customView viewWithTag:6];
    
    if(count > 0)
    {


        labelNotifications.hidden = NO;
        imageNotifications.hidden = NO;
        labelNotifications.text = [NSString stringWithFormat:@"+%d", count];
    }
    else
    {
        labelNotifications.hidden = YES;
        imageNotifications.hidden = YES;
    }
    
    [self.customView bringSubviewToFront:imageNotifications];
    [self.customView bringSubviewToFront:labelNotifications];
}

@end