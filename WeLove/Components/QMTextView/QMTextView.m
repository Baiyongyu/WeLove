//
//  QMTextView.m
//  inongtian
//
//  Created by KevinCao on 2016/10/27.
//  Copyright © 2016年 qianmo. All rights reserved.
//

#import "QMTextView.h"

@interface QMTextView ()
@property(nonatomic,strong)UILabel *placeholderLabel;
@end

@implementation QMTextView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self insertSubview:self.placeholderLabel atIndex:0];
        WS(weakSelf);
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.top.mas_equalTo(8);
            make.width.equalTo(weakSelf);
            make.height.mas_greaterThanOrEqualTo(20);
        }];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidBeginEditingNotification object:self];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notes
-(void)textDidChange
{
    self.placeholderLabel.hidden=(self.text.length);
}

#pragma mark - getters and setters
-(void)setText:(NSString *)text
{
    [super setText:text];
    self.placeholderLabel.hidden=(text.length);
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

-(void)setPlaceholder:(NSString *)strValue
{
    _placeholder = [strValue copy];
    self.placeholderLabel.text = _placeholder;
}

-(UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeholderLabel;
}

@end
