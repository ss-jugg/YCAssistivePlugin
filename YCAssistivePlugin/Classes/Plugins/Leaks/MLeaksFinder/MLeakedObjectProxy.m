/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "MLeakedObjectProxy.h"
#import "MLeaksFinder.h"
#import "MLeaksMessenger.h"
#import "NSObject+MemoryLeak.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#import "YCAssistiveLeaksManager.h"
#import "YCAssistiveMeomryLeakModel.h"
#if _INTERNAL_MLF_RC_ENABLED
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

static NSMutableSet *leakedObjectPtrs;

@interface MLeakedObjectProxy ()<UIAlertViewDelegate>
@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSNumber *objectPtr;
@property (nonatomic, strong) NSArray *viewStack;
@end

@implementation MLeakedObjectProxy

+ (BOOL)isAnyObjectLeakedAtPtrs:(NSSet *)ptrs {
    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        leakedObjectPtrs = [[NSMutableSet alloc] init];
    });
    
    if (!ptrs.count) {
        return NO;
    }
    if ([leakedObjectPtrs intersectsSet:ptrs]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)addLeakedObject:(id)object {
    NSAssert([NSThread isMainThread], @"Must be in main thread.");
    
    MLeakedObjectProxy *proxy = [[MLeakedObjectProxy alloc] init];
    proxy.object = object;
    proxy.objectPtr = @((uintptr_t)object);
    proxy.viewStack = [object viewStack];
    static const void *const kLeakedObjectProxyKey = &kLeakedObjectProxyKey;
    objc_setAssociatedObject(object, kLeakedObjectProxyKey, proxy, OBJC_ASSOCIATION_RETAIN);
    
    [leakedObjectPtrs addObject:proxy.objectPtr];
    
    YCAssistiveMeomryLeakModel *leakModel = [[YCAssistiveMeomryLeakModel alloc] init];
    leakModel.objectPtr = @((uintptr_t)object);
    leakModel.className = NSStringFromClass([object class]);
    leakModel.viewStack = [object viewStack];
    if ([YCAssistiveLeaksManager shareManager].enableRetainCycle) {
        [proxy findRetainCycleInObject:object block:^(NSArray *retainCycles) {
            if (retainCycles && retainCycles.count > 0) {
                leakModel.isRetainCycle = YES;
                leakModel.retainCycle = retainCycles;
                [MLeaksMessenger alertWithTitle:@"Retain Cycle" message:[NSString stringWithFormat:@"%@",retainCycles]];
            }else {
                [MLeaksMessenger alertWithTitle:@"Memory Leak" message:[NSString stringWithFormat:@"%@",[leakModel.viewStack componentsJoinedByString:@" -> "]]];
            }
            [[YCAssistiveLeaksManager shareManager] addLeakObject:leakModel];
        }];
    }else {
        [[YCAssistiveLeaksManager shareManager] addLeakObject:leakModel];
        [MLeaksMessenger alertWithTitle:@"Memory Leak" message:[NSString stringWithFormat:@"%@",[[object viewStack] componentsJoinedByString:@" -> "]]];
    }
}

- (void)findRetainCycleInObject:(id)object block:(void(^)(NSArray * retainCycles))block {
    
    if (!object) {
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
        [detector addCandidate:self.object];
        NSSet *retainCycles = [detector findRetainCycles];
        BOOL hasFound = NO;
        NSArray *shiftedRetainCycle = nil;
        for (NSArray *retainCycle in retainCycles) {
            NSInteger index = 0;
            for (FBObjectiveCGraphElement *element in retainCycle) {
                if (element.object == object) {
                    shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
                    hasFound = YES;
                    break;
                }
                ++index;
            }
            if (hasFound) {
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(shiftedRetainCycle);
        });
    });
}

- (void)dealloc {
    NSNumber *objectPtr = _objectPtr;
    NSArray *viewStack = _viewStack;
    dispatch_async(dispatch_get_main_queue(), ^{
        [leakedObjectPtrs removeObject:objectPtr];
        [MLeaksMessenger alertWithTitle:@"Object Deallocated"
                                message:[NSString stringWithFormat:@"%@", viewStack]];
    });
}

#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (!buttonIndex) {
//        return;
//    }
//
//    id object = self.object;
//    if (!object) {
//        return;
//    }
//
//#if _INTERNAL_MLF_RC_ENABLED
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        FBRetainCycleDetector *detector = [FBRetainCycleDetector new];
//        [detector addCandidate:self.object];
//        NSSet *retainCycles = [detector findRetainCyclesWithMaxCycleLength:20];
//
//        BOOL hasFound = NO;
//        for (NSArray *retainCycle in retainCycles) {
//            NSInteger index = 0;
//            for (FBObjectiveCGraphElement *element in retainCycle) {
//                if (element.object == object) {
//                    NSArray *shiftedRetainCycle = [self shiftArray:retainCycle toIndex:index];
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MLeaksMessenger alertWithTitle:@"Retain Cycle"
//                                                message:[NSString stringWithFormat:@"%@", shiftedRetainCycle]];
//                    });
//                    hasFound = YES;
//                    break;
//                }
//
//                ++index;
//            }
//            if (hasFound) {
//                break;
//            }
//        }
//        if (!hasFound) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MLeaksMessenger alertWithTitle:@"Retain Cycle"
//                                        message:@"Fail to find a retain cycle"];
//            });
//        }
//    });
//#endif
//}

- (NSArray *)shiftArray:(NSArray *)array toIndex:(NSInteger)index {
    if (index == 0) {
        return array;
    }
    
    NSRange range = NSMakeRange(index, array.count - index);
    NSMutableArray *result = [[array subarrayWithRange:range] mutableCopy];
    [result addObjectsFromArray:[array subarrayWithRange:NSMakeRange(0, index)]];
    return result;
}

@end
