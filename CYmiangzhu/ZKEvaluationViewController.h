//
//  ZKEvaluationViewController.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/1/8.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKSuperViewController.h"
#import "ZKGoodsOneMode.h"
#import "UIKeyboardViewController.h"

/**
 *  评价
 */
typedef void(^evaluat)();


@interface ZKEvaluationViewController : ZKSuperViewController
{
    
    UIKeyboardViewController *keyBoardController;
}

-(id)initData:(ZKGoodsOneMode*)list;


-(void)succeed:(void(^)())evalual;

@end
