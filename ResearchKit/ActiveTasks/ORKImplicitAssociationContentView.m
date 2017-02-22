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
#import "ORKFormSectionTitleLabel.h"
#import "ORKHeadlineLabel.h"
#import "ORKSubheadlineLabel.h"

#import "ORKResult.h"

#import "ORKHelpers_Internal.h"
#import "ORKSkin.h"


//#define LAYOUT_DEBUG 1


@interface ORKWrongLabel : ORKLabel

@end

@implementation ORKWrongLabel

+ (UIFont *)defaultFont {
    // Medium, 56
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return ORKMediumFontWithSize([[descriptor objectForKey: UIFontDescriptorSizeAttribute] doubleValue]+ 39.0);
}

@end


@interface ORKImplicitAssociationContentView ()

@end


@implementation ORKImplicitAssociationContentView {
    
    UIView *_leftItemContainer;
    UIView *_rightItemContainer;
    ORKWrongLabel *_wrongLabel;
    ORKFormSectionTitleLabel *_hintLabel;
    UIView *_buttonContainer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _leftItemContainer = [UIView new];
        _leftItemContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemContainer = [UIView new];
        _rightItemContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftItemLabel1 = [ORKSubheadlineLabel new];
        _leftItemLabel1.textColor = [UIColor blueColor];
        _leftItemLabel1.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftDividerLabel = [ORKSubheadlineLabel new];
        _leftDividerLabel.textColor = [UIColor blackColor];
        _leftDividerLabel.textAlignment = NSTextAlignmentCenter;
        _leftDividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftItemLabel2 = [ORKSubheadlineLabel new];
        _leftItemLabel2.textColor = [UIColor colorWithRed:45.0/255.0 green:145.0/255.0 blue:0.0 alpha:1.0];
        _leftItemLabel2.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemLabel1 = [ORKSubheadlineLabel new];
        _rightItemLabel1.textColor = [UIColor blueColor];
        _rightItemLabel1.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightDividerLabel = [ORKSubheadlineLabel new];
        _rightDividerLabel.textColor = [UIColor blackColor];
        _rightDividerLabel.textAlignment = NSTextAlignmentCenter;
        _rightDividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemLabel2 = [ORKSubheadlineLabel new];
        _rightItemLabel2.textColor = [UIColor colorWithRed:45.0/255.0 green:145.0/255.0 blue:0.0 alpha:1.0];
        _rightItemLabel2.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _termLabel = [ORKHeadlineLabel new];
        _termLabel.textAlignment = NSTextAlignmentCenter;
        _termLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _startLabel = [ORKHeadlineLabel new];
        _startLabel.textAlignment = NSTextAlignmentCenter;
        _startLabel.numberOfLines = 0;
        _startLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _wrongLabel = [ORKWrongLabel new];
        _wrongLabel.textAlignment = NSTextAlignmentCenter;
        _wrongLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _hintLabel = [ORKFormSectionTitleLabel new];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.numberOfLines = 0;
        _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _buttonContainer = [UIView new];
        _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _tapButton1 = [[ORKRoundTappingButton alloc] init];
        _tapButton1.translatesAutoresizingMaskIntoConstraints = NO;
        [_tapButton1 setTitle:ORKLocalizedString(@"TAP_BUTTON_TITLE", nil) forState:UIControlStateNormal];
        
        _tapButton2 = [[ORKRoundTappingButton alloc] init];
        _tapButton2.translatesAutoresizingMaskIntoConstraints = NO;
        [_tapButton2 setTitle:ORKLocalizedString(@"TAP_BUTTON_TITLE", nil) forState:UIControlStateNormal];
        
        [self addSubview:_leftItemContainer];
        [self addSubview:_rightItemContainer];
        [self addSubview:_termLabel];
        [self addSubview:_startLabel];
        [self addSubview:_wrongLabel];
        [self addSubview:_hintLabel];
        [self addSubview:_buttonContainer];
        
        [_buttonContainer addSubview:_tapButton1];
        [_buttonContainer addSubview:_tapButton2];
        
        [_leftItemContainer addSubview:_leftItemLabel1];
        [_leftItemContainer addSubview:_leftDividerLabel];
        [_leftItemContainer addSubview:_leftItemLabel2];
        
        [_rightItemContainer addSubview:_rightItemLabel1];
        [_rightItemContainer addSubview:_rightDividerLabel];
        [_rightItemContainer addSubview:_rightItemLabel2];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftDividerLabel.text = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_ITEM_DIVIDER", nil);
        _rightDividerLabel.text = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_ITEM_DIVIDER", nil);
        
        NSAttributedString *start1 = [[NSAttributedString alloc] initWithString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_START_LABEL_1", nil)];
        NSAttributedString *startButton = [[NSAttributedString alloc] initWithString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_START_LABEL_BUTTON", nil) attributes : @{ NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold] }];
        NSAttributedString *start2 = [[NSAttributedString alloc] initWithString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_START_LABEL_2", nil)];
        NSMutableAttributedString *start = [NSMutableAttributedString new];
        [start appendAttributedString:start1];
        [start appendAttributedString:startButton];
        [start appendAttributedString:start2];
        _startLabel.attributedText = start;
        
        _hintLabel.attributedText = [self wrongHint];
        
        [self setUpConstraints];
        
#if LAYOUT_DEBUG
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
        _leftItemContainer.backgroundColor = [UIColor redColor];
        _rightItemContainer.backgroundColor = [UIColor purpleColor];
        self.termLabel.backgroundColor = [UIColor orangeColor];
        _wrongLabel.backgroundColor = [UIColor greenColor];
        _hintLabel.backgroundColor = [UIColor yellowColor];
        _buttonContainer.backgroundColor = [UIColor blueColor];
#endif
    }
    return self;
}

- (void)setWrong:(BOOL)wrong {
    _wrongLabel.hidden = !wrong;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
}

- (NSAttributedString *)wrongHint {
    NSAttributedString *wrongX = [[NSAttributedString alloc] initWithString : @" X " attributes : @{ NSForegroundColorAttributeName : [UIColor redColor] }];
    _wrongLabel.attributedText = wrongX;
    NSAttributedString *hint1 = [[NSAttributedString alloc] initWithString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_HINT_LABEL_1", nil)];
    NSAttributedString *hint2 = [[NSAttributedString alloc] initWithString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_HINT_LABEL_2", nil)];
    NSMutableAttributedString *hint = [NSMutableAttributedString new];
    [hint appendAttributedString:hint1];
    [hint appendAttributedString:wrongX];
    [hint appendAttributedString:hint2];
    return [hint copy];
}

- (void)resetStep:(ORKActiveStepViewController *)viewController {
    [super resetStep:viewController];
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_leftItemContainer, _leftItemLabel1, _leftDividerLabel, _leftItemLabel2, _rightItemContainer, _rightItemLabel1, _rightDividerLabel, _rightItemLabel2, _termLabel, _startLabel, _wrongLabel, _hintLabel, _buttonContainer, _tapButton1, _tapButton2);
    
    // left items
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_leftItemContainer
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_leftItemContainer
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftItemLabel1]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftDividerLabel]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftItemLabel2]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftItemLabel1]-(>=10)-[_leftDividerLabel]-(>=10)-[_leftItemLabel2]|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    // right items
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_rightItemContainer
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_rightItemContainer
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.0
                                                         constant:8.0]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightItemLabel1]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightDividerLabel]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightItemLabel2]|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightItemLabel1]-(>=10)-[_rightDividerLabel]-(>=10)-[_rightItemLabel2]|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    // terms
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_termLabel
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_startLabel]-|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];
    
    // hint
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_hintLabel]-|"
                                             options:(NSLayoutFormatOptions)0
                                             metrics:nil
                                               views:views]];

    // buttons
    
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
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_buttonContainer
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0
                                                         constant:window.bounds.size.height - 300]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_buttonContainer
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    // terms and buttons alignment
    
    
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=200)-[_wrongLabel]-(==10)-[_hintLabel]-(==10)-[_buttonContainer]-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=150)-[_termLabel]-[_startLabel]-(>=8)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
}

@end
