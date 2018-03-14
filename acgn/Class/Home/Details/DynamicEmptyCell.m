//
//  DynamicEmptyCell.m
//  acgn
//
//  Created by lijian on 2018/2/23.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "DynamicEmptyCell.h"

@interface DynamicEmptyCell ()
@property (nonatomic, strong)EmptyView *emptyView;
@end

@implementation DynamicEmptyCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    [self addSubview:self.emptyView];
}

- (EmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth, 250) delegate:nil];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [_emptyView updateInfo:@"comment_null" title:@"你有可能成为意见领袖，快下手" btnTitle:@""];
        self.emptyView.hidden = NO;
        self.emptyView.topImageView.alpha = .5;
    }
    return _emptyView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
