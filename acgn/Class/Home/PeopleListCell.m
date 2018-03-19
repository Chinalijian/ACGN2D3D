//
//  PeopleListCell.m
//  acgn
//
//  Created by lijian on 2018/2/6.
//  Copyright © 2018年 Jian LI. All rights reserved.
//

#import "PeopleListCell.h"

@interface PeopleListCell ()

@end

@implementation PeopleListCell

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

- (void)configPeopleInfo:(PeopleDataModel *)objL objRight:(PeopleDataModel *)objR {
    if (!OBJ_IS_NIL(objL)) {
//        NSString * imageUrl = [objL.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        [self.leftView.peopleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_Placeholder_Image];
//        [self.leftView.peopleImageView sd_setImageWithURL:[NSURL URLWithString:objL.imageUrl] placeholderImage:Default_Placeholder_Image];
        [ATools loadImageUrlForImageView:self.leftView.peopleImageView imageUrl:objL.imageUrl];
        self.leftView.nameLabel.text = objL.userName;
        self.leftView.titleLabel.text = objL.source;
        self.leftView.fansLabel.text = [NSString stringWithFormat:@"粉丝：%@", objL.fansNum];
        
        self.leftView.lineLabel.hidden = NO;
        if (objL.isSelected) {
            self.leftView.selectedImageView.image = [UIImage imageNamed:@"selected_people_icon_red"];
        } else {
            self.leftView.selectedImageView.image = [UIImage imageNamed:@"selected_people_icon_grey"];
        }
    } else {
        [self.leftView.peopleImageView setImage:nil];
        self.leftView.nameLabel.text = @"";
        self.leftView.titleLabel.text = @"";
        self.leftView.fansLabel.text = @"";
        self.leftView.selectedImageView.image = nil;
        self.leftView.lineLabel.hidden = YES;
    }
    if (!OBJ_IS_NIL(objR)) {
        
//        NSString * imageUrl = [objR.imageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        [self.rightView.peopleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Default_Placeholder_Image];
        
        //[self.rightView.peopleImageView sd_setImageWithURL:[NSURL URLWithString:objR.imageUrl] placeholderImage:Default_Placeholder_Image];
        
        [ATools loadImageUrlForImageView:self.rightView.peopleImageView imageUrl:objR.imageUrl];
        self.rightView.nameLabel.text = objR.userName;
        self.rightView.titleLabel.text = objR.source;
        self.rightView.fansLabel.text = [NSString stringWithFormat:@"粉丝：%@", objR.fansNum];
        
        self.rightView.lineLabel.hidden = NO;
        if (objR.isSelected) {
            self.rightView.selectedImageView.image = [UIImage imageNamed:@"selected_people_icon_red"];
        } else {
            self.rightView.selectedImageView.image = [UIImage imageNamed:@"selected_people_icon_grey"];
        }
    } else {
        [self.rightView.peopleImageView setImage:nil];
        self.rightView.nameLabel.text = @"";
        self.rightView.titleLabel.text = @"";
        self.rightView.fansLabel.text = @"";
        self.rightView.selectedImageView.image = nil;
        self.rightView.lineLabel.hidden = YES;
    }
    
}

- (void)loadUI {
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
}

- (PeopleSubView *)leftView {
    if (_leftView == nil) {
        _leftView = [[PeopleSubView alloc] initWithFrame:CGRectMake(0, 0, DMScreenWidth/2, People_List_Cell_H)];
        _leftView.backgroundColor = [UIColor whiteColor];
    }
    return _leftView;
}

- (PeopleSubView *)rightView {
    if (_rightView == nil) {
        _rightView = [[PeopleSubView alloc] initWithFrame:CGRectMake(DMScreenWidth/2, 0, DMScreenWidth/2, People_List_Cell_H)];
        _rightView.backgroundColor = [UIColor whiteColor];
    }
    return _rightView;
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
