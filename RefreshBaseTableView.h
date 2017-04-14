//
//  RefreshBaseTableView.h
//  智慧工地
//
//  Created by Fuqingping on 2017/4/14.
//  Copyright © 2017年 ESCST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshBaseTableView : UITableView
@property (nonatomic,readonly) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL pageable;
@property (nonatomic,readonly) NSString *reuseId;

-(instancetype)initWithRequstUrl:(NSString *)url paramters:(NSMutableDictionary *)paramters cellClassName:(NSString *)cellClassName modelClassName:(NSString *)modelClassName;
@end
