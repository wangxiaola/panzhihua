//
//  ZKCommentViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"

@class ZKscenicSpotList, UIKeyboardViewController;
/**
 *  评价
 */
typedef void(^evaluat)();


@interface ZKCommentViewController : ZKSuperViewController
{
    
    UIKeyboardViewController *keyBoardController;
}

-(id)initData:(ZKscenicSpotList *)list;


-(void)succeed:(void(^)())evalual;

@end
