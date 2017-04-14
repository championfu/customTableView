//
//  RefreshTableView.m
//  智慧工地
//
//  Created by Fuqingping on 2017/4/13.
//  Copyright © 2017年 ESCST. All rights reserved.
//

#import "RefreshTableView.h"

@interface RefreshTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *cellModelName;
@end

@implementation RefreshTableView

-(instancetype)initWithRequestUrl:(NSString *)url paramters:(NSMutableDictionary *)paramters cellClassName:(NSString *)cellClassName modelClassName:(NSString *)modelClassName cellModelName:(NSString *)cellModelName{
    if (self = [super initWithRequstUrl:url paramters:paramters cellClassName:cellClassName modelClassName:modelClassName]) {
        _cellModelName = cellModelName;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseId forIndexPath:indexPath];
    
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
