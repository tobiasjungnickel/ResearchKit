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
#import "ORKResult.h"

#import "ORKHelpers_Internal.h"
#import "ORKSkin.h"

#define kAttributeColor [UIColor blueColor]
#define kConceptColor [UIColor colorWithRed:45.0/255.0 green:145.0/255.0 blue:0.0 alpha:1.0]

//#define LAYOUT_DEBUG 1

@interface ORKImplicitAssociationLabel : UILabel
@end
@implementation ORKImplicitAssociationLabel

- (void)setFormattedText:(NSString *)formattedString {
     NSMutableArray *tagsToConvert = [NSMutableArray arrayWithObjects:
     [NSArray arrayWithObjects:@"<red>",@"<font color='red'>",nil],
     [NSArray arrayWithObjects:@"</red>",@"</font>",nil],
     nil];
     
     while ([tagsToConvert count] > 0) {
         formattedString = [formattedString stringByReplacingOccurrencesOfString:[[tagsToConvert objectAtIndex:0] objectAtIndex:0]
                                                                      withString:[[tagsToConvert objectAtIndex:0] objectAtIndex:1]];
         [tagsToConvert removeObjectAtIndex:0];
     }

    
    formattedString = [formattedString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>", self.font.fontName, self.font.pointSize]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[formattedString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
    self.attributedText = attributedString;
}
@end

@interface ORKImplicitAssociationItemLabel : ORKImplicitAssociationLabel
@end
@implementation ORKImplicitAssociationItemLabel

+ (UIFont *)defaultFont {
    // Medium, 25
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return ORKLightFontWithSize([[descriptor objectForKey: UIFontDescriptorSizeAttribute] doubleValue] + 8);
}

@end

@interface ORKImplicitAssociationStartLabel : ORKImplicitAssociationLabel
@end
@implementation ORKImplicitAssociationStartLabel

+ (UIFont *)defaultFont {
    // Medium, 28
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return ORKLightFontWithSize([[descriptor objectForKey: UIFontDescriptorSizeAttribute] doubleValue] + 11);
}

@end

@interface ORKImplicitAssociationWrongLabel : ORKImplicitAssociationLabel
@end
@implementation ORKImplicitAssociationWrongLabel

+ (UIFont *)defaultFont {
    // Medium, 56
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return ORKMediumFontWithSize([[descriptor objectForKey: UIFontDescriptorSizeAttribute] doubleValue] + 39.0);
}

@end

@interface ORKImplicitAssociationHintLabel : ORKImplicitAssociationLabel
@end
@implementation ORKImplicitAssociationHintLabel

+ (UIFont *)defaultFont {
    // regular, 14
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return [UIFont systemFontOfSize:[[descriptor objectForKey: UIFontDescriptorSizeAttribute] doubleValue] - 3.0];
}

@end


@interface ORKImplicitAssociationContentView ()

@end


@implementation ORKImplicitAssociationContentView {
    
    UIView *_leftItemContainer;
    UIView *_rightItemContainer;
    ORKHeadlineLabel *_termLabel;
    ORKImplicitAssociationItemLabel *_leftItemLabel1;
    ORKImplicitAssociationItemLabel *_leftDividerLabel;
    ORKImplicitAssociationItemLabel *_leftItemLabel2;
    ORKImplicitAssociationItemLabel *_rightItemLabel1;
    ORKImplicitAssociationItemLabel *_rightDividerLabel;
    ORKImplicitAssociationItemLabel *_rightItemLabel2;
    ORKImplicitAssociationStartLabel *_startLabel;
    ORKImplicitAssociationWrongLabel *_wrongLabel;
    ORKImplicitAssociationHintLabel *_hintLabel;
    UIView *_buttonContainer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _leftItemContainer = [UIView new];
        _leftItemContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemContainer = [UIView new];
        _rightItemContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftItemLabel1 = [ORKImplicitAssociationItemLabel new];
        _leftItemLabel1.numberOfLines = 2;
        _leftItemLabel1.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftDividerLabel = [ORKImplicitAssociationItemLabel new];
        _leftDividerLabel.textColor = [UIColor blackColor];
        _leftDividerLabel.textAlignment = NSTextAlignmentCenter;
        _leftDividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _leftItemLabel2 = [ORKImplicitAssociationItemLabel new];
        _leftItemLabel2.numberOfLines = 2;
        _leftItemLabel2.textColor = kConceptColor;
        _leftItemLabel2.textAlignment = NSTextAlignmentCenter;
        _leftItemLabel2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemLabel1 = [ORKImplicitAssociationItemLabel new];
        _rightItemLabel1.numberOfLines = 2;
        _rightItemLabel1.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel1.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightDividerLabel = [ORKImplicitAssociationItemLabel new];
        _rightDividerLabel.textColor = [UIColor blackColor];
        _rightDividerLabel.textAlignment = NSTextAlignmentCenter;
        _rightDividerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _rightItemLabel2 = [ORKImplicitAssociationItemLabel new];
        _rightItemLabel2.numberOfLines = 2;
        _rightItemLabel2.textColor = kConceptColor;
        _rightItemLabel2.textAlignment = NSTextAlignmentCenter;
        _rightItemLabel2.translatesAutoresizingMaskIntoConstraints = NO;
        
        _termLabel = [ORKHeadlineLabel new];
        _termLabel.textAlignment = NSTextAlignmentCenter;
        _termLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _startLabel = [ORKImplicitAssociationStartLabel new];
        _startLabel.textAlignment = NSTextAlignmentCenter;
        _startLabel.numberOfLines = 0;
        _startLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _wrongLabel = [ORKImplicitAssociationWrongLabel new];
        _wrongLabel.textAlignment = NSTextAlignmentCenter;
        _wrongLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _hintLabel = [ORKImplicitAssociationHintLabel new];
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

        [_startLabel setFormattedText:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_START_LABEL", nil)];

        NSAttributedString *wrongX = [[NSAttributedString alloc] initWithString : @"X" attributes : @{ NSForegroundColorAttributeName : [UIColor redColor] }];
        _wrongLabel.attributedText = wrongX;
        
        [_hintLabel setFormattedText:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_HINT_LABEL", nil)];
        
        [self setUpConstraints];
        
#if LAYOUT_DEBUG
        self.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
        _leftItemContainer.backgroundColor = [UIColor redColor];
        _rightItemContainer.backgroundColor = [UIColor purpleColor];
        _termLabel.backgroundColor = [UIColor orangeColor];
        _startLabel.backgroundColor = [UIColor cyanColor];
        _wrongLabel.backgroundColor = [UIColor greenColor];
        _hintLabel.backgroundColor = [UIColor yellowColor];
        _buttonContainer.backgroundColor = [UIColor blueColor];
#endif
    }
    return self;
}

- (void)setMode:(ORKImplicitAssociationMode)mode {
    if (mode == ORKImplicitAssociationModeInstruction) {
        _termLabel.hidden = YES;
        _startLabel.hidden = NO;
    } else {
        _termLabel.hidden = NO;
        _startLabel.hidden = YES;
    }
}

- (void)setTerm:(NSString *)term fromCategory:(ORKImplicitAssociationCategory)category {
    _termLabel.text = term;
    _termLabel.textColor = category == ORKImplicitAssociationCategoryAttribute ? kAttributeColor : kConceptColor;
}

- (void)setItemLeft:(NSString *)left itemRight:(NSString *)right fromCategory:(ORKImplicitAssociationCategory)category {
    _leftItemLabel2.hidden = YES;
    _rightItemLabel2.hidden = YES;
    _leftDividerLabel.hidden = YES;
    _rightDividerLabel.hidden = YES;
    _leftItemLabel1.text = left;
    _rightItemLabel1.text = right;
    _leftItemLabel1.textColor = category == ORKImplicitAssociationCategoryAttribute ? kAttributeColor : kConceptColor;
    _rightItemLabel1.textColor = category == ORKImplicitAssociationCategoryAttribute ? kAttributeColor : kConceptColor;
}

- (void)setItemLeftUpper:(NSString *)leftUpper itemRightUpper:(NSString *)rightUpper itemLeftLowerr:(NSString *)leftLower itemRightLower:(NSString *)rightLower {
    _leftItemLabel1.text = leftUpper;
    _rightItemLabel1.text = rightUpper;
    _leftItemLabel2.text = leftLower;
    _rightItemLabel2.text = rightLower;
    _leftItemLabel1.textColor = kAttributeColor;
    _rightItemLabel1.textColor = kAttributeColor;
}

- (void)setWrong:(BOOL)wrong {
    _wrongLabel.hidden = !wrong;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
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
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftItemContainer]-(>=24)-[_rightItemContainer(==_leftItemContainer)]|"
                                             options:(NSLayoutFormatOptions)0
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=220)-[_wrongLabel]-(==10)-[_hintLabel]-(==10)-[_buttonContainer]-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [constraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=200)-[_termLabel]-(>=8)-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:views]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_termLabel
                                                        attribute:NSLayoutAttributeFirstBaseline
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_startLabel
                                                        attribute:NSLayoutAttributeFirstBaseline
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    
    [NSLayoutConstraint activateConstraints:constraints];
    
}

@end
