//
//  ZKWellcomeJTListViewController.m
//  CYmiangzhu
//
//  Created by 王小腊 on 16/5/13.
//  Copyright © 2016年 WangXiaoLa. All rights reserved.
//

#import "ZKWellcomeJTListViewController.h"
#import "ZKWellcomeJTMode.h"
#import "SDCycleScrollView.h"

#import "ZKLocationCallTableViewCell.h"
#import "ZKPictureTableViewCell.h"
#import "ZKPjHeaderView.h"
#import "ZKpjTableViewCell.h"
#import "ZKInforPjTableViewCell.h"

#import "ZKEvaluationViewController.h"
#import "ZKregisterViewController.h"
#import "ZKPhotoGalleryViewController.h"

@interface ZKWellcomeJTListViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic, strong) ZKWellcomeJTMode *list;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray * imageArray;//图片
@property (nonatomic, strong) NSMutableArray * titisArray;//文字
//评价个数
@property (nonatomic, assign) NSInteger pjPage;
//特色高度
@property (nonatomic, assign) NSInteger tsHeight;
//基地设施高度
@property (nonatomic, assign) NSInteger jtHeight;

//行数
@property (nonatomic, strong) NSMutableArray * titisNumbers;
@property (nonatomic, strong) NSArray *headerTitis;
@property (nonatomic, strong) NSArray *headerImages;

@end

@implementation ZKWellcomeJTListViewController
- (NSMutableArray *)titisNumbers
{
    
    if (!_titisNumbers) {
        
        _titisNumbers = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _titisNumbers;
}
- (NSMutableArray *)titisArray
{

    if (!_titisArray) {
        
        _titisArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _titisArray;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        
        // 网络加载 --- 创建带标题的图片轮播器
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 450/3) delegate:self placeholderImage:[UIImage imageNamed:@"errData"]];
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.pageControlDotSize =CGSizeMake(5, 5);
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView.bannerImageViewContentMode =  UIViewContentModeScaleAspectFill;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        
    }
    return _cycleScrollView;
}
- (UITableView *)tableView
{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = YJCorl(249, 249, 249);
        //去掉plain样式下多余的分割线
        _tableView.tableFooterView = [[UIView alloc] init];
        //设置分割线左边无边距，默认是15
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.estimatedRowHeight = 44; //预估行高 可以提高性能
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKLocationCallTableViewCell" bundle:nil] forCellReuseIdentifier:ZKLocationCallCellID];
        
        [_tableView registerNib:[UINib nibWithNibName:@"ZKPictureTableViewCell" bundle:nil] forCellReuseIdentifier:ZKPictureCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"ZKInforPjTableViewCell" bundle:nil] forCellReuseIdentifier:ZKInforPjCellID];
    }
    
    return _tableView;
    
}

- (instancetype)initData:(ZKWellcomeJTMode*)data;
{
    
    self = [super init];
    if (self) {
        
        self.list = data;
        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"康养基地详情";
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithIcon:@"shouchang_1" highIcon:@"shouchang_0" target:self action:@selector(collectClick)],[UIBarButtonItem itemWithIcon:@"fengxiang" highIcon:@"fengxiang" target:self action:@selector(sharedClick)]];
    
    [self jtInitSuperViews];
}
- (void)jtInitSuperViews
{
  
    self.pjPage = 1;
    self.tsHeight = 70;
    self.jtHeight = 70;
    self.headerTitis = @[@"720全景",@"基地特色",@"基地设施",@"图片基地",];
    self.headerImages = @[@"ky_cell_1",@"ky_cell_2",@"ky_cell_3",@"ky_cell_4"];
    [self.titisNumbers addObjectsFromArray:@[@"3",@"3",]];
    
    [self.imageArray addObject:[UIImage imageNamed:@"season_1.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_2.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_3.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_1.jpg"]];
    [self.imageArray addObject:[UIImage imageNamed:@"season_2.jpg"]];
    
    [self.titisArray addObject:@"不好说"];
    [self.titisArray addObject:@"投点钱"];
    [self.titisArray addObject:@"赚了100块"];
    [self.titisArray addObject:@"期限可期"];
    [self.titisArray addObject:@"太卡帕拉"];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.localizationImageNamesGroup = self.imageArray;
        self.cycleScrollView.titlesGroup = self.titisArray;
    });
    
    
    
}


