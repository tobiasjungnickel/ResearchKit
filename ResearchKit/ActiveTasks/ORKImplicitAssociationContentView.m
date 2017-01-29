/*
 Copyright (c) 2016, Tobias Jungnickel. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "ORKImplicitAssociationContentView.h"

#import "ORKActiveStepTimer.h"
#import "ORKRoundTappingButton.h"
#import "ORKHeadlineLabel.h"
#import "ORKSubheadlineLabel.h"
#import "ORKTapCountLabel.h"

#import "ORKResult.h"

#import "ORKHelpers_Internal.h"
#import "ORKSkin.h"


#define LAYOUT_DEBUG 1


@interface ORKImplicitAssociationContentView ()

@property (nonatomic, strong) ORKHeadlineLabel *termLabel;
@property (nonatomic, strong) ORKTapCountLabel *tapCountLabel;

@end


@implementation ORKImplicitAssociationContentView {
    UIView *_buttonContainer;
    ORKHeadlineLabel *_leftItemLabel1;
    ORKHeadlineLabel *_rightItemLabel1;
    
    NSNumberFormatter *_formatter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _termLabel = [ORKHeadlineLabel new];
        _termLabel.textAlignment = NSTextAlignmentCenter;
        _termLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftItemLabel1 = [ORKHeadlineLabel new];
        _leftItemLabel1.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemLabel1 = [ORKHeadlineLabel new];
        _rightItemLabel1.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _tapCountLabel = [ORKTapCountLabel new];
        _tapCountLabel.textAlignment = NSTextAlignmentCenter;
        _tapCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _buttonContainer = [UIView new];
        _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _tapButton1 = [[ORKRoundTappingButton alloc] init];
        _tapButton1.translatesAutoresizingMaskIntoConstraints = NO;
        [_tapButton1 setTitle:ORKLocalizedString(@"TAP_BUTTON_TITLE", nil) forState:UIControlStateNormal];
        
        _tapButton2 = [[ORKRoundTappingButton alloc] init];
        _tapButton2.translatesAutoresizingMaskIntoConstraints = NO;
        [_tapButton2 setTitle:ORKLocalizedString(@"TAP_BUTTON_TITLE", nil) forState:UIControlStateNormal];
        
        _lastTappedButton = -1;
        
        [self addSubview:_termLabel];
        [self addSubview:_leftItemLabel1];
        [self addSubview:_rightItemLabel1];
        [self addSubview:_tapCountLabel];
        [self addSubview:_buttonContainer];
        
        [_buttonContainer addSubview:_tapButton1];
        [_buttonContainer addSubview:_tapButton2];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _termLabel.text = ORKLocalizedString(@"TERM_LABEL", nil);
        _leftItemLabel1.text = @"LEFT_1";
        _rightItemLabel1.text = @"RIGHT_1";
        [self setTapCount:0];
        
        [self setUpConstraints];
        
        _tapCountLabel.accessibilityTraits |= UIAccessibilityTraitUpdatesFrequently;
        
#if LAYOUT_DEBUG
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
        self.termLabel.backgroundColor = [UIColor orangeColor];
        self.tapCountLabel.backgroundColor = [UIColor greenColor];
        _buttonContainer.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
#endif
    }
    return self;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
}

- (void)setTapCount:(NSUInteger)tapCount {
    if (_formatter == nil) {
        _formatter = [NSNumberFormatter new];
        _formatter.locale = [NSLocale currentLocale];
        _formatter.minimumIntegerDigits = 2;
    }
    _tapCountLabel.text = [_formatter stringFromNumber:@(tapCount)];
}

- (void)resetStep:(ORKActiveStepViewController *)viewController {
    [super resetStep:viewController];
    [self setTapCount:0];
    _tapButton1.enabled = YES;
    _tapButton2.enabled = YES;
}

- (void)finishStep:(ORKActiveStepViewController *)viewController {
    [super finishStep:viewController];
    _tapButton1.enabled = NO;
    _tapButton2.enabled = NO;
}

- (void)setUpConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_buttonContainer, _termLabel, _leftItemLabel1, _rightItemLabel1, _tapCountLabel, _tapButton1, _tapButton2);
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_termLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_termLabel
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_leftItemLabel1
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_leftItemLabel1
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:10.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_rightItemLabel1
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_rightItemLabel1
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:-10.0]];
    
    [constraints addObject: [NSLayoutConstraint constraintWithItem:_tapCountLabel
                                                         attribute:NSLayoutAttributeFirstBaseline
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_termLabel
                                                         attribute:NSLayoutAttributeFirstBaseline
                                                        multiplier:1.0
                                                          constant:56.0]];
    
    
    [constraints addObject: [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_buttonContainer
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:36.0]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_termLabel]-(>=10)-[_buttonContainer]"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];

    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_termLabel]-|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tapCountLabel]-|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tapButton1]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tapButton2]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tapButton1]-(>=24)-[_tapButton2(==_tapButton1)]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_tapButton1
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_tapButton2
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                         constant:0.0]];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
