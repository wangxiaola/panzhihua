//
//  ZKCityPickerViewController.m
//  CYmiangzhu
//
//  Created by Daqsoft-Mac on 15/10/10.
//  Copyright © 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKCityPickerViewController.h"
#import "ZKCityGroup.h"
#import "ZKCity.h"
#import "ZKTopCityView.h"
#import "YYSearchBar.h"

static NSString *const ZKTableCityCellID = @"ZKTableCityCell";

@interface ZKCityPickerViewController ()<UITableViewDelegate, UITableViewDataSource, ZKTopCityViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong)NSArray *cityGroups;

@property (nonatomic, weak)YYSearchBar *searchBar;

@property (nonatomic, assign) BOOL searchBool;

@property (nonatomic, strong)NSMutableArray *cityArray;

@end

@implementation ZKCityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupSearchBar];
}



- (NSArray *)cityGroups
{
    if (_cityGroups == nil) {
        
     self.cityGroups = [ZKCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

#pragma mark - override
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化searchBar
- (void)setupSearchBar
{
    YYSearchBar *searchBar = [[YYSearchBar alloc] initWithFrame:CGRectMake(0, 0.0f, self.navigationBarView.frame.size.width-100, 60.0f)];
    searchBar.center =CGPointMake(self.navigationBarView.frame.size.width/2, self.navigationBarView.frame.size.height/2+5);
    searchBar.placeString = @"地名/城市名";
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.delegate = self;
    [self.navigationBarView addSubview:searchBar];
    self.searchBar = searchBar;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    self.cityArray =[NSMutableArray arrayWithCapacity:0];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight+20, self.view.bounds.size.width, self.view.bounds.size.height - navBarHeight - 20) style:UITableViewStylePlain];
    tableView.sectionIndexColor = YJCorl(51, 202, 171);
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    ZKTopCityView *header = [[ZKTopCityView alloc] initWithFrame:CGRectMake(0, 0, 0, 175)];
//    header.delegate = self;
//    header.cityGroup = self.cityGroups[0];
//    self.tableView.tableHeaderView = header;
}


#pragma mark - UITableviewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchBool == NO) {
        
         return self.cityGroups.count;
    }else{
    
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_searchBool == NO) {
        
        ZKCityGroup *group = self.cityGroups[section];
        return group.cities.count;
        
    }else{
        
        return self.cityArray.count;
    }

    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZKTableCityCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZKTableCityCellID];
    }
    

    
    if (_searchBool == NO) {
        
        ZKCityGroup *group =  self.cityGroups[indexPath.section];
        ZKCity *city = group.cities[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = SYSTEMFONT(13);
        cell.textLabel.text = city.title;
        
    }else{
        
        ZKCity *city = self.cityArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = SYSTEMFONT(13);
        cell.textLabel.text = city.title;
        
    }
    

    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (_searchBool == NO) {
        
        ZKCityGroup *group =  self.cityGroups[section];
        return group.sort;
        
    }else{
        
        return @"";
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    if (_searchBool == NO) {
        
        return 24;
        
    }else{
        
        return 0.1;
    }
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return [self.cityGroups valueForKeyPath:@"sort"];;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZKCity *city;
    
    if (_searchBool == NO) {
        
         ZKCityGroup *group =  self.cityGroups[indexPath.section];
        city =group.cities[indexPath.row];
    }else{
        
        city = self.cityArray[indexPath.row];
    }
    
    
    NSLog(@"title---%@, value---%@, hot---%@", city.title, city.value, city.hot);
    
    if ([self.delegate respondsToSelector:@selector(cityPickerViewController:didSelectedCity:)]) {
        [self.delegate cityPickerViewController:self didSelectedCity:city];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - UIScrollViewDelegate


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if (searchText.length == 0) {
        
        self.searchBool = NO;
        
        [_tableView reloadData];
        
        return;
    }
    
    
    [_cityArray removeAllObjects];
    
    NSLog(@"==+++++======++");

    for (int p = 0; p<self.cityGroups.count; p++) {
    
        ZKCityGroup *group = self.cityGroups[p];
        
        for (int i =0; i<group.cities.count; i++) {
            
            ZKCity *city = group.cities[i];
            
                NSLog(@" -- %@  -- %@",city.title,searchText);
            
            if ([city.title rangeOfString:searchText].location !=NSNotFound) {
                

                           NSLog(@" -- %@  ",self.cityArray);
                [self.cityArray addObject:city];
                  NSLog(@" -- %@  ",self.cityArray);
                
            }
            
            if (p ==self.cityGroups.count-1&&i ==group.cities.count-1) {
                
                
                NSLog(@" -- %@",_cityArray);
                _searchBool = YES;
                [_tableView reloadData];
                [self.searchBar resignFirstResponder];
                
            }
            
        }

        
    }
    

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
}

#pragma mark - ZKTopCityViewDelegate
//- (void)topCityView:(ZKTopCityView *)topCityView didSelectedCity:(NSString *)city
//{
//    NSLog(@"%@", city);
//    
//    if ([self.delegate respondsToSelector:@selector(cityPickerViewController:didSelectedCity:)]) {
//        [self.delegate cityPickerViewController:self didSelectedCity:city];
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];

//}

@end
