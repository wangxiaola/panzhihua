//
//  ZKSelectListView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/18.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSearchBar.h"

@interface ZKSelectListView : UIView<UISearchBarDelegate>
/**
 *  选择view
 *
 *  @param frame
 *  @param mpArray    门票选择数组
 *
 *  @return view
 */
- (instancetype)initWithFrame:(CGRect)frame mpArray:(NSArray*)data;



@end
