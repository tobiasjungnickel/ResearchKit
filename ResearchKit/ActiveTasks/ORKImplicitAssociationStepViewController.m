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


#import "ORKImplicitAssociationStepViewController.h"







#import "ORKImplicitAssociationStep.h"
#import "ORKImplicitAssociationTrial.h"
#import "ORKImplicitAssociationResult.h"

#import "ORKActiveStepTimer.h"
#import "ORKHeadlineLabel.h"
#import "ORKSubheadlineLabel.h"
#import "ORKRoundTappingButton.h"
#import "ORKImplicitAssociationContentView.h"
#import "ORKVerticalContainerView.h"

#import "ORKActiveStepViewController_Internal.h"
#import "ORKStepViewController_Internal.h"
#import "ORKCollectionResult_Private.h"

#import "ORKActiveStepView.h"
#import "ORKResult.h"
#import "ORKStep.h"

#import "ORKHelpers_Internal.h"


@interface ORKImplicitAssociationStepViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *samples;
@property (nonatomic) NSUInteger currentTrialNumber;
@property (nonatomic) BOOL currentTrialWrong;

@end


@implementation ORKImplicitAssociationStepViewController {
    ORKImplicitAssociationContentView *_implicitAssociationContentView;
    NSMutableArray *_results;
    NSTimeInterval _stimulusTimestamp;
}

- (instancetype)initWithStep:(ORKStep *)step {
    self = [super initWithStep:step];
    if (self) {
        self.suspendIfInactive = YES;
    }
    return self;
}

- (void)initializeInternalButtonItems {
    [super initializeInternalButtonItems];
    self.internalContinueButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _results = [NSMutableArray new];
    _implicitAssociationContentView = [[ORKImplicitAssociationContentView alloc] init];
    self.activeStepView.activeCustomView = _implicitAssociationContentView;
    [_implicitAssociationContentView.leftButton addTarget:self action:@selector(buttonPressed:forEvent:) forControlEvents:UIControlEventTouchDown];
    [_implicitAssociationContentView.rightButton addTarget:self action:@selector(buttonPressed:forEvent:) forControlEvents:UIControlEventTouchDown];
    [self setupItems];
    [self setupInstruction];
}

- (NSArray *)trials {
    return ((ORKImplicitAssociationStep *)self.step).trials;
}

- (ORKImplicitAssociationBlockType)block {
    return ((ORKImplicitAssociationStep *)self.step).block;
}

- (void)setupInstruction {
    [_implicitAssociationContentView setWrong:NO];
    [_implicitAssociationContentView setMode:ORKImplicitAssociationModeInstruction];
}

- (void)setupTrial {
    if (_currentTrialNumber >= [self trials].count) {
        [self stepDidFinish];
        return;
    }
    _currentTrialWrong = NO;
    [_implicitAssociationContentView setWrong:NO];
    [_implicitAssociationContentView setMode:ORKImplicitAssociationModeTrial];
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrialNumber];
    [_implicitAssociationContentView setTerm:trial.term fromCategory:trial.category];
    [_implicitAssociationContentView setInteractionEnabled:YES];
    _stimulusTimestamp = [NSProcessInfo processInfo].systemUptime;
}

- (void)setupItems {
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrialNumber];
    if ([self block] == ORKImplicitAssociationBlockTypeSort) {
        //sorting
        [_implicitAssociationContentView setItemLeft:trial.leftItem1 itemRight:trial.rightItem1 fromCategory:trial.category];
    } else {
        //combined
        [_implicitAssociationContentView setItemLeftUpper:trial.leftItem1 itemRightUpper:trial.rightItem1 itemLeftLowerr:trial.leftItem2 itemRightLower:trial.rightItem2];
    }
}

- (ORKStepResult *)result {
    ORKStepResult *stepResult = [super result];
    stepResult.results = [self.addedResults arrayByAddingObjectsFromArray:_results] ? : _results;
    return stepResult;
}

- (void)receiveTimestamp:(NSTimeInterval)timestamp onButton:(ORKTappingButtonIdentifier)buttonIdentifier {
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrialNumber];
    if (trial.buttonIdentifier == buttonIdentifier) {
        [_implicitAssociationContentView setInteractionEnabled:NO];
        [_implicitAssociationContentView setWrong:NO];
        ORKImplicitAssociationResult *implicitAssociationResult = [[ORKImplicitAssociationResult alloc] initWithIdentifier:self.step.identifier];
        implicitAssociationResult.latency = timestamp - _stimulusTimestamp;
        implicitAssociationResult.correct = ORKImplicitAssociationCorrectValue(trial.correct);
        if (trial.rightItem2 == nil) {
            implicitAssociationResult.pairing = [NSString stringWithFormat:@"%@,%@", trial.leftItem1, trial.rightItem1];
        } else {
            implicitAssociationResult.pairing = [NSString stringWithFormat:@"%@/%@,%@/%@", trial.leftItem1, trial.leftItem2, trial.rightItem1, trial.rightItem2];
        }
        implicitAssociationResult.error = _currentTrialWrong;
        [_results addObject:implicitAssociationResult];
        _currentTrialNumber += 1;
        [NSTimer scheduledTimerWithTimeInterval:0.25f
                                         target:self
                                       selector:@selector(setupTrial)
                                       userInfo:nil
                                        repeats:NO];
        
    } else {
        _currentTrialWrong = YES;
        [_implicitAssociationContentView setWrong:YES];
    }
}

- (void)stepDidFinish {
    [super stepDidFinish];
    [_implicitAssociationContentView finishStep:self];
    [self goForward];
}

- (void)start {
    [super start];
    [self setupTrial];
    self.backButtonItem = nil;
}


#pragma mark buttonAction

- (IBAction)buttonPressed:(id)button forEvent:(UIEvent *)event {
    if (!self.started) {
        [self start];
        return;
    }
    NSInteger index = (button == _implicitAssociationContentView.leftButton) ? ORKTappingButtonIdentifierLeft : ORKTappingButtonIdentifierRight;
    [self receiveTimestamp:[[[event touchesForView:button] anyObject] timestamp] onButton:index];
}


#pragma mark keypressAction

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (!self.started) {
        [self start];
        return;
    }
    UIPress *keypress = presses.allObjects.firstObject;
    switch (keypress.key.keyCode) {
        case UIKeyboardHIDUsageKeyboardE:
            NSLog(@"E");
            [self receiveTimestamp:event.timestamp/1000000000 onButton:ORKTappingButtonIdentifierLeft];
            break;
        case UIKeyboardHIDUsageKeyboardI:
            NSLog(@"I");
            [self receiveTimestamp:event.timestamp/1000000000 onButton:ORKTappingButtonIdentifierRight];
            break;
        default:
            [super pressesBegan:presses withEvent:event];
            break;
    }
}

@end
