//
//  HSDConsoleLogController.h
//  HttpServerDebug
//
//  Created by chenjun on 2018/4/10.
//  Copyright © 2018年 chenjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDConsoleLogController : NSObject

/**
 *  finish reading from stderr
 */
@property (nonatomic, strong) void(^readCompletionBlock)(NSString *);

/**
 *  redirect STDERR_FILENO
 */
- (void)redirectStandardErrorOutput;

/**
 *  reset STDERR_FILENO
 */
-(void)recoverStandardErrorOutput;

@end
