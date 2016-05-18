//
//  ZKSelectListView.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/18.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKSelectListView.h"


@implementation ZKSelectListView
{

    NSArray * _titisArray;
    NSMutableArray * _flotWArray;
    YYSearchBar * _searchBar;
    UIScrollView * _scollView;
    float _scollW;
    BOOL  _isMp;
    NSMutableArray * _mpButtonArray;
    NSMutableArray * _qtButtonArray;
}



- (instancetype)initWithFrame:(CGRect)frame mpArray:(NSArray*)data;
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = TabelBackCorl;
        _titisArray = data;
        _searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(10, 5, kDeviceWidth-20, 26)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.placeString = @"酒店宾馆";
        _searchBar.isWeeter = YES;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.cornerRadius = 18;
        _searchBar.userInteractionEnabled = YES;
        [self addSubview:_searchBar];
        
        if (data.count > 0) {
            //门票
            _isMp = YES;
            _flotWArray = [NSMutableArray arrayWithCapacity:data.count];
            _scollW = 0.0f;
            _mpButtonArray = [NSMutableArray arrayWithCapacity:data.count];
            
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString * str = obj;
                float w = [self labelCgsizeFlot:13 Titis:str];
                _scollW = _scollW + w;
                //添加所有的字符宽度
                [_flotWArray addObject:[NSString stringWithFormat:@"%f",w]];
                
            }];
            _scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,frame.size.height - 30, kDeviceWidth, 30)];
            _scollView.backgroundColor = [UIColor whiteColor];
            _scollView.contentOffset =CGPointMake(0, 0);
            _scollView.contentSize =CGSizeMake(_scollW+(data.count+1)*8,0);
            _scollView.showsHorizontalScrollIndicator =NO;
            [self addSubview:_scollView];
            
            float addW = 0;
            for (int i = 0 ; i < data.count; i++) {
                
                float w = [_flotWArray[i] doubleValue];
                
                
                UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(6+addW+6*i,7.5, w, 15)];
                titleButton.backgroundColor = [UIColor whiteColor];
                [titleButton setTitle:data[i] forState:UIControlStateNormal];
                titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
                titleButton.tag = i;
                titleButton.layer.masksToBounds = YES;
                titleButton.layer.cornerRadius = 9;
                titleButton.layer.borderColor = YJCorl(251, 86, 7).CGColor;
                titleButton.layer.borderWidth = 0.5;
                [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
                [_scollView addSubview:titleButton];
                [_mpButtonArray addObject:titleButton];
                addW = addW + w;
            }
            
              [self selectBtton:0];
            
        }
        else
        {
            //其它
            _isMp = NO;
            NSArray * listArray = @[@"全部",@"按价格",@"按距离",@"筛选"];
            _qtButtonArray = [NSMutableArray arrayWithCapacity:4];
            float buttonW = kDeviceWidth/4;
            
            for (int i = 0; i<4; i++)
            {
                
                UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonW*i,frame.size.height - 30, buttonW, 30)];
                titleButton.backgroundColor = [UIColor whiteColor];
                [titleButton setImage:[UIImage imageNamed:@"feature_x_D"] forState:UIControlStateNormal];
                [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0,buttonW-18, 0, 0)];
                [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
                [titleButton setTitle:listArray[i] forState:UIControlStateNormal];
                [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
                titleButton.tag = i;
                [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:titleButton];
                [_qtButtonArray addObject:titleButton];
                
                if (i < 3)
                {
                    UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(buttonW-0.5, 10, 0.5, 30-20)];
                    lin.backgroundColor = TabelBackCorl;
                    [titleButton addSubview:lin];
                    
                }
              
            }
            
            [self selectBtton:0];
        }
        
    }

    return self;
}



/**
 *  选择那个
 *
 *  @param index tag
 */
- (void)selectBtton:(NSInteger)index
{

    if (_isMp == YES)
    {
        
        [_mpButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *bty = obj;
            
            bty.backgroundColor = idx == index ? YJCorl(251, 86, 7):[UIColor whiteColor];
            UIColor *titiColor  = idx == index ? [UIColor whiteColor]:[UIColor orangeColor];
            [bty setTitleColor:titiColor forState:UIControlStateNormal];
        }];
    }
    else
    {
    
        [_qtButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *bty = obj;
            UIColor *titiColor  = idx == index ? CYBColorGreen:[UIColor grayColor];
            [bty setTitleColor:titiColor forState:UIControlStateNormal];
        }];
        
    
    }
}
#pragma mark 点击事件
- (void)titleClick:(UIButton*)sender
{
    
    [self selectBtton:sender.tag];
    
}

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [_searchBar resignFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
    
}



//返回label状态
- (float)labelCgsizeFlot:(float)flot Titis:(NSString*)str
{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:flot]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.width + 18;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
