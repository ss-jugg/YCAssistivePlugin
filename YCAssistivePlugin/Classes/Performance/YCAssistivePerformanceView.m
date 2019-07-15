//
//  YCAssistivePerformanceView.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/15.
//

#import "YCAssistivePerformanceView.h"
#import <Masonry/Masonry.h>
#import "UIFont+AssistiveFont.h"
#import "YCAssistiveMemoryHelper.h"

@interface YCAssistivePerformanceView ()
{
    CADisplayLink *_displayLink;
    NSTimeInterval _lastTime;
    NSUInteger     _count;
}

/* fps */
@property (nonatomic, strong) UILabel *fpsLbl;
/* memory */
@property (nonatomic, strong) UILabel *memoryLbl;
/* cpu */
@property (nonatomic, strong) UILabel *cpuLbl;

@end
@implementation YCAssistivePerformanceView

- (instancetype)init {
    
    if (self = [super init]) {

        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:NO];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        [self addSubview:self.fpsLbl];
        [self.fpsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.leading.offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        [self addSubview:self.memoryLbl];
        [self addSubview:self.cpuLbl];
        [self.memoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(10);
            make.top.equalTo(self.fpsLbl.mas_bottom).offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
        [self.cpuLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.memoryLbl.mas_bottom).offset(10);
            make.leading.offset(10);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
        }];
    }
    return self;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count ++;
    NSTimeInterval interval = link.timestamp - _lastTime;
    if (interval < 1) {
        return;
    }
    float fps = _count / interval;
    _lastTime = link.timestamp;
    _count = 0;
    NSString *text = [NSString stringWithFormat:@"FPS：%d",(int)round(fps)];
    self.fpsLbl.text = text;
    self.memoryLbl.text = [NSString stringWithFormat:@"已用内存：%.2f MB\n\n可用内存：%.2f MB",[YCAssistiveMemoryHelper usedMemory],[YCAssistiveMemoryHelper availableMemory]];
    self.cpuLbl.text = [NSString stringWithFormat:@"CPU：%.1f%%",[YCAssistiveMemoryHelper cpuUsage]];
}

- (void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink invalidate];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - getter
- (UILabel *)fpsLbl {
    
    if (_fpsLbl == nil) {
        _fpsLbl = [[UILabel alloc] init];
        _fpsLbl.textColor = [UIColor whiteColor];
        _fpsLbl.font = [UIFont as_13];
        _fpsLbl.textAlignment = NSTextAlignmentCenter;
        _fpsLbl.layer.cornerRadius = 8.0;
    }
    return _fpsLbl;
}
- (UILabel *)memoryLbl {
    
    if (_memoryLbl == nil) {
        _memoryLbl = [[UILabel alloc] init];
        _memoryLbl.textColor = [UIColor whiteColor];
        _memoryLbl.font = [UIFont as_13];
        _memoryLbl.textAlignment = NSTextAlignmentCenter;
        _memoryLbl.numberOfLines = 0;
    }
    return _memoryLbl;
}
- (UILabel *)cpuLbl {
    
    if (_cpuLbl == nil) {
        _cpuLbl = [[UILabel alloc] init];
        _cpuLbl.textColor = [UIColor whiteColor];
        _cpuLbl.font = [UIFont as_13];
        _cpuLbl.textAlignment = NSTextAlignmentCenter;
        _cpuLbl.layer.cornerRadius = 8.0;
    }
    return _cpuLbl;
}
@end
