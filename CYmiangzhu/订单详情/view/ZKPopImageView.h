//
//  ZKPopImageView.h
//  CYmiangzhu
//
//  Created by 小腊 on 16/5/17.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKPopImageView : UIView

-(instancetype)initImage:(UIImage*)image;

-(instancetype)initImageUrl:(NSString*)url;

-(void)show;

@end
