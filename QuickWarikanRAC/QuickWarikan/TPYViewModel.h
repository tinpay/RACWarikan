//
//  TPYViewModel.h
//  QuickWarikan
//
//  Created by shohei on 2014/07/07.
//  Copyright (c) 2014年 Tinpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TPYViewModel : NSObject


@property (nonatomic,strong) NSString *answerMore;
@property (nonatomic,strong) NSString *answerLess;
@property (nonatomic,strong) NSString *total;
@property (nonatomic,strong) NSString *morepay;
@property (nonatomic,strong) NSString *lesspay;
@property (nonatomic,strong) NSString *diffmoney;

@property (nonatomic,strong) RACCommand *clearCommand;

@end
