//
//  UIViewController+Custom.m
//  OakClub
//
//  Created by VanLuu on 7/4/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#import "UIViewController+Custom.h"
#import "Define.h"

#if ENABLE_DEMO
#import "SMChatViewController.h"
#import "AppDelegate.h"
#import "VCSimpleSnapshot.h"
#endif
@implementation UIViewController (Custom)
-(void)customBackButtonBarItem{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 40)];
    [backButton setImage:[UIImage imageNamed:@"Navbar_btn_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"Navbar_btn_back_pressed.png"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backToPreviousView) forControlEvents:UIControlEventTouchUpInside];
    if (IS_OS_7_OR_LATER) {
        [self.navigationItem setHidesBackButton:YES];
        [self.navigationController.navigationBar addSubview:backButton];
    }
    else{
        UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = barBackItem;
    }
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = FONT_HELVETICANEUE_LIGHT(20.0);
//        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
-(void)backToPreviousView{
#if ENABLE_DEMO
//    AppDelegate *appDel = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    UINavigationController* activeVC = [appDel activeViewController];
//    UIViewController* vc = [activeVC.viewControllers objectAtIndex:0];
//    if(![vc isKindOfClass:[VCSimpleSnapshot class]] )
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//        [appDel.rootVC setFrontViewController:activeVC focusAfterChange:NO completion:^(BOOL finished) {
//        }];
//        [appDel.rootVC showViewController:appDel.chat];
//    }
#else
    [self.navigationController popViewControllerAnimated:YES];
#endif
}
@end
