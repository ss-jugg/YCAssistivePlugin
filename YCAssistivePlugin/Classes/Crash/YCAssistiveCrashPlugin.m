//
//  YCAssistiveCrashPlugin.m
//  YCAssistivePlugin
//
//  Created by haima on 2019/7/4.
//

#import "YCAssistiveCrashPlugin.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString *const kAssitiveCrashSignalException = @"signal";
NSString *const kAssitiveCrashException = @"exception";

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
    [dict setObject:kAssitiveCrashException forKey:@"type"];
    [dict setObject:detail forKey:@"info"];
    [self saveToFile:dict];
}


/* 保存crash 到文件,更新列表 */
- (void)saveToFile:(NSMutableDictionary*)dict {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    /* 日期 */
    [dict setObject:dateString forKey:@"date"];
    /* 难易度 */
    [dict setObject:@0 forKey:@"situation"];
    /* 是否已读 */
    [dict setObject:@0 forKey:@"read"];
    /* 是否解决 */
    [dict setObject:@0 forKey:@"solution"];
    /* 描述字段 */
    [dict setObject:@"" forKey:@"description"];
    
    /* 根据日期格式把文件写入本地 */
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".plist"];
    [dict writeToFile:savePath atomically:YES];
    
    /* 更新总列表 */
    [_plist insertObject:dateString atIndex:0];
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
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
void Assistive_HandleException(NSException *exception) {
    
    [[YCAssistiveCrashPlugin sharedPlugin] saveException:exception];
    [exception raise];
}

void Assistive_SignalHandler(int sig) {

    [[YCAssistiveCrashPlugin sharedPlugin] saveSignal:sig];
    signal(sig, SIG_DFL);
    raise(sig);
}

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
    
    const char* reasons[NSIG];
    reasons[SIGABRT] = "abort()";
    reasons[SIGBUS] = "bus error";
    reasons[SIGFPE] = "floating point exception";
    reasons[SIGILL] = "illegal instruction (not reset when caught)";
    reasons[SIGTRAP] = "breakpoint or other trap instruction";
    reasons[SIGSEGV] = "segmentation violation";
    
    //crash信息
    NSString *reason = [NSString stringWithUTF8String:reasons[signal]];
    NSString *backtraceInfo = [[YCAssistiveCrashPlugin sharedPlugin] backtraceInfo];
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    [detail setObject:backtraceInfo forKey:@"backtrace"];
    [detail setObject:reason forKey:@"reason"];
    [detail setObject:[NSString stringWithUTF8String:names[signal]] forKey:@"name"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:kAssitiveCrashSignalException forKey:@"type"];
    [dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];
}

- (void)install {
    
    //注册回调函数
    NSSetUncaughtExceptionHandler(&Assistive_HandleException);
    signal(SIGABRT, Assistive_SignalHandler);
    signal(SIGILL, Assistive_SignalHandler);
    signal(SIGSEGV, Assistive_SignalHandler);
    signal(SIGFPE, Assistive_SignalHandler);
    signal(SIGBUS, Assistive_SignalHandler);
    signal(SIGPIPE, Assistive_SignalHandler);
}

- (void)dealloc {
    
    signal( SIGABRT,    SIG_DFL );
    signal( SIGBUS,     SIG_DFL );
    signal( SIGFPE,     SIG_DFL );
    signal( SIGILL,     SIG_DFL );
    signal( SIGPIPE,    SIG_DFL );
    signal( SIGSEGV,    SIG_DFL );
}

@end
