//
//  TPYViewController.m
//  QuickWarikan
//
//  Created by shohei on 2014/07/07.
//  Copyright (c) 2014年 Tinpay. All rights reserved.
//

#import "TPYViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

const int kFraction = 100;

@interface TPYViewController ()

@property (weak, nonatomic) IBOutlet UILabel *answerMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLessLabel;
@property (weak, nonatomic) IBOutlet UITextField *morePayNumText;
@property (weak, nonatomic) IBOutlet UITextField *lessPayNumText;
@property (weak, nonatomic) IBOutlet UITextField *diffMoneyText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fractionSegment;
@property (weak, nonatomic) IBOutlet UITextField *totalText;


@end

@implementation TPYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TextField delegate
    self.morePayNumText.delegate = self;
    self.lessPayNumText.delegate = self;
    self.diffMoneyText.delegate = self;
    self.totalText.delegate = self;
    
    
    [self initScreen];
}

//画面の入力欄を初期化
-(void) initScreen{
    
    self.morePayNumText.text = @"";
    self.lessPayNumText.text = @"";
    self.totalText.text = @"";
    self.diffMoneyText.text = @"";

    self.answerLessLabel.text = @"";
    self.answerMoreLabel.text = @"";
    
    [self.totalText becomeFirstResponder];
    
}


#pragma mark UITextField delegate method
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //すべてに数字が入力されたときに計算
    if ([self isDigit:self.totalText.text] && [self isDigit:self.morePayNumText.text] && [self isDigit:self.lessPayNumText.text] && [self isDigit:self.diffMoneyText.text]) {
        //割り勘計算
        [self calc];
    }
    
    
    return YES;
}


#pragma mark IBAction method

- (IBAction)tapClear:(id)sender {
    [self initScreen];
}


#pragma mark private method

//割り勘の計算をする
-(void) calc{
    
    if(self.morePayNumText.text.intValue + self.lessPayNumText.text.intValue==0){
        self.answerMoreLabel.text=@"0";
        self.answerLessLabel.text=@"0";
        return;
    }   
    
    double fc = kFraction;
    int ans = ceil(((self.totalText.text.doubleValue - self.morePayNumText.text.doubleValue * self.diffMoneyText.text.doubleValue)/(self.morePayNumText.text.doubleValue + self.lessPayNumText.text.doubleValue)) / fc);
    
    self.answerLessLabel.text =[ NSString stringWithFormat:@"%.0f", ans * fc];
    self.answerMoreLabel.text =[ NSString stringWithFormat:@"%.0f", ans * fc + self.diffMoneyText.text.doubleValue];
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
