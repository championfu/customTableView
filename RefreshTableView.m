//
//  RefreshTableView.m
//  智慧工地
//
//  Created by Fuqingping on 2017/4/13.
//  Copyright © 2017年 ESCST. All rights reserved.
//

#import "RefreshTableView.h"

@interface RefreshTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSMutableDictionary *paramters;
@property (nonatomic,strong) NSString *cellClassName;
@property (nonatomic,strong) NSString *modelClassName;
@property (nonatomic,strong) NSString *cellModelName;
@end

@implementation RefreshTableView

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(instancetype)initWithRequestUrl:(NSString *)url paramters:(NSMutableDictionary *)paramters cellClassName:(NSString *)cellClassName modelClassName:(NSString *)modelClassName cellModelName:(NSString *)cellModelName{
    if (self = [super init]) {
        _url = url;
        _paramters = paramters;
        _cellClassName = cellClassName;
        _modelClassName = modelClassName;
        _cellModelName = cellModelName;
        self.backgroundColor = TableBackgroundColor;
        [self registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:@"Cell"];
        self.estimatedRowHeight = 100.f;
        self.delegate = self;
        self.dataSource = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _page = 1;
            [self loadData];
        }];
        self.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
        }];
    }
    return self;
}

-(void)setPageable:(BOOL)pageable{
    if (pageable) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _page++;
            [self loadData];
        }];
    }else{
        self.mj_footer = nil;
    }
}

/**
 这个我为适应自己的接口为XMCenter写了个分类，可以使用自己的网络库
 */
- (void)loadData{
    [XMCenter sendNormalRequest:^(XMRequest * _Nonnull request) {
        
        request.api = [NSString uuidRequestPathWithPath:_url];//这个方法是我的项目获取接口全路径的方法，可以忽略。
        request.requestSerializerType = kXMRequestSerializerJSON;
        [_paramters setObject:@(_page) forKey:@"page"];
        request.parameters = _paramters;
    } onSuccessBlock:^(id  _Nullable responseObject) {
        NSArray *dataArray = [NSClassFromString(_modelClassName) mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        if (_page == 1) {
            [self.dataArray removeAllObjects];
        }
        if (dataArray.count < 10) {
            self.mj_footer.hidden = YES;
        }else{
            self.mj_footer.hidden = NO;
        }
        [self.dataArray addObjectsFromArray:dataArray];
        
        [self reloadData];
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    } onFailure:^(NSError * _Nullable error) {
        [self.mj_header endRefreshing];
        [self.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setValue:self.dataArray[indexPath.row] forKey:_cellModelName];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_refreshDelegate&&[_refreshDelegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)]) {
        [_refreshDelegate refreshTableView:(RefreshTableView *)tableView didSelectRowAtIndexPath:indexPath];
    }
}




@end
