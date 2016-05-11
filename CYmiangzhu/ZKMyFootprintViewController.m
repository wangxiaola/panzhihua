//
//  ZKMyFootprintViewController.m
//  CYmiangzhu
//
//  Created by 汤亮 on 15/12/17.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKMyFootprintViewController.h"
#import "ZKFootprintModel.h"
#import "ZKFootprintCell.h"
#import "ZKFootprintEditCell.h"
#import "ZKFootprintHeader.h"
#import "ZKWriteFootprintViewController.h"

@interface ZKMyFootprintViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *cacheFilename;
@property (nonatomic, strong) NSMutableArray<ZKFootprintModel *> *footprintModels;

@end

@implementation ZKMyFootprintViewController

-(id)init
{
    self =[super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (NSString *)cacheFilename
{
   return @"MyFootprintLine.data";
}

- (NSMutableArray<ZKFootprintModel *> *)footprintModels
{
    if (_footprintModels== nil) {
        _footprintModels = [NSMutableArray array];
    }
    return _footprintModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarView.hidden = YES;
    [self setupTableView];
    [self readDataFromSandBox];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)readDataFromSandBox
{
    NSMutableArray *cacheModels = [NSKeyedUnarchiver unarchiveObjectWithFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
    self.footprintModels = cacheModels;
    [self.tableView reloadData];
    [self fetchMyFootprintData];
}

- (void)fetchMyFootprintData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"myFootprint";
    params[@"memberid"] = [ZKUserInfo sharedZKUserInfo].ID;
    [SVProgressHUD showWithStatus:@"更新中..."];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];
        self.footprintModels = [ZKFootprintModel objectArrayWithKeyValuesArray:responseObj[@"rows"]];
        [self.tableView reloadData];
        [NSKeyedArchiver archiveRootObject:self.footprintModels toFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
    }];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentMode = UIViewContentModeCenter;
    tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:tableView.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"footprint_bg"];
    tableView.backgroundView = backgroundImageView;
    
    ZKFootprintHeader *tableHeader = [ZKFootprintHeader footprintHeader];
    tableHeader.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    tableHeader.addFootprintCallback = ^{
        UIStoryboard *writeFootprintSB = [UIStoryboard storyboardWithName:@"MyZuji" bundle:nil];
        ZKWriteFootprintViewController *writeFootprintVc = [writeFootprintSB instantiateInitialViewController];
        writeFootprintVc.succeedUploadCallback = ^{
            [weakSelf fetchMyFootprintData];
        };
        [weakSelf.navigationController pushViewController:writeFootprintVc animated:YES];
    };
    tableView.tableHeaderView = tableHeader;
    
    [tableView registerNib:[UINib nibWithNibName:@"ZKFootprintCell" bundle:nil] forCellReuseIdentifier:ZKFootprintCellID];
    [tableView registerNib:[UINib nibWithNibName:@"ZKFootprintEditCell" bundle:nil] forCellReuseIdentifier:ZKFootprintEditCellID];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self loadHeaderImage];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, 14, 22);
    backButton.center = CGPointMake(20, 35);
    [backButton setImage:[UIImage imageNamed:@"backimage_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)loadHeaderImage
{
    UIImage * headImage = [ZKUtil fetchImage:[ZKUserInfo sharedZKUserInfo].ID];
    ZKFootprintHeader *tableHeaderView = (ZKFootprintHeader *)self.tableView.tableHeaderView;
    if (headImage) {
        [tableHeaderView setHeadImage:[UIImage circleImageWithImage:headImage borderWidth:0 borderColor:[UIColor whiteColor]]];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[ZKUserInfo sharedZKUserInfo].photo]];
            UIImage * image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageData) {
                    [tableHeaderView setHeadImage:[UIImage circleImageWithImage:image borderWidth:0 borderColor:[UIColor whiteColor]]];
                    [ZKUtil setPhotoToPath:UIImagePNGRepresentation(image) isName:[ZKUserInfo sharedZKUserInfo].ID];
                }
            });
        });
    }
}

- (void)deleteFootprintWithIndexPath:(NSIndexPath *)indexPath
{
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"delFootprint";
    params[@"footprintid"] = model.ID;
    [SVProgressHUD showWithStatus:@"删除中"];
    [ZKHttp Post:@"" params:params success:^(id responseObj) {
        
        if ([responseObj[@"state"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [self.footprintModels removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [NSKeyedArchiver archiveRootObject:self.footprintModels toFile:[kDocumentPath stringByAppendingPathComponent:self.cacheFilename]];
        }else {
            [SVProgressHUD showSuccessWithStatus:responseObj[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"网络出错"];
    }];
}

- (void)modifyFootprintWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *writeFootprintSB = [UIStoryboard storyboardWithName:@"MyZuji" bundle:nil];
    ZKWriteFootprintViewController *writeFootprintVc = [writeFootprintSB instantiateInitialViewController];
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    writeFootprintVc.footprintModel = model;
    __weak typeof(self) weakSelf = self;
    writeFootprintVc.succeedUploadCallback = ^{
        [weakSelf fetchMyFootprintData];
    };
    [weakSelf.navigationController pushViewController:writeFootprintVc animated:YES];
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.footprintModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    UITableViewCell *cell = nil;
    if (model.isEditing) {
        cell = [tableView dequeueReusableCellWithIdentifier:ZKFootprintEditCellID];
        __weak typeof(self) weakSelf = self;
        ((ZKFootprintEditCell *)cell).editFootprintCallback = ^(ZKEditOperation op) {
            if (op == ZKEditOperationDelete) {
                [weakSelf deleteFootprintWithIndexPath:indexPath];
            }else if (op == ZKEditOperationModify) {
                [weakSelf modifyFootprintWithIndexPath:indexPath];
            }
        };
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:ZKFootprintCellID];
        ((ZKFootprintCell *)cell).footprintModel = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    return model.isEditing ? 44 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    return model.isEditing ? 44 : 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKFootprintModel *model = self.footprintModels[indexPath.row];
    model.editing = !model.isEditing;
    [self.tableView reloadData];
}

@end
