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

#import "ORKActiveStepTimer.h"
#import "ORKHeadlineLabel.h"
#import "ORKSubheadlineLabel.h"
#import "ORKRoundTappingButton.h"
#import "ORKImplicitAssociationContentView.h"
#import "ORKVerticalContainerView.h"

#import "ORKActiveStepViewController_Internal.h"
#import "ORKStepViewController_Internal.h"

#import "ORKActiveStepView.h"
#import "ORKResult.h"
#import "ORKStep.h"

#import "ORKHelpers_Internal.h"


@interface ORKImplicitAssociationStepViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *samples;
@property (nonatomic) NSUInteger currentTrial;

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
    [_implicitAssociationContentView.tapButton1 addTarget:self action:@selector(buttonPressed:forEvent:) forControlEvents:UIControlEventTouchDown];
    [_implicitAssociationContentView.tapButton2 addTarget:self action:@selector(buttonPressed:forEvent:) forControlEvents:UIControlEventTouchDown];
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
    if (_currentTrial >= [self trials].count) {
        [self stepDidFinish];
        return;
    }
    [_implicitAssociationContentView setWrong:NO];
    [_implicitAssociationContentView setMode:ORKImplicitAssociationModeTrial];
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrial];
    [_implicitAssociationContentView setTerm:trial.term fromCategory:trial.category];
    _stimulusTimestamp = [NSProcessInfo processInfo].systemUptime;
}

- (void)setupItems {
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrial];
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

- (void)receiveTouch:(UITouch *)touch onButton:(ORKTappingButtonIdentifier)buttonIdentifier {
    ORKImplicitAssociationTrial *trial = [self trials][_currentTrial];
    if (trial.buttonIdentifier == buttonIdentifier) {
        ORKImplicitAssociationResult *implicitAssociationResult = [[ORKImplicitAssociationResult alloc] initWithIdentifier:self.step.identifier];
        implicitAssociationResult.latency = touch.timestamp - _stimulusTimestamp;
        [_results addObject:implicitAssociationResult];
        _currentTrial += 1;
        [self setupTrial];
    } else {
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
    NSInteger index = (button == _implicitAssociationContentView.tapButton1) ? ORKTappingButtonIdentifierLeft : ORKTappingButtonIdentifierRight;
    [self receiveTouch:[[event touchesForView:button] anyObject] onButton:index];
}
@end
