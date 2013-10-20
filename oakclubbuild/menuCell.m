//
//  menuCell.m
//  oakclubbuild
//
//  Created by VanLuu on 4/5/13.
//  Copyright (c) 2013 VanLuu. All rights reserved.
//

#import "menuCell.h"

@interface menuCell ()
@property (weak, nonatomic) IBOutlet UIImageView *notificationView;
@property UIImageView* notificationImageView;
@end

static CGFloat padding_top = 2.0;
static CGFloat padding_left = 4.0;

@implementation menuCell

@synthesize notificationView;
@synthesize notificationImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"menuCell" owner:self options:nil];
        
        if ([array count]>0) {
            view = [array objectAtIndex:0];
            [self.contentView addSubview:view];
            view.frame = CGRectMake(0, 0, 320, 35);
            
            notificationImageView = nil;
        }
        
    }
    return self;
}
//@synthesize iconMenu, labelMenu;
- (void) setItemMenu:(NSString *)imageName AndlabelName:(NSString*)label{
    iconMenu.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%@.png",[[imageName stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString]]];
    labelMenu.text = label;
}




+(UIImageView*)getLabelWithBackground:(NSString*) text
                            textColor:(UIColor*) textColor
                            imageName:(NSString*) imageName
                         leftCapWidth:(int) leftCapWidth
                         topCapHeight:(int) topCapHeight
                          leftPadding:(int) leftPadding
                           topPadding:(int) topPadding

{
    UILabel* label = [[UILabel alloc]init];
    
    UIFont* font = [UIFont boldSystemFontOfSize:14.0];
    CGSize  textSize = { 290, CGFLOAT_MAX };
    
	CGSize size = [text sizeWithFont:font
                   constrainedToSize:textSize
                       lineBreakMode:UILineBreakModeWordWrap];
    
    size.width += (padding_left/2);
    
    UIImage* bgImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth  topCapHeight:topCapHeight];
    
    //label.frame = CGRectMake(p.x, p.y, size.width, size.height);
    label.text = text;
    label.font = font;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    //[label sizeToFit];
    [label setFrame:CGRectMake(leftPadding, topPadding - 2, size.width, size.height)];
    label.textColor = textColor;
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    
    
    CGRect rect = CGRectMake( 0,
                             0,
                             32,
                             label.frame.size.height);
    
    [bgImageView setFrame:rect];
    
    [bgImageView addSubview:label];
    
    return bgImageView;
}

- (void) setNotification:(int)nNotifications
{
    if(nNotifications > 0)
    {
        NSString* text = [NSString stringWithFormat:@"+%d",nNotifications ];
        if(notificationImageView == nil)
        {
            notificationImageView =[ menuCell getLabelWithBackground:text
                                                           textColor:[UIColor whiteColor]
                                                           imageName:@"pink.png"
                                                        leftCapWidth:9
                                                        topCapHeight:9
                                                         leftPadding:padding_left
                                                          topPadding:padding_top];
            CGPoint point = notificationView.frame.origin;
            CGRect rect = notificationImageView.frame;
            rect = CGRectMake( point.x, point.y, rect.size.width, rect.size.height);
            
            [notificationImageView setFrame:rect];
            
            [view addSubview:notificationImageView];
        }
        else
        {
            UILabel *label = [notificationImageView.subviews objectAtIndex:0];
            label.text = text;
        }
        
    }
    else
    {
        if(notificationImageView != nil)
            notificationImageView.hidden = YES;
    }
    

}

@end