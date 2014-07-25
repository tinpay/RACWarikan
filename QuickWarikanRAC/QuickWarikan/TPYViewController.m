//
//  TPYViewController.m
//  QuickWarikan
//
//  Created by shohei on 2014/07/07.
//  Copyright (c) 2014年 Tinpay. All rights reserved.
//

#import "TPYViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "TPYViewModel.h"

@interface TPYViewController ()

@property (weak, nonatomic) IBOutlet UILabel *answerMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLessLabel;
@property (weak, nonatomic) IBOutlet UITextField *morePayNumText;
@property (weak, nonatomic) IBOutlet UITextField *lessPayNumText;
@property (weak, nonatomic) IBOutlet UITextField *diffMoneyText;
@property (weak, nonatomic) IBOutlet UITextField *totalText;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic,strong) TPYViewModel *viewModel;


@end

@implementation TPYViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    //バインディング
    [self bindWithViewModel];
    //初期クリア
    [self.viewModel.clearCommand execute:nil];
    
}

//バインディングの設定
- (void)bindWithViewModel {
    
    self.viewModel = [[TPYViewModel alloc] init];

    //人数（支払い多め） two-way binding
    RACChannelTerminal *moreTextFieldTerminal = [self.morePayNumText rac_newTextChannel];
    RACChannelTerminal *morepayTerminal = RACChannelTo(self.viewModel, morepay);
    [morepayTerminal subscribe:moreTextFieldTerminal];
    [moreTextFieldTerminal subscribe:morepayTerminal];
    
    //人数 two-way binding
    RACChannelTerminal *lessTextFieldTerminal = [self.lessPayNumText rac_newTextChannel];
    RACChannelTerminal *lesspayTerminal = RACChannelTo(self.viewModel, lesspay);
    [lesspayTerminal subscribe:lessTextFieldTerminal];
    [lessTextFieldTerminal subscribe:lesspayTerminal];

    
    //多めに払う金額 two-way binding
    RACChannelTerminal *diffTextFieldTerminal = [self.diffMoneyText rac_newTextChannel];
    RACChannelTerminal *diffTerminal = RACChannelTo(self.viewModel, diffmoney);
    [diffTerminal subscribe:diffTextFieldTerminal];
    [diffTextFieldTerminal subscribe:diffTerminal];

    
    //支払合計金額 two-way binding
    RACChannelTerminal *totalTextFieldTerminal = [self.totalText rac_newTextChannel];
    RACChannelTerminal *totalTerminal = RACChannelTo(self.viewModel, total);
    [totalTerminal subscribe:totalTextFieldTerminal];
    [totalTextFieldTerminal subscribe:totalTerminal];

    
    //割り勘した金額 one-way binding
    RAC(self,answerMoreLabel.text) = RACObserve(self.viewModel, answerMore);
    RAC(self,answerLessLabel.text) = RACObserve(self.viewModel, answerLess);

    //クリアコマンド実行後に合計金額欄へフォーカス移動
    RACSignal *clearSignal = [self.viewModel.clearCommand.executionSignals flatten];
    [clearSignal subscribeNext:^(id x) {
        [self.totalText becomeFirstResponder];
    }];
    
    //クリアボタン
    self.clearButton.rac_command = self.viewModel.clearCommand;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
