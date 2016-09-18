//
//  PYMutilEchartsController.m
//  iOS-Echarts
//
//  Created by Pluto Y on 7/28/16.
//  Copyright © 2016 pluto-y. All rights reserved.
//

#import "MultiEchartsController.h"
#import "EchartsViewCell.h"

static NSString *const tableViewIdentifier = @"EchartsViewCell";

@interface MultiEchartsController ()<UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MultiEchartsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.title = @"多图表";
    [_tableView registerNib:[UINib nibWithNibName:tableViewIdentifier bundle:nil] forCellReuseIdentifier:tableViewIdentifier];
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EchartsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier forIndexPath:indexPath];
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i<11; i++) {
        NSNumber * num = [NSNumber numberWithInt:rand()%30+3];
        [arr addObject:num];
    }
    PYOption *option = [self obtainStandardLineOption:arr];
    [cell.echartView setOption:option];
    [cell.echartView loadEcharts];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

/**
 *  标准折线图
 */
- (PYOption *)obtainStandardLineOption:(NSArray * )arr {
//    NSMutableArray * arr = [NSMutableArray array];
//    for (int i = 0; i<11; i++) {
//        NSNumber * num = [NSNumber numberWithInt:rand()%30+3];
//        NSLog(@"%@",num);
//        [arr addObject:num];
//    }
//    NSLog(@"%@",arr);
    PYOption *option = [[PYOption alloc] init];
    PYTitle *title = [[PYTitle alloc] init];
    title.text = @"未来一周气温变化";
    title.subtext = @"纯属虚构";
    option.title = title;
    PYTooltip *tooltip = [[PYTooltip alloc] init];
    tooltip.trigger = @"axis";
    option.tooltip = tooltip;
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);
    grid.x2 = @(50);
    option.grid = grid;
    PYLegend *legend = [[PYLegend alloc] init];
    legend.data = @[@"最高温度",@"最低温度"];
    option.legend = legend;
    PYToolbox *toolbox = [[PYToolbox alloc] init];
    toolbox.show = YES;
    toolbox.x = @"right";
    toolbox.y = @"top";
    toolbox.z = @(100);
    toolbox.feature.mark.show = YES;
    toolbox.feature.dataView.show = YES;
    toolbox.feature.dataView.readOnly = NO;
    toolbox.feature.magicType.show = YES;
    toolbox.feature.magicType.type = @[@"line", @"bar"];
    toolbox.feature.restore.show = YES;
    toolbox.feature.saveAsImage.show = YES;
    option.toolbox = toolbox;
    option.calculable = YES;
    PYAxis *xAxis = [[PYAxis  alloc] init];
    xAxis.type = @"category";
    xAxis.boundaryGap = @(NO);
    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    yAxis.axisLabel.formatter = @"{value} ℃";
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    PYSeries *series1 = [[PYSeries alloc] init];
    series1.name = @"最高温度";
    series1.type = @"line";
    series1.data = arr;//@[@33,@4,@11,@13,@22,@3,@15];
    PYMarkPoint *markPoint = [[PYMarkPoint alloc] init];
    markPoint.data = @[@{@"type" : @"max", @"name": @"最大值"},@{@"type" : @"min", @"name": @"最小值"}];
    series1.markPoint = markPoint;
    PYMarkLine *markLine = [[PYMarkLine alloc] init];
    markLine.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series1.markLine = markLine;
    PYSeries *series2 = [[PYSeries alloc] init];
    series2.name = @"最低温度";
    series2.type = @"line";
    series2.data = @[@(1),@(-2),@(2),@(5),@(3),@(2),@(0)];
    PYMarkPoint *markPoint2 = [[PYMarkPoint alloc] init];
    markPoint2.data = @[@{@"value" : @(2), @"name": @"周最低", @"xAxis":@(1), @"yAxis" : @(-1.5)}];
    series2.markPoint = markPoint2;
    PYMarkLine *markLine2 = [[PYMarkLine alloc] init];
    markLine2.data = @[@{@"type" : @"average", @"name": @"平均值"}];
    series2.markLine = markLine2;
    option.series = [[NSMutableArray alloc] initWithObjects:series1, series2, nil];
    return option;
}

/**
 *  虫洞
 */
