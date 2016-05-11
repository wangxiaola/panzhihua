//
//  ZKMainTypeView.h
//  CYmiangzhu
//
//  Created by 王小腊 on 15/12/11.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKMainTypeViewDelegate <NSObject>

-(void)selectTypeIndex:(NSInteger)index;

@end

@interface ZKMainTypeView : UIView

@property (nonatomic,weak) id<ZKMainTypeViewDelegate >delegate;

-(id)initFrame:(CGRect)frame filters:(NSArray *)filters;


-(void)selectToIndex:(NSInteger)index;

@end
