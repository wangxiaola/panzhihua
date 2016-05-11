//
//  ZKBaseTableViewController.h
//  CYmiangzhu
//
//  Created by 汤亮 on 15/8/25.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define navigationHeghit self.navigationBarView.frame.size.height
#define TabelHeghit self.view.frame.size.height - self.navigationBarView.frame.size.height

#define buttonItemWidth 40
#define navHeight 64.0

@interface ZKBaseTableViewController : UITableViewController

@property(strong,nonatomic)UIView * navigationBarView;

@property(strong,nonatomic)UIButton *leftBarButtonItem;

@property(strong,nonatomic)UIButton *rittBarButtonItem;

@property(strong,nonatomic)UILabel *titeLabel;


@end
