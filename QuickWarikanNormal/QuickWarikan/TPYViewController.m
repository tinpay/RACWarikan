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
const int tagTotal=1;
const int tagMore=2;
const int tagLess=3;
const int tagDiff=4;
const int tagAnsMore=5;
const int tagAnsLess=6;


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
    
    self.totalText.tag = tagTotal;
    self.morePayNumText.tag = tagMore;
    self.lessPayNumText.tag = tagLess;
    self.diffMoneyText.tag = tagDiff;
    
    
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
    //入力された値を取得
    NSMutableString *str = [textField.text mutableCopy];
    [str replaceCharactersInRange:range withString:string];
    
    NSString *tmpMore = self.morePayNumText.text;
    NSString *tmpLess = self.lessPayNumText.text;
    NSString *tmpTotal = self.totalText.text;
    NSString *tmpDiff = self.diffMoneyText.text;
    if (textField.tag == tagMore) {
        tmpMore = str;
    }else if (textField.tag == tagLess){
        tmpLess = str;
    }else if (textField.tag == tagTotal){
        tmpTotal = str;
    }else if (textField.tag == tagDiff){
        tmpDiff = str;
    }
    
    //すべてに数字が入力されたときに計算
    if ([self isDigit:tmpTotal] && [self isDigit:tmpMore] && [self isDigit:tmpLess] && [self isDigit:tmpDiff]) {
        //割り勘計算
        [self calcMore:tmpMore.doubleValue Less:tmpLess.doubleValue Diff:tmpDiff.doubleValue Total:tmpTotal.doubleValue];
    }
    
    
    return YES;
}


#pragma mark IBAction method

- (IBAction)tapClear:(id)sender {
    [self initScreen];
}


#pragma mark private method

//割り勘の計算をする
-(void) calcMore:(double)more Less:(double)less Diff:(double)diff Total:(double)total{
    
    if(more ==0 && less==0){
        self.answerMoreLabel.text=@"0";
        self.answerLessLabel.text=@"0";
        return;
    }
    
    double fc = kFraction;
    int ans = ceil(((total - more * diff)/(more + less)) / fc);
    
    self.answerLessLabel.text =[ NSString stringWithFormat:@"%.0f", ans * fc];
    self.answerMoreLabel.text =[ NSString stringWithFormat:@"%.0f", ans * fc + diff];
    
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
