//
//  YCAssistiveSignalCrashHandler.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/10/10.
//

#import "YCAssistiveSignalCrashHandler.h"
#include <execinfo.h>
#import "YCAssistiveCrashPlugin.h"

typedef void (*SignalHandler)(int signal, siginfo_t *info, void *context);

static SignalHandler previousABRTSignalHandler = NULL;
static SignalHandler previousBUSSignalHandler  = NULL;
static SignalHandler previousFPESignalHandler  = NULL;
static SignalHandler previousILLSignalHandler  = NULL;
static SignalHandler previousPIPESignalHandler = NULL;
static SignalHandler previousSEGVSignalHandler = NULL;
static SignalHandler previousSYSSignalHandler  = NULL;
static SignalHandler previousTRAPSignalHandler = NULL;

@implementation YCAssistiveSignalCrashHandler


+ (void)registerSignalHandler {
    
    //持有已经注册的handler
    [self holdOriginHandler];
    
    [self signalRegister];
}

+ (void)holdOriginHandler {
    
    struct sigaction old_action_abrt;
    sigaction(SIGABRT, NULL, &old_action_abrt);
    if (old_action_abrt.sa_sigaction) {
        previousABRTSignalHandler = old_action_abrt.sa_sigaction;
    }
    
    struct sigaction old_action_bus;
    sigaction(SIGBUS, NULL, &old_action_bus);
    if (old_action_bus.sa_sigaction) {
        previousBUSSignalHandler = old_action_bus.sa_sigaction;
    }
    
    struct sigaction old_action_fpe;
    sigaction(SIGFPE, NULL, &old_action_fpe);
    if (old_action_fpe.sa_sigaction) {
        previousFPESignalHandler = old_action_fpe.sa_sigaction;
    }
    
    struct sigaction old_action_ill;
    sigaction(SIGILL, NULL, &old_action_ill);
    if (old_action_ill.sa_sigaction) {
        previousILLSignalHandler = old_action_ill.sa_sigaction;
    }
    
    struct sigaction old_action_pipe;
    sigaction(SIGPIPE, NULL, &old_action_pipe);
    if (old_action_pipe.sa_sigaction) {
        previousPIPESignalHandler = old_action_pipe.sa_sigaction;
    }
    
    struct sigaction old_action_segv;
    sigaction(SIGSEGV, NULL, &old_action_segv);
    if (old_action_segv.sa_sigaction) {
        previousSEGVSignalHandler = old_action_segv.sa_sigaction;
    }
    
    struct sigaction old_action_sys;
    sigaction(SIGSYS, NULL, &old_action_sys);
    if (old_action_sys.sa_sigaction) {
        previousSYSSignalHandler = old_action_sys.sa_sigaction;
    }
    
    struct sigaction old_action_trap;
    sigaction(SIGTRAP, NULL, &old_action_trap);
    if (old_action_trap.sa_sigaction) {
        previousTRAPSignalHandler = old_action_trap.sa_sigaction;
    }
}

#pragma mark - register signal
+ (void)signalRegister {
    
    assistiveRegisterSignal(SIGABRT);   /* abort() */
    assistiveRegisterSignal(SIGBUS);    /* bus error */
    assistiveRegisterSignal(SIGFPE);    /* floating point exception */
    assistiveRegisterSignal(SIGILL);    /* illegal instruction (not reset when caught) */
    assistiveRegisterSignal(SIGPIPE);   /* write on a pipe with no one to read it */
    assistiveRegisterSignal(SIGSEGV);   /* segmentation violation */
    assistiveRegisterSignal(SIGSYS);    /* bad argument to system call */
    assistiveRegisterSignal(SIGTRAP);   /* trace trap (not reset when caught) */
}

static void assistiveRegisterSignal(int signal) {
    
    struct sigaction action;
    action.sa_sigaction = assistiveSignalCrashHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal,&action,0);
}

static void assistiveSignalCrashHandler(int signal, siginfo_t* info, void* context) {
    
    [[YCAssistiveCrashPlugin sharedPlugin] saveSignal:signal];
    assistiveClearSignalRigister();
    previousSignalHandler(signal, info, context);
    //杀掉程序
    kill(getpid(), SIGKILL);
}

#pragma mark Previous Signal
static void previousSignalHandler(int signal, siginfo_t *info, void *context) {
    SignalHandler previousSignalHandler = NULL;
    switch (signal) {
        case SIGABRT:
            previousSignalHandler = previousABRTSignalHandler;
            break;
        case SIGBUS:
            previousSignalHandler = previousBUSSignalHandler;
            break;
        case SIGFPE:
            previousSignalHandler = previousFPESignalHandler;
            break;
        case SIGILL:
            previousSignalHandler = previousILLSignalHandler;
            break;
        case SIGPIPE:
            previousSignalHandler = previousPIPESignalHandler;
            break;
        case SIGSEGV:
            previousSignalHandler = previousSEGVSignalHandler;
            break;
        case SIGSYS:
            previousSignalHandler = previousSYSSignalHandler;
            break;
        case SIGTRAP:
            previousSignalHandler = previousTRAPSignalHandler;
            break;
        default:
            break;
    }
    
    if (previousSignalHandler) {
        previousSignalHandler(signal, info, context);
    }
}

#pragma mark - clear
static void assistiveClearSignalRigister() {
    signal(SIGSEGV,SIG_DFL);
    signal(SIGFPE,SIG_DFL);
    signal(SIGBUS,SIG_DFL);
    signal(SIGTRAP,SIG_DFL);
    signal(SIGABRT,SIG_DFL);
    signal(SIGILL,SIG_DFL);
    signal(SIGPIPE,SIG_DFL);
    signal(SIGSYS,SIG_DFL);
}
@end
