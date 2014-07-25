//
//  TPYViewModel.m
//  QuickWarikan
//
//  Created by tinpay on 2014/07/07.
//  Copyright (c) 2014年 Tinpay. All rights reserved.
//

#import "TPYViewModel.h"
#import <ReactiveCocoa/RACEXTScope.h>


const int kFraction = 100;

@implementation TPYViewModel


-(id) init{
    if (self = [super init]) {

        @weakify(self);
        [[[RACSignal combineLatest:@[RACObserve(self, total),RACObserve(self, morepay),RACObserve(self,lesspay),RACObserve(self, diffmoney)]
                           ] filter:^BOOL(RACTuple *tuple) {
            @strongify(self);
            RACTupleUnpack(NSString *total,NSString *morepay, NSString *lesspay, NSString *diffmoney) = tuple;
            //すべてに数字が入力されたときに計算
            return [self isDigit:total] && [self isDigit:morepay] && [self isDigit:lesspay] && [self isDigit:diffmoney];
        }] subscribeNext:^(id x) {
            @strongify(self);
            //割り勘計算
            [self calc];
        }];
        
        self.clearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self clear];
            return [RACSignal return:RACUnit.defaultUnit];
        }];

        
    }
    return self;
}



#pragma mark private method

//値をクリア
-(void)clear{
    
    self.morepay = @"";
    self.lesspay = @"";
    self.total = @"";
    self.diffmoney = @"";
    self.answerLess = @"";
    self.answerMore = @"";
}

//数値かどうかチェック
-(BOOL)isDigit:(NSString *)txt{
    if (txt==nil || [txt isEqualToString:@""]) {
        return NO;
    }
    
    NSScanner *scanner = [NSScanner localizedScannerWithString:txt];
    [scanner setCharactersToBeSkipped:nil];
    
    [scanner scanInt:NULL];
    return [scanner isAtEnd];
}


#pragma mark private method モデルに書くビジネスロジック
//割り勘の計算をする
-(void) calc{
    
    if(self.morepay.intValue + self.lesspay.intValue==0){
        self.answerMore=0;
        self.answerLess=0;
        return;
    }
    
    double fc=kFraction;
    
    int ans = ceil(((self.total.doubleValue - self.morepay.doubleValue * self.diffmoney.doubleValue)/(self.morepay.doubleValue + self.lesspay.doubleValue)) / fc);
    
    self.answerLess =[ NSString stringWithFormat:@"%.0f", ans * fc];
    self.answerMore =[ NSString stringWithFormat:@"%.0f", ans * fc + self.diffmoney.doubleValue];
    
}
         
@end
