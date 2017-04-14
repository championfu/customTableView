//
//  RefreshBaseTableView.m
//  智慧工地
//
//  Created by Fuqingping on 2017/4/14.
//  Copyright © 2017年 ESCST. All rights reserved.
//

#import "RefreshBaseTableView.h"

@interface RefreshBaseTableView()
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSMutableDictionary *paramters;
@property (nonatomic,strong) NSString *modelClassName;
@property (nonatomic,strong) NSString *cellClassName;
@property (nonatomic,assign) NSInteger page;

@end

@implementation RefreshBaseTableView

-(instancetype)initWithRequstUrl:(NSString *)url paramters:(NSMutableDictionary *)paramters cellClassName:(NSString *)cellClassName modelClassName:(NSString *)modelClassName{
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        _reuseId = @"reuseId";
        _url = url;
        _paramters = paramters;
        _cellClassName = cellClassName;
        _modelClassName = modelClassName;
        self.backgroundColor = TableBackgroundColor;
        [self registerClass:NSClassFromString(_cellClassName) forCellReuseIdentifier:_reuseId];
        self.estimatedRowHeight = 100.f;
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
        
        request.api = [NSString uuidRequestPathWithPath:_url];
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


@end
