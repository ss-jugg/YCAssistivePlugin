//
//  YCAssistiveFunctionCell.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistiveFunctionCell.h"
#import <Masonry/Masonry.h>
#import "YCAssistiveFunctionModel.h"
#import "UIImage+AssistiveBundle.h"
#import "UIColor+AssistiveColor.h"
#import "UIFont+AssistiveFont.h"

@interface YCAssistiveItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLbl;

- (void)bindModel:(YCAssistiveFunctionModel *)model;

@end

@interface YCAssistiveFunctionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) YCAssistiveFunctionViewModel *viewModel;

@end

@implementation YCAssistiveFunctionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLbl];
        [self.bgView addSubview:self.collectView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 10, 0, 10));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(14);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
            make.leading.offset(14);
            make.trailing.offset(-14);
            make.bottom.equalTo(self.bgView);
        }];
    }
    return self;
}

+ (CGFloat)heightForCell:(YCAssistiveFunctionViewModel *)model {
    
    NSInteger count = model.functionModels.count / 4;
    NSInteger num = model.functionModels.count % 4 > 0 ? 1 : 0;
    CGFloat space = 8 * (count + num - 1);
    return 20+10+20+8+64*(count+num)+space+8;
}

- (void)bindFunctionModel:(YCAssistiveFunctionViewModel *)model {
    
    self.titleLbl.text = model.title;
    self.viewModel = model;
    [self.collectView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.functionModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YCAssistiveItemCell" forIndexPath:indexPath];
    YCAssistiveFunctionModel *model = self.viewModel.functionModels[indexPath.item];
    [cell bindModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YCAssistiveFunctionModel *model = self.viewModel.functionModels[indexPath.item];
    if ([model.plugin respondsToSelector:@selector(pluginDidLoad)]) {
        [model.plugin pluginDidLoad];
    }
    if ([model.plugin respondsToSelector:@selector(pluginDidLoad:)]) {
        [model.plugin pluginDidLoad:nil];
    }
}

#pragma mark - getter
- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor as_cellColor];
        _bgView.layer.cornerRadius = 4.0;
    }
    return _bgView;
}

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont as_15_bold];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}

- (UICollectionView *)collectView {
    
    if (!_collectView) {
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.backgroundColor = [UIColor clearColor];
        [_collectView registerClass:[YCAssistiveItemCell class] forCellWithReuseIdentifier:@"YCAssistiveItemCell"];
    }
    return _collectView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(64, 64);
        _flowLayout.minimumLineSpacing = 8;
        _flowLayout.minimumInteritemSpacing = (CGRectGetWidth([UIScreen mainScreen].bounds) - 64*4 - 48)/4;
    }
    return _flowLayout;
}

@end

@implementation YCAssistiveItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.titleLbl];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(8);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.iconImgView.mas_bottom).offset(4);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (void)bindModel:(YCAssistiveFunctionModel *)model {
    
    self.titleLbl.text = model.name;
    self.iconImgView.image = [UIImage as_imageWithName:model.imageName];
}

- (UIImageView *)iconImgView {
    
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont as_11];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}
@end