#pragma  mark table 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5)
    {
        
            
       return self.pjPage+2;

     
    }
    else if (section == 2)
    {
        return 2;
    }
    else if (section == 3)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 0;
    }
    else
    {
        return 1;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 55;
            break;
        case 1:
            return 0.1;
            break;
        case 2:
            return indexPath.row == 0 ? self.tsHeight:30;
            break;
        case 3:
            return indexPath.row == 0 ? self.jtHeight:30;
            break;
        case 4: //图片高度
            return 260;
            break;
        case 5:
    
            if (indexPath.row == 0) {
                
                return 60;
            }
            else if (indexPath.row == self.pjPage+1)
            {
                return 30;
            }
            else
            {
                
                return UITableViewAutomaticDimension;
            }
            break;
        default:
            return 0;
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section ==0)
    {
        
        return 0.1;
    }
    else
    {
        return 44;
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        ZKLocationCallTableViewCell *locationcell = [tableView dequeueReusableCellWithIdentifier:ZKLocationCallCellID];
        cell = locationcell;
    }
    else if(indexPath.section == 2 ||indexPath.section == 3)
    {
        static NSString *indentfier = @"inforCell";
        cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
        }
        NSInteger index = [self.titisNumbers[indexPath.section-2] integerValue];
        cell.textLabel.numberOfLines = index;
        NSString * stateStr = [self.titisNumbers[indexPath.section-2] integerValue] == 3 ?@"查看全部介绍":@"收起部分介绍";
        cell.textLabel.text = indexPath.row == 0 ? @"一条“2016山东春季高考疑似泄题，语文和专业课全有答案”的消息在网络流传，引起社会关注。记者从山东省教育招生考试院获悉，目前招考院已经了解到个别考生关于怀疑考试泄题的情况，经过调查，泄题情况并不存在。招生工作关系到广大考生的切身利益，历来受到社会各界关注，招生考试部门将依法为考生创造公平公正的考试环境。":stateStr;
        if (indexPath.row == 1)
        {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = indexPath.row == 0 ? [UIColor blackColor]:CYBColorGreen;
    }
    else if (indexPath.section == 4)
    {
        
        ZKPictureTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:ZKPictureCellID];
        cell = pictureCell;
    }
    else if (indexPath.section == 5)
    {
    
 
        if (indexPath.row == 0) {
            
            static NSString *str = @"pjCell";
            
            ZKpjTableViewCell *pjCell = [tableView dequeueReusableCellWithIdentifier:str];
            
            if (!pjCell) {
                
                pjCell = [[ZKpjTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str listData:@[@"性价比高",@"环境优雅",@"干净卫生",@"清爽通风",@"土豪范",@"家电齐全",@"价格公道",@"娱乐设施很多",@"有点贵"]];
            }
            cell = pjCell;
            
        }
        else if (indexPath.row == self.pjPage+1)
        {
        
            static NSString *indentfier = @"inforCell";
            cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
            }
      
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            NSString * stateStr = self.pjPage == 1 ?@"查看全部3条评论":@"收起部分评论";
            cell.textLabel.text = stateStr;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = CYBColorGreen;

            
        }
        
        else
        {
        
            ZKInforPjTableViewCell *inforCell = [tableView dequeueReusableCellWithIdentifier:ZKInforPjCellID];
            cell = inforCell;
        
        }
    
    
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1 || section == 2||section == 3 ||section ==4)
    {
        
        NSString *headerSectionID = [NSString stringWithFormat:@"HeaderFooterView%ld",(long)section];
        
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
        
        UIImageView *lefImageView;
        UILabel *lefLabel;
        UIImageView *ritImageView;
        
        if (headerView == nil)
        {
            
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
            
            UIButton *backView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
            backView.backgroundColor = [UIColor whiteColor];
            [headerView addSubview:backView];
            backView.tag = section;
            [backView addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
            
            ritImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            ritImageView.image = [UIImage imageNamed:@"jt_Xright"];
            [headerView addSubview:ritImageView];
            
            [ritImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(6);
                make.height.mas_equalTo(12);
                make.centerY.mas_equalTo(headerView.mas_centerY);
                make.right.mas_equalTo(headerView.mas_right).offset(-10);
            }];
            
            
            
            lefImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [headerView addSubview:lefImageView];
            
            [lefImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.height.mas_equalTo(20);
                make.centerY.mas_equalTo(headerView.mas_centerY);
                make.left.mas_equalTo(headerView.mas_left).offset(8);
            }];
            
            
            lefLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            lefLabel.font = [UIFont systemFontOfSize:14];
            lefLabel.textColor = [UIColor blackColor];
            [headerView addSubview:lefLabel];
            [lefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lefImageView.mas_right).offset(8);
                make.width.offset(70);
                make.centerY.mas_equalTo(headerView.mas_centerY);
            }];
            
            UIView *linView = [[UIView alloc] init];
            linView.frame = CGRectMake(0, 43, kDeviceWidth, 1);
            linView.backgroundColor = YJCorl(241, 241, 241);
            [headerView addSubview:linView];
            
        }
        
        ritImageView.hidden = section == 1 ? NO:YES;
        NSString *str = self.headerTitis[section-1];
        lefImageView.image = [UIImage imageNamed:self.headerImages[section-1]];
        lefLabel.text = str;
        
        return headerView;
        
        
    }
    else if (section == 5)
    {
    
        NSString *headerSectionID = [NSString stringWithFormat:@"HeaderFooterView%ld",(long)section];
        
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
        
        if (headerView == nil)
        {
            
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerSectionID];
            ZKPjHeaderView *pjView = [[ZKPjHeaderView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
            __weak typeof(self)weekSelf =self;
            pjView.commentBlock = ^{
            
                [weekSelf pjNavController];
            };
            [headerView addSubview:pjView];
        }
        
        return headerView;
    }
    else
    {
        
        return [UIView new];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5)
    {
        
        if (indexPath.row == self.pjPage+1)
        {
            if (self.pjPage == 1)
            {
                
                self.pjPage = 3;
            }
            else
            {
                self.pjPage = 1;
            }
            NSIndexSet *index = [[NSIndexSet alloc] initWithIndex:5];
            [self.tableView reloadSections:index withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    if (indexPath.section == 2 || indexPath.section == 3) {
        
        NSString *str = @"一条“2016山东春季高考疑似泄题，语文和专业课全有答案”的消息在网络流传，引起社会关注。记者从山东省教育招生考试院获悉，目前招考院已经了解到个别考生关于怀疑考试泄题的情况，经过调查，泄题情况并不存在。招生工作关系到广大考生的切身利益，历来受到社会各界关注，招生考试部门将依法为考生创造公平公正的考试环境。";
        
        if (indexPath.row == 1) {
            
            
            float heighit = [self labelCgsizeFlot:14 Titis:str];
            
            NSInteger state = [self.titisNumbers[indexPath.section-2] integerValue];
            
            NSString *number = state == 3 ? @"0":@"3";
            
            [self.titisNumbers replaceObjectAtIndex:indexPath.section - 2 withObject:number];
            
            if (indexPath.section == 2)
            {
                self.tsHeight = state == 3 ? heighit:70;
                
            }
            else
            {
                self.jtHeight = state == 3 ? heighit:70;
            }

            [self.tableView reloadData];
            
        }
        
    }
    
}
//返回label状态
- (float)labelCgsizeFlot:(float)flot Titis:(NSString*)str
{
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:flot]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(kDeviceWidth-30, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height+10;
    
}
#pragma mark navigationItemClick
//收藏
- (void)collectClick
{
    
    
}
//分享
- (void)sharedClick
{
    
    
}

- (void)headerClick:(UIButton*)sender
{
    
    
}

- (void)pjNavController
{

    if ([self isTelnet] ==NO) {
        
        return;
    }

    ZKEvaluationViewController *vc =[[ZKEvaluationViewController alloc]initData:nil];
    [vc succeed:^{
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];

        [SVProgressHUD show];
        
        [ZKHttp Post:@"" params:info success:^(id responseObj) {
            
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismissWithError:@"网络出错了"];

        }];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  判断是否登录
 */
-(BOOL)isTelnet
{
    
//    if (!oneMode.name) {
//        
//        [self.view makeToast:@"正在加载数据,请稍等!"];
//        return NO;
//    }
    
    
    if (![ZKUserInfo sharedZKUserInfo].ID) {
        
        ZKregisterViewController *vc =[[ZKregisterViewController alloc]init];
        vc.isMy =YES;
        UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden =YES;
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
        
        return NO;
    }
    
    return YES;
}

#pragma mark SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    
    ZKPhotoGalleryViewController * photoVC =[[ZKPhotoGalleryViewController alloc]initImages:self.imageArray photoTitis:self.titisArray title:@"花芬基地"];
    [self.navigationController pushViewController:photoVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
