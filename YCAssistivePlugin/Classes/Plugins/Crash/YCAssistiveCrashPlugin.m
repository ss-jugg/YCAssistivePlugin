//
//  YCAssistiveCrashPlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/4.
//

#import "YCAssistiveCrashPlugin.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "YCAssistiveSignalCrashHandler.h"
#import "YCAssistiveExceptionCrashHandler.h"

NSString *const kAssitiveCrashSignalException = @"signal";
NSString *const kAssitiveCrashException = @"exception";

static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler;

@interface YCAssistiveCrashPlugin ()
{
    //文件路径
    NSString*       _crashLogPath;
    //日志总表
    NSMutableArray* _plist;
}
@end

@implementation YCAssistiveCrashPlugin

+ (instancetype)sharedPlugin {
    
    static YCAssistiveCrashPlugin *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[YCAssistiveCrashPlugin alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        /* /Library/Caches/AssistiveCrashLog */
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* sandBoxPath  = [paths objectAtIndex:0];
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"AssistiveCrashLog"];
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath] ) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        NSLog(@"--_crashLogPath-->>%@",_crashLogPath);
        //creat plist and return list  datas
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]]) {
            
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
            
        } else {
            _plist = [NSMutableArray new];
        }
        
    }
    return self;
}

/* crash log 对应的key 列表 */
- (NSArray* )crashPlist {
    
    return [_plist copy];
}

/* crash log 列表 */
- (NSArray* )crashLogs {
    
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in _plist) {
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSString* path = [filePath stringByAppendingString:@".plist"];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:path];
        [ret addObject:log];
    }
    return [ret copy];
}

/* 保存crash log */
- (void)saveException:(NSException*)exception {
    
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    if ( exception.name ) {
        [detail setObject:exception.name forKey:@"name"];
    } if ( exception.reason ) {
        [detail setObject:exception.reason forKey:@"reason"];
    } if ( exception.userInfo ) {
        [detail setObject:exception.userInfo forKey:@"userInfo"];
    } if ( exception.callStackSymbols ) {
        [detail setObject:[[exception callStackSymbols] componentsJoinedByString:@"\n"] forKey:@"backtrace"];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:kAssitiveCrashException forKey:@"typeName"];
    [dict setObject:detail forKey:@"info"];
    [self saveToFile:dict];
}


/* 保存crash 到文件,更新列表 */
- (void)saveToFile:(NSMutableDictionary*)dict {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    [dict setObject:[self appInfo] forKey:@"appInfo"];
    /* 日期 */
    [dict setObject:dateString forKey:@"date"];
    /* 难易度 */
    [dict setObject:@0 forKey:@"level"];
    /* 是否解决 */
    [dict setObject:@0 forKey:@"resolve"];
    /* 描述字段 */
    [dict setObject:@"" forKey:@"des"];
    
    /* 根据日期格式把文件写入本地 */
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".plist"];
    [dict writeToFile:savePath atomically:YES];
    
    /* 更新总列表 */
    [_plist insertObject:dateString atIndex:0];
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
}

- (NSString *)appInfo {
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *device = [UIDevice currentDevice].model;
    NSString *system = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    return [NSString stringWithFormat:@"App_%@%@(%@)-Device_%@-System_%@-UUID%@", name, shortVersion, version,device, system, uuid];
}

#pragma mark - buplic
/*  取出对应key的crash log */
- (NSDictionary* )crashForKey:(NSString *)key {
    
    NSString* filePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    if (filePath == nil) {
        return nil;
    }
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

/* 替换对应key的crash log */
- (void)replaceCrashLogToFileByKey:(NSString *)key withDict:(NSDictionary *)dict {
    
    if (!key) {
        return;
    }
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    [dict.copy writeToFile:savePath atomically:YES];
}

/* 删除某key对应的crash */
- (void)deleteCrashLogFromDateKey:(NSString *)key {
    
    //先从_plist移除记录
    if ([_plist containsObject:key]) {
        [_plist removeObject:key];
        [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
    }
    //移除文件
    NSString *filePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    if (filePath) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - register
- (NSString *)backtraceInfo {
    
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableString *backtraceInfo = [NSMutableString string];
    for (int i = 0; i < frames; i++) {
        [backtraceInfo appendFormat:@"\t%@\n",[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtraceInfo;
}

- (void)saveSignal:(int) signal {
    
    const char* names[NSIG];
    names[SIGABRT] = "SIGABRT";
    names[SIGBUS] = "SIGBUS";
    names[SIGFPE] = "SIGFPE";
    names[SIGILL] = "SIGILL";
    names[SIGTRAP] = "SIGTRAP";
    names[SIGSEGV] = "SIGSEGV";
    names[SIGPIPE] = "SIGPIPE";
    names[SIGSYS] = "SIGSYS";
    
    const char* reasons[NSIG];
    reasons[SIGABRT] = "abort()";
    reasons[SIGBUS] = "bus error";
    reasons[SIGFPE] = "floating point exception";
    reasons[SIGILL] = "illegal instruction (not reset when caught)";
    reasons[SIGTRAP] = "breakpoint or other trap instruction";
    reasons[SIGSEGV] = "segmentation violation";
    reasons[SIGPIPE] = "write on a pipe with no one to read it";
    reasons[SIGSYS] = "bad argument to system call";
    
    //crash信息
    NSString *reason = [NSString stringWithUTF8String:reasons[signal]];
    
    // 因为注册了信号崩溃回调方法，系统会来调用，将记录在调用堆栈上，因此此行日志需要过滤掉
    NSMutableString *mstr = [[NSMutableString alloc] init];
    for (NSUInteger index = 1; index < NSThread.callStackSymbols.count; index++) {
        NSString *str = [NSThread.callStackSymbols objectAtIndex:index];
        [mstr appendString:[str stringByAppendingString:@"\n"]];
    }
    [mstr appendString:@"threadInfo:\n"];
    [mstr appendString:[[NSThread currentThread] description]];
    
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    [detail setObject:mstr forKey:@"backtrace"];
    [detail setObject:reason forKey:@"reason"];
    [detail setObject:[NSString stringWithUTF8String:names[signal]] forKey:@"name"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:kAssitiveCrashSignalException forKey:@"typeName"];
    [dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];
}

- (void)install {
    
    //延迟注册回调函数，保证本次注册是最后完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YCAssistiveSignalCrashHandler registerSignalHandler];
        [YCAssistiveExceptionCrashHandler registerExceptionHandler];
    });
}

@end