- (PYOption *)obtainWormholeOption {
    PYOption *option = [[PYOption alloc] init];
    option.tooltip = [[PYTooltip alloc] init];
    option.tooltip.trigger = @"axis";
    option.legend = [[PYLegend alloc] init];
    option.legend.data = @[@"邮件营销",@"联盟广告",@"视频广告",@"直接访问",@"搜索引擎"];
    PYGrid *grid = [[PYGrid alloc] init];
    grid.x = @(40);
    grid.x2 = @(50);
    option.grid = grid;
    option.toolbox = [[PYToolbox alloc] init];
    option.toolbox.show = YES;
    option.toolbox.feature = [[PYToolboxFeature alloc] init];
    option.toolbox.feature.mark = [[PYToolboxFeatureMark alloc] init];
    option.toolbox.feature.mark.show = YES;
    option.toolbox.feature.dataView = [[PYToolboxFeatureDataView alloc] init];
    option.toolbox.feature.dataView.show = YES;
    option.toolbox.feature.dataView.readOnly = NO;
    option.toolbox.feature.magicType = [[PYToolboxFeatureMagicType alloc] init];
    option.toolbox.feature.magicType.show = YES;
    option.toolbox.feature.magicType.type = @[PYSeriesTypeLine, @"bar", @"stack", @"tiled"];
    option.toolbox.feature.restore = [[PYToolboxFeatureRestore alloc] init];
    option.toolbox.feature.restore.show = YES;
    option.toolbox.feature.saveAsImage = [[PYToolboxFeatureSaveAsImage alloc] init];
    option.toolbox.feature.saveAsImage.show = YES;
    option.calculable = YES;
    PYAxis *xAxis = [[PYAxis alloc] init];
    xAxis.type = @"category";
    xAxis.boundaryGap = @(NO);
    xAxis.data = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
    PYAxis *yAxis = [[PYAxis alloc] init];
    yAxis.type = @"value";
    option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
    NSMutableArray *serieses = [[NSMutableArray alloc] init];
    PYCartesianSeries *series1 = [[PYCartesianSeries alloc] init];
    series1.name = @"邮件营销";
    series1.type = PYSeriesTypeLine;
    series1.stack = @"总量";
    series1.itemStyle = [[PYItemStyle alloc] init];
    series1.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series1.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series1.itemStyle.normal.areaStyle.color = @" (function (){var zrColor = require('zrender/tool/color');return zrColor.getLinearGradient(0, 200, 0, 400,[[0, 'rgba(255,0,0,0.8)'],[0.8, 'rgba(255,255,255,0.1)']])})()";
    series1.data = @[@(120),@(132),@(101),@(134),@{@"value":@(90), @"symbol":@"droplet", @"symbolSize":@(5)},@(230),@(210)];
    [serieses addObject:series1];
    PYCartesianSeries *series2 = [[PYCartesianSeries alloc] init];
    series2.name = @"联盟广告";
    series2.type = PYSeriesTypeLine;
    series2.stack = @"总量";
    series2.smooth = YES;
    series2.symbol = @"image://../asset/ico/favicon.png";
    series2.symbolSize = @(8);
    series2.itemStyle = [[PYItemStyle alloc] init];
    series2.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series2.itemStyle.normal.areaStyle = [[PYAreaStyle alloc] init];
    series2.itemStyle.normal.areaStyle.type = @"default";
    series2.data = @[@(120), @(82), @{@"value":@(201), @"symbol":@"start", @"symbolSize":@(15),@"itemStyle":@{@"normal":@{@"label":@{@"show":@(YES),@"textStyle":@{@"fontSize":@(20),@"fontFamily":@"微软雅黑",@"fontWeight":@"bold"}}}}}, @{@"value":@(134),@"symbol":@"none"}, @(190), @{@"value":@(230),@"symbol":@"emptypin",@"symbolSize":@(8)}, @(110)];
    [serieses addObject:series2];
    PYCartesianSeries *series4 = [[PYCartesianSeries alloc] init];
    series4.name = @"直接访问";
    series4.type = PYSeriesTypeLine;
    series4.stack = @"总量";
    series4.symbol = @"arrow";
    series4.symbolSize = @(6);
    series4.symbolRotate = @(-45);
    series4.itemStyle = [[PYItemStyle alloc] init];
    series4.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series4.itemStyle.normal.color = PYRGBA(255, 0, 0, 1);
    series4.itemStyle.normal.lineStyle = [[PYLineStyle alloc] init];
    series4.itemStyle.normal.lineStyle.width = @(2);
    series4.itemStyle.normal.lineStyle.type = @"dashed";
    series4.itemStyle.emphasis = [[PYItemStyleProp alloc] init];
    series4.itemStyle.emphasis.color = PYRGBA(0, 0, 255, 1);
    series4.data = @[@(320), @(332), @"-", @(334), @{@"value":@(390),@"symbol":@"star6",@"symbolSize":@(20),@"symbolRotate":@(10),@"itemStyle":@{@"normal":@{@"color":@"yellowgreen"},@"emphasis":@{@"color":@"orange",@"lable":@{@"show":@(YES),@"position":@"inside",@"textStyle":@{@"fontSize":@(20)}}}}}, @(330), @(320)];
    [serieses addObject:series4];
    PYCartesianSeries *series5 = [[PYCartesianSeries alloc] init];
    series5.name = @"搜索引擎";
    series5.type = PYSeriesTypeLine;
    series5.stack = @"总量";
    series5.symbol = @"emptyCircle";
    series5.itemStyle = [[PYItemStyle alloc] init];
    series5.itemStyle.normal = [[PYItemStyleProp alloc] init];
    series5.itemStyle.normal.lineStyle = [[PYLineStyle alloc] init];
    series5.itemStyle.normal.lineStyle.width = @(2);
    series5.itemStyle.normal.lineStyle.color = @"(function (){var zrColor = require('zrender/tool/color');return zrColor.getLinearGradient(0, 0, 1000, 0,[[0, 'rgba(255,0,0,0.8)'],[0.8, 'rgba(255,255,0,0.8)']])})()";
    series5.itemStyle.normal.lineStyle.shadowColor = PYRGBA(0, 0, 0, .5);
    series5.itemStyle.normal.lineStyle.shadowBlur = @(10);
    series5.itemStyle.normal.lineStyle.shadowOffsetX = @(8);
    series5.itemStyle.normal.lineStyle.shadowOffsetY = @(8);
    series5.itemStyle.emphasis = [[PYItemStyleProp alloc] init];
    series5.itemStyle.emphasis.label = [[PYLabel alloc] init];
    series5.itemStyle.emphasis.label.show = YES;
    series5.data = @[@(620), @(732), @(791), @{@"value":@(734),@"symbol":@"emptyHeart",@"symbolSize":@(10)}, @(890), @(930), @(820)];
    [serieses addObject:series5];
    [option setSeries:serieses];
    return option;
}


@end
