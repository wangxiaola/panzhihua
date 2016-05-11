//
//  ZKtextFieldThinkView.h
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/7/10.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKAppDelegate.h"

@protocol ZKtextFieldThinkViewDelegate <NSObject>

-(void)indexthink:(NSString*)str;


@end
@interface ZKtextFieldThinkView : UIView<UITableViewDataSource,UITableViewDelegate>



@property(nonatomic,strong)UITableView *tabel;


@property(nonatomic,assign)id<ZKtextFieldThinkViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame;

/**
 *  跟新数据
 *
 *  @param pc 数据
 */
-(void)updata:(NSString*)pc;

/**
 *  出现
 */
-(void)show;
/**
 *  消失
 */
-(void)hideButtonClick;

@end
