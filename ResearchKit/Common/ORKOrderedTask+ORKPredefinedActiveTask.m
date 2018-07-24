/*
 Copyright (c) 2015, Apple Inc. All rights reserved.
 Copyright (c) 2016, Sage Bionetworks
 
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


#import "ORKOrderedTask+ORKPredefinedActiveTask.h"
#import "ORKOrderedTask_Private.h"

#import "ORKAudioStepViewController.h"
#import "ORKAmslerGridStepViewController.h"
#import "ORKCountdownStepViewController.h"
#import "ORKTouchAnywhereStepViewController.h"
#import "ORKFitnessStepViewController.h"
#import "ORKToneAudiometryStepViewController.h"
#import "ORKSpatialSpanMemoryStepViewController.h"
#import "ORKSpeechRecognitionStepViewController.h"
#import "ORKStroopStepViewController.h"
#import "ORKWalkingTaskStepViewController.h"

#import "ORKAccelerometerRecorder.h"
#import "ORKActiveStep_Internal.h"
#import "ORKAmslerGridStep.h"
#import "ORKAnswerFormat_Internal.h"
#import "ORKAudioLevelNavigationRule.h"
#import "ORKAudioRecorder.h"
#import "ORKAudioStep.h"
#import "ORKCompletionStep.h"
#import "ORKCountdownStep.h"
#import "ORKEnvironmentSPLMeterStep.h"
#import "ORKHolePegTestPlaceStep.h"
#import "ORKHolePegTestRemoveStep.h"
#import "ORKTouchAnywhereStep.h"
#import "ORKFitnessStep.h"
#import "ORKFormStep.h"
#import "ORKNavigableOrderedTask.h"
#import "ORKPSATStep.h"
#import "ORKQuestionStep.h"
#import "ORKReactionTimeStep.h"
#import "ORKSpatialSpanMemoryStep.h"
#import "ORKSpeechRecognitionStep.h"
#import "ORKStep_Private.h"
#import "ORKStroopStep.h"
#import "ORKTappingIntervalStep.h"
#import "ORKTimedWalkStep.h"
#import "ORKToneAudiometryStep.h"
#import "ORKTowerOfHanoiStep.h"
#import "ORKTrailmakingStep.h"
#import "ORKVisualConsentStep.h"
#import "ORKRangeOfMotionStep.h"
#import "ORKShoulderRangeOfMotionStep.h"
#import "ORKWaitStep.h"
#import "ORKWalkingTaskStep.h"
#import "ORKImplicitAssociationStep.h"
#import "ORKImplicitAssociationCategoriesInstructionStep.h"
#import "ORKResultPredicate.h"
#import "ORKSpeechInNoiseStep.h"
#import "ORKdBHLToneAudiometryStep.h"
#import "ORKdBHLToneAudiometryOnboardingStep.h"
#import "ORKSkin.h"

#import "ORKImplicitAssociationTrial.h"
#import "ORKImplicitAssociationHelper.h"

#import "ORKHelpers_Internal.h"
#import "UIImage+ResearchKit.h"
#import <limits.h>


ORKTaskProgress ORKTaskProgressMake(NSUInteger current, NSUInteger total) {
    return (ORKTaskProgress){.current=current, .total=total};
}

#pragma mark - Predefined

NSString *const ORKInstruction0StepIdentifier = @"instruction";
NSString *const ORKInstruction1StepIdentifier = @"instruction1";
NSString *const ORKInstruction2StepIdentifier = @"instruction2";
NSString *const ORKInstruction3StepIdentifier = @"instruction3";
NSString *const ORKInstruction4StepIdentifier = @"instruction4";
NSString *const ORKInstruction5StepIdentifier = @"instruction5";
NSString *const ORKInstruction6StepIdentifier = @"instruction6";
NSString *const ORKInstruction7StepIdentifier = @"instruction7";

NSString *const ORKCountdownStepIdentifier = @"countdown";
NSString *const ORKCountdown1StepIdentifier = @"countdown1";
NSString *const ORKCountdown2StepIdentifier = @"countdown2";
NSString *const ORKCountdown3StepIdentifier = @"countdown3";
NSString *const ORKCountdown4StepIdentifier = @"countdown4";
NSString *const ORKCountdown5StepIdentifier = @"countdown5";

NSString *const ORKEditSpeechTranscript0StepIdentifier = @"editSpeechTranscript0";

NSString *const ORKConclusionStepIdentifier = @"conclusion";

NSString *const ORKActiveTaskLeftHandIdentifier = @"left";
NSString *const ORKActiveTaskMostAffectedHandIdentifier = @"mostAffected";
NSString *const ORKActiveTaskRightHandIdentifier = @"right";
NSString *const ORKActiveTaskSkipHandStepIdentifier = @"skipHand";

NSString *const ORKTouchAnywhereStepIdentifier = @"touch.anywhere";

NSString *const ORKAudioRecorderIdentifier = @"audio";
NSString *const ORKAccelerometerRecorderIdentifier = @"accelerometer";
NSString *const ORKStreamingAudioRecorderIdentifier = @"streamingAudio";
NSString *const ORKPedometerRecorderIdentifier = @"pedometer";
NSString *const ORKDeviceMotionRecorderIdentifier = @"deviceMotion";
NSString *const ORKLocationRecorderIdentifier = @"location";
NSString *const ORKHeartRateRecorderIdentifier = @"heartRate";
NSString *const ORKImplicitAssociationIntroductionCategoriesStepIdentifier = @"implicitAssociation.introductionCategories";
NSString *const ORKImplicitAssociationIntroductionBlocksStepIdentifier = @"implicitAssociation.introductionBlocks";
NSString *const ORKImplicitAssociationBlock1StepIdentifier = @"implicitAssociation.block1";
NSString *const ORKImplicitAssociationBlock2StepIdentifier = @"implicitAssociation.block2";
NSString *const ORKImplicitAssociationBlock3StepIdentifier = @"implicitAssociation.block3";
NSString *const ORKImplicitAssociationBlock4StepIdentifier = @"implicitAssociation.block4";
NSString *const ORKImplicitAssociationBlock5StepIdentifier = @"implicitAssociation.block5";
NSString *const ORKImplicitAssociationBlock6StepIdentifier = @"implicitAssociation.block6";
NSString *const ORKImplicitAssociationBlock7StepIdentifier = @"implicitAssociation.block7";
NSString *const ORKImplicitAssociationBlock1IntroductionStepIdentifier = @"implicitAssociation.intro1";
NSString *const ORKImplicitAssociationBlock2IntroductionStepIdentifier = @"implicitAssociation.intro2";
NSString *const ORKImplicitAssociationBlock3IntroductionStepIdentifier = @"implicitAssociation.intro3";
NSString *const ORKImplicitAssociationBlock4IntroductionStepIdentifier = @"implicitAssociation.intro4";
NSString *const ORKImplicitAssociationBlock5IntroductionStepIdentifier = @"implicitAssociation.intro5";
NSString *const ORKImplicitAssociationBlock6IntroductionStepIdentifier = @"implicitAssociation.intro6";
NSString *const ORKImplicitAssociationBlock7IntroductionStepIdentifier = @"implicitAssociation.intro7";

void ORKStepArrayAddStep(NSMutableArray *array, ORKStep *step) {
    [step validateParameters];
    [array addObject:step];
}

@implementation ORKOrderedTask (ORKMakeTaskUtilities)

+ (ORKCompletionStep *)makeCompletionStep {
    ORKCompletionStep *step = [[ORKCompletionStep alloc] initWithIdentifier:ORKConclusionStepIdentifier];
    step.title = ORKLocalizedString(@"TASK_COMPLETE_TITLE", nil);
    step.text = ORKLocalizedString(@"TASK_COMPLETE_TEXT", nil);
    step.shouldTintImages = YES;
    return step;
}

+ (NSDateComponentsFormatter *)textTimeFormatter {
    NSDateComponentsFormatter *formatter = [NSDateComponentsFormatter new];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleSpellOut;
    
    // Exception list: Korean, Chinese (all), Thai, and Vietnamese.
    NSArray *nonSpelledOutLanguages = @[@"ko", @"zh", @"th", @"vi", @"ja"];
    NSString *currentLanguage = [[NSBundle mainBundle] preferredLocalizations].firstObject;
    NSString *currentLanguageCode = [NSLocale componentsFromLocaleIdentifier:currentLanguage][NSLocaleLanguageCode];
    if ((currentLanguageCode != nil) && [nonSpelledOutLanguages containsObject:currentLanguageCode]) {
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    }
    
    formatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorDropAll;
    return formatter;
}

@end


@implementation ORKOrderedTask (ORKPredefinedActiveTask)

#pragma mark - AmslerGridTask

NSString *const ORKAmslerGridStepLeftIdentifier = @"amsler.grid.left";
NSString *const ORKAmslerGridStepRightIdentifier = @"amsler.grid.right";
NSString *const ORKAmslerGridCalibrationLeftIdentifier = @"amsler.grid.calibration.left";
NSString *const ORKAmslerGridCalibrationRightIdentifier = @"amsler.grid.calibration.Right";

+ (ORKOrderedTask *)amslerGridTaskWithIdentifier:(NSString *)identifier
                                   intendedUseDescription:(NSString *)intendedUseDescription
                                                  options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    UIColor *tintColor = [[[UIApplication sharedApplication] delegate] window].tintColor ? : ORKColor(ORKBlueHighlightColorKey);

    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"AMSLER_GRID_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"AMSLER_GRID_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"amslerGrid" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        {
            
            
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"AMSLER_GRID_TITLE", nil);
            step.text = ORKLocalizedString(@"AMSLER_GRID_INSTRUCTION_TEXT", nil);

            NSString *leftEye = ORKLocalizedString(@"AMSLER_GRID_LEFT_EYE", nil);
            NSString *detailText = [@"\n" stringByAppendingString:[NSString stringWithFormat:ORKLocalizedString(@"AMSLER_GRID_INSTRUCTION_DETAIL_TEXT", nil), leftEye]];

            NSMutableAttributedString *attributedDetailText = [[NSMutableAttributedString alloc] initWithString:detailText];
            [attributedDetailText addAttribute:NSForegroundColorAttributeName
                                         value:tintColor
                                         range:[detailText rangeOfString:leftEye]];
            step.attributedDetailText = attributedDetailText;
            
            step.image = [UIImage imageNamed:@"amslerGrid" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    {
        ORKAmslerGridStep *step = [[ORKAmslerGridStep alloc] initWithIdentifier:ORKAmslerGridStepLeftIdentifier];
        step.eyeSide = ORKAmslerGridEyeSideLeft;
        ORKStepArrayAddStep(steps, step);
    }
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction2StepIdentifier];
            step.title = ORKLocalizedString(@"AMSLER_GRID_TITLE", nil);
            step.text = ORKLocalizedString(@"AMSLER_GRID_INSTRUCTION_TEXT", nil);
            NSString *rightEye = ORKLocalizedString(@"AMSLER_GRID_RIGHT_EYE", nil);
            NSString *detailText = [@"\n" stringByAppendingString:[NSString stringWithFormat:ORKLocalizedString(@"AMSLER_GRID_INSTRUCTION_DETAIL_TEXT", nil), rightEye]];
            
            NSMutableAttributedString *attributedDetailText = [[NSMutableAttributedString alloc] initWithString:detailText];
            [attributedDetailText addAttribute:NSForegroundColorAttributeName
                                         value:tintColor
                                         range:[detailText rangeOfString:rightEye]];
            step.attributedDetailText = attributedDetailText;
            step.image = [UIImage imageNamed:@"amslerGrid" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    {
        ORKAmslerGridStep *step = [[ORKAmslerGridStep alloc] initWithIdentifier:ORKAmslerGridStepRightIdentifier];
        step.eyeSide = ORKAmslerGridEyeSideRight;
        ORKStepArrayAddStep(steps, step);
    }
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKCompletionStep *completionStep = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, completionStep);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}

#pragma mark - holePegTestTask

NSString *const ORKHolePegTestDominantPlaceStepIdentifier = @"hole.peg.test.dominant.place";
NSString *const ORKHolePegTestDominantRemoveStepIdentifier = @"hole.peg.test.dominant.remove";
NSString *const ORKHolePegTestNonDominantPlaceStepIdentifier = @"hole.peg.test.non.dominant.place";
NSString *const ORKHolePegTestNonDominantRemoveStepIdentifier = @"hole.peg.test.non.dominant.remove";

+ (ORKNavigableOrderedTask *)holePegTestTaskWithIdentifier:(NSString *)identifier
                                    intendedUseDescription:(nullable NSString *)intendedUseDescription
                                              dominantHand:(ORKBodySagittal)dominantHand
                                              numberOfPegs:(int)numberOfPegs
                                                 threshold:(double)threshold
                                                   rotated:(BOOL)rotated
                                                 timeLimit:(NSTimeInterval)timeLimit
                                                   options:(ORKPredefinedTaskOption)options {
    
    NSMutableArray *steps = [NSMutableArray array];
    BOOL dominantHandLeft = (dominantHand == ORKBodySagittalLeft);
    NSTimeInterval stepDuration = (timeLimit == 0) ? CGFLOAT_MAX : timeLimit;
    NSString *pegs = [NSNumberFormatter localizedStringFromNumber:@(numberOfPegs) numberStyle:NSNumberFormatterNoStyle];

    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = intendedUseDescription;
            step.detailText = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_INTRO_TEXT_%@", nil), pegs];
            step.image = [UIImage imageNamed:@"phoneholepeg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = dominantHandLeft ? [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_INTRO_TEXT_2_LEFT_HAND_FIRST_%@", nil), pegs, pegs] : [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_INTRO_TEXT_2_RIGHT_HAND_FIRST_%@", nil), pegs, pegs];
            step.detailText = ORKLocalizedString(@"HOLE_PEG_TEST_CALL_TO_ACTION", nil);
            UIImage *image1 = [UIImage imageNamed:@"holepegtest1" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *image2 = [UIImage imageNamed:@"holepegtest2" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *image3 = [UIImage imageNamed:@"holepegtest3" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *image4 = [UIImage imageNamed:@"holepegtest4" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *image5 = [UIImage imageNamed:@"holepegtest5" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *image6 = [UIImage imageNamed:@"holepegtest6" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.image = [UIImage animatedImageWithImages:@[image1, image2, image3, image4, image5, image6] duration:4];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        {
            ORKHolePegTestPlaceStep *step = [[ORKHolePegTestPlaceStep alloc] initWithIdentifier:ORKHolePegTestDominantPlaceStepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = [dominantHandLeft ? ORKLocalizedString(@"HOLE_PEG_TEST_PLACE_INSTRUCTION_LEFT_HAND", nil) : ORKLocalizedString(@"HOLE_PEG_TEST_PLACE_INSTRUCTION_RIGHT_HAND", nil) stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"HOLE_PEG_TEST_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.movingDirection = dominantHand;
            step.dominantHandTested = YES;
            step.numberOfPegs = numberOfPegs;
            step.threshold = threshold;
            step.rotated = rotated;
            step.shouldTintImages = YES;
            step.stepDuration = stepDuration;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKHolePegTestRemoveStep *step = [[ORKHolePegTestRemoveStep alloc] initWithIdentifier:ORKHolePegTestDominantRemoveStepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = [dominantHandLeft ? ORKLocalizedString(@"HOLE_PEG_TEST_REMOVE_INSTRUCTION_LEFT_HAND", nil) : ORKLocalizedString(@"HOLE_PEG_TEST_REMOVE_INSTRUCTION_RIGHT_HAND", nil) stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"HOLE_PEG_TEST_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.movingDirection = (dominantHand == ORKBodySagittalLeft) ? ORKBodySagittalRight : ORKBodySagittalLeft;
            step.dominantHandTested = YES;
            step.numberOfPegs = numberOfPegs;
            step.threshold = threshold;
            step.shouldTintImages = YES;
            step.stepDuration = stepDuration;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKHolePegTestPlaceStep *step = [[ORKHolePegTestPlaceStep alloc] initWithIdentifier:ORKHolePegTestNonDominantPlaceStepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = [dominantHandLeft ? ORKLocalizedString(@"HOLE_PEG_TEST_PLACE_INSTRUCTION_RIGHT_HAND", nil) : ORKLocalizedString(@"HOLE_PEG_TEST_PLACE_INSTRUCTION_LEFT_HAND", nil) stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"HOLE_PEG_TEST_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.movingDirection = (dominantHand == ORKBodySagittalLeft) ? ORKBodySagittalRight : ORKBodySagittalLeft;
            step.dominantHandTested = NO;
            step.numberOfPegs = numberOfPegs;
            step.threshold = threshold;
            step.rotated = rotated;
            step.shouldTintImages = YES;
            step.stepDuration = stepDuration;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKHolePegTestRemoveStep *step = [[ORKHolePegTestRemoveStep alloc] initWithIdentifier:ORKHolePegTestNonDominantRemoveStepIdentifier];
            step.title = [[NSString alloc] initWithFormat:ORKLocalizedString(@"HOLE_PEG_TEST_TITLE_%@", nil), pegs];
            step.text = [dominantHandLeft ? ORKLocalizedString(@"HOLE_PEG_TEST_REMOVE_INSTRUCTION_RIGHT_HAND", nil) : ORKLocalizedString(@"HOLE_PEG_TEST_REMOVE_INSTRUCTION_LEFT_HAND", nil) stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"HOLE_PEG_TEST_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.movingDirection = dominantHand;
            step.dominantHandTested = NO;
            step.numberOfPegs = numberOfPegs;
            step.threshold = threshold;
            step.shouldTintImages = YES;
            step.stepDuration = stepDuration;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKCompletionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    
    // The task is actually dynamic. The direct navigation rules are used for skipping the peg
    // removal steps if the user doesn't succeed in placing all the pegs in the allotted time
    // (the rules are removed from `ORKHolePegTestPlaceStepViewController` if she succeeds).
    ORKNavigableOrderedTask *task = [[ORKNavigableOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    ORKStepNavigationRule *navigationRule = [[ORKDirectStepNavigationRule alloc] initWithDestinationStepIdentifier:ORKHolePegTestNonDominantPlaceStepIdentifier];
    [task setNavigationRule:navigationRule forTriggerStepIdentifier:ORKHolePegTestDominantPlaceStepIdentifier];
    navigationRule = [[ORKDirectStepNavigationRule alloc] initWithDestinationStepIdentifier:ORKConclusionStepIdentifier];
    [task setNavigationRule:navigationRule forTriggerStepIdentifier:ORKHolePegTestNonDominantPlaceStepIdentifier];
    
    return task;
}


#pragma mark - twoFingerTappingInterval

NSString *const ORKTappingStepIdentifier = @"tapping";

+ (ORKOrderedTask *)twoFingerTappingIntervalTaskWithIdentifier:(NSString *)identifier
                                        intendedUseDescription:(NSString *)intendedUseDescription
                                                      duration:(NSTimeInterval)duration
                                                   handOptions:(ORKPredefinedTaskHandOption)handOptions
                                                       options:(ORKPredefinedTaskOption)options {
    
    NSString *durationString = [ORKDurationStringFormatter() stringFromTimeInterval:duration];
    
    NSMutableArray *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TAPPING_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"TAPPING_INTRO_TEXT", nil);
            
            NSString *imageName = @"phonetapping";
            if (![[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
                imageName = [imageName stringByAppendingString:@"_notap"];
            }
            step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    // Setup which hand to start with and how many hands to add based on the handOptions parameter
    // Hand order is randomly determined.
    NSUInteger handCount = ((handOptions & ORKPredefinedTaskHandOptionBoth) == ORKPredefinedTaskHandOptionBoth) ? 2 : 1;
    BOOL undefinedHand = (handOptions == 0);
    BOOL rightHand;
    switch (handOptions) {
        case ORKPredefinedTaskHandOptionLeft:
            rightHand = NO; break;
        case ORKPredefinedTaskHandOptionRight:
        case ORKPredefinedTaskHandOptionUnspecified:
            rightHand = YES; break;
        default:
            rightHand = (arc4random()%2 == 0); break;
        }
        
    for (NSUInteger hand = 1; hand <= handCount; hand++) {
        
        NSString * (^appendIdentifier) (NSString *) = ^ (NSString * identifier) {
            if (undefinedHand) {
                return identifier;
            } else {
                NSString *handIdentifier = rightHand ? ORKActiveTaskRightHandIdentifier : ORKActiveTaskLeftHandIdentifier;
                return [NSString stringWithFormat:@"%@.%@", identifier, handIdentifier];
            }
        };
        
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:appendIdentifier(ORKInstruction1StepIdentifier)];
            
            // Set the title based on the hand
            if (undefinedHand) {
                step.title = ORKLocalizedString(@"TAPPING_TASK_TITLE", nil);
            } else if (rightHand) {
                step.title = ORKLocalizedString(@"TAPPING_TASK_TITLE_RIGHT", nil);
            } else {
                step.title = ORKLocalizedString(@"TAPPING_TASK_TITLE_LEFT", nil);
            }
            
            // Set the instructions for the tapping test screen that is displayed prior to each hand test
            NSString *restText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_REST_PHONE", nil);
            NSString *tappingTextFormat = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_FORMAT", nil);
            NSString *tappingText = [NSString localizedStringWithFormat:tappingTextFormat, durationString];
            NSString *handText = nil;
            
            if (hand == 1) {
                if (undefinedHand) {
                    handText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_MOST_AFFECTED", nil);
                } else if (rightHand) {
                    handText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_RIGHT_FIRST", nil);
                } else {
                    handText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_LEFT_FIRST", nil);
                }
            } else {
                if (rightHand) {
                    handText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_RIGHT_SECOND", nil);
                } else {
                    handText = ORKLocalizedString(@"TAPPING_INTRO_TEXT_2_LEFT_SECOND", nil);
                }
            }
            
            step.text = [NSString localizedStringWithFormat:@"%@ %@ %@", restText, handText, tappingText];
            
            // Continue button will be different from first hand and second hand
            if (hand == 1) {
                step.detailText = ORKLocalizedString(@"TAPPING_CALL_TO_ACTION", nil);
            } else {
                step.detailText = ORKLocalizedString(@"TAPPING_CALL_TO_ACTION_NEXT", nil);
            }
            
            // Set the image
            UIImage *im1 = [UIImage imageNamed:@"handtapping01" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *im2 = [UIImage imageNamed:@"handtapping02" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            UIImage *imageAnimation = [UIImage animatedImageWithImages:@[im1, im2] duration:1];
            
            if (rightHand || undefinedHand) {
                step.image = imageAnimation;
            } else {
                step.image = [imageAnimation ork_flippedImage:UIImageOrientationUpMirrored];
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    
        // TAPPING STEP
    {
        NSMutableArray *recorderConfigurations = [NSMutableArray arrayWithCapacity:5];
        if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
            [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                      frequency:100]];
        }
        
            ORKTappingIntervalStep *step = [[ORKTappingIntervalStep alloc] initWithIdentifier:appendIdentifier(ORKTappingStepIdentifier)];
            step.title = ORKLocalizedString(@"TAPPING_TASK_TITLE", nil);

            if (undefinedHand) {
                step.text = ORKLocalizedString(@"TAPPING_INSTRUCTION", nil);
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TAPPING_INSTRUCTION_RIGHT", nil);
            } else {
                step.text = ORKLocalizedString(@"TAPPING_INSTRUCTION_LEFT", nil);
            }
            step.stepDuration = duration;
            step.shouldContinueOnFinish = YES;
            step.recorderConfigurations = recorderConfigurations;
            step.optional = (handCount == 2);
            
            ORKStepArrayAddStep(steps, step);
        }
        
        // Flip to the other hand (ignored if handCount == 1)
        rightHand = !rightHand;
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:[steps copy]];
    
    return task;
}


#pragma mark - audioTask

NSString *const ORKAudioStepIdentifier = @"audio";
NSString *const ORKAudioTooLoudStepIdentifier = @"audio.tooloud";

+ (ORKNavigableOrderedTask *)audioTaskWithIdentifier:(NSString *)identifier
                              intendedUseDescription:(nullable NSString *)intendedUseDescription
                                   speechInstruction:(nullable NSString *)speechInstruction
                              shortSpeechInstruction:(nullable NSString *)shortSpeechInstruction
                                            duration:(NSTimeInterval)duration
                                   recordingSettings:(nullable NSDictionary *)recordingSettings
                                     checkAudioLevel:(BOOL)checkAudioLevel
                                             options:(ORKPredefinedTaskOption)options {

    recordingSettings = recordingSettings ? : @{ AVFormatIDKey : @(kAudioFormatAppleLossless),
                                                 AVNumberOfChannelsKey : @(2),
                                                AVSampleRateKey: @(44100.0) };
    
    if (options & ORKPredefinedTaskOptionExcludeAudio) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Audio collection cannot be excluded from audio task" userInfo:nil];
    }
    
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"AUDIO_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"AUDIO_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"phonewaves" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"AUDIO_TASK_TITLE", nil);
            step.text = speechInstruction ? : ORKLocalizedString(@"AUDIO_INTRO_TEXT",nil);
            step.detailText = ORKLocalizedString(@"AUDIO_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"phonesoundwaves" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }

    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.stepDuration = 5.0;
        step.title = ORKLocalizedString(@"AUDIO_TASK_TITLE", nil);

        // Collect audio during the countdown step too, to provide a baseline.
        step.recorderConfigurations = @[[[ORKAudioRecorderConfiguration alloc] initWithIdentifier:ORKAudioRecorderIdentifier
                                                                                 recorderSettings:recordingSettings]];
        
        // If checking the sound level then add text indicating that's what is happening
        if (checkAudioLevel) {
            step.text = ORKLocalizedString(@"AUDIO_LEVEL_CHECK_LABEL", nil);
        }
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (checkAudioLevel) {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKAudioTooLoudStepIdentifier];
        step.title = ORKLocalizedString(@"AUDIO_TASK_TITLE", nil);
        step.text = ORKLocalizedString(@"AUDIO_TOO_LOUD_MESSAGE", nil);
        step.detailText = ORKLocalizedString(@"AUDIO_TOO_LOUD_ACTION_NEXT", nil);
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKAudioStep *step = [[ORKAudioStep alloc] initWithIdentifier:ORKAudioStepIdentifier];
        step.title = ORKLocalizedString(@"AUDIO_TASK_TITLE", nil);
        step.text = shortSpeechInstruction ? : ORKLocalizedString(@"AUDIO_INSTRUCTION", nil);
        step.recorderConfigurations = @[[[ORKAudioRecorderConfiguration alloc] initWithIdentifier:ORKAudioRecorderIdentifier
                                                                                 recorderSettings:recordingSettings]];
        step.stepDuration = duration;
        step.shouldContinueOnFinish = YES;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }

    ORKNavigableOrderedTask *task = [[ORKNavigableOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    if (checkAudioLevel) {
    
        // Add rules to check for audio and fail, looping back to the countdown step if required
        ORKAudioLevelNavigationRule *audioRule = [[ORKAudioLevelNavigationRule alloc] initWithAudioLevelStepIdentifier:ORKCountdownStepIdentifier destinationStepIdentifier:ORKAudioStepIdentifier recordingSettings:recordingSettings];
        ORKDirectStepNavigationRule *loopRule = [[ORKDirectStepNavigationRule alloc] initWithDestinationStepIdentifier:ORKCountdownStepIdentifier];
    
        [task setNavigationRule:audioRule forTriggerStepIdentifier:ORKCountdownStepIdentifier];
        [task setNavigationRule:loopRule forTriggerStepIdentifier:ORKAudioTooLoudStepIdentifier];
    }
    
    return task;
}


#pragma mark - fitnessCheckTask

NSString *const ORKFitnessWalkStepIdentifier = @"fitness.walk";
NSString *const ORKFitnessRestStepIdentifier = @"fitness.rest";

+ (ORKOrderedTask *)fitnessCheckTaskWithIdentifier:(NSString *)identifier
                           intendedUseDescription:(NSString *)intendedUseDescription
                                     walkDuration:(NSTimeInterval)walkDuration
                                     restDuration:(NSTimeInterval)restDuration
                                          options:(ORKPredefinedTaskOption)options {
    
    NSDateComponentsFormatter *formatter = [self textTimeFormatter];
    
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"FITNESS_TASK_TITLE", nil);
            step.text = intendedUseDescription ? : [NSString localizedStringWithFormat:ORKLocalizedString(@"FITNESS_INTRO_TEXT_FORMAT", nil), [formatter stringFromTimeInterval:walkDuration]];
            step.image = [UIImage imageNamed:@"heartbeat" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"FITNESS_TASK_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"FITNESS_INTRO_2_TEXT_FORMAT", nil), [formatter stringFromTimeInterval:walkDuration], [formatter stringFromTimeInterval:restDuration]];
            step.image = [UIImage imageNamed:@"walkingman" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"FITNESS_TASK_TITLE", nil);
        step.stepDuration = 5.0;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    HKUnit *bpmUnit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    {
        if (walkDuration > 0) {
            NSMutableArray *recorderConfigurations = [NSMutableArray arrayWithCapacity:5];
            if (!(ORKPredefinedTaskOptionExcludePedometer & options)) {
                [recorderConfigurations addObject:[[ORKPedometerRecorderConfiguration alloc] initWithIdentifier:ORKPedometerRecorderIdentifier]];
            }
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeLocation & options)) {
                [recorderConfigurations addObject:[[ORKLocationRecorderConfiguration alloc] initWithIdentifier:ORKLocationRecorderIdentifier]];
            }
            if (!(ORKPredefinedTaskOptionExcludeHeartRate & options)) {
                [recorderConfigurations addObject:[[ORKHealthQuantityTypeRecorderConfiguration alloc] initWithIdentifier:ORKHeartRateRecorderIdentifier
                                                                                                      healthQuantityType:heartRateType unit:bpmUnit]];
            }
            ORKFitnessStep *fitnessStep = [[ORKFitnessStep alloc] initWithIdentifier:ORKFitnessWalkStepIdentifier];
            fitnessStep.stepDuration = walkDuration;
            fitnessStep.title = ORKLocalizedString(@"FITNESS_TASK_TITLE", nil);
            fitnessStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"FITNESS_WALK_INSTRUCTION_FORMAT", nil), [formatter stringFromTimeInterval:walkDuration]];
            fitnessStep.spokenInstruction = fitnessStep.text;
            fitnessStep.recorderConfigurations = recorderConfigurations;
            fitnessStep.shouldContinueOnFinish = YES;
            fitnessStep.optional = NO;
            fitnessStep.shouldStartTimerAutomatically = YES;
            fitnessStep.shouldTintImages = YES;
            fitnessStep.image = [UIImage imageNamed:@"walkingman" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            fitnessStep.shouldVibrateOnStart = YES;
            fitnessStep.shouldPlaySoundOnStart = YES;
            
            ORKStepArrayAddStep(steps, fitnessStep);
        }
        
        if (restDuration > 0) {
            NSMutableArray *recorderConfigurations = [NSMutableArray arrayWithCapacity:5];
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeHeartRate & options)) {
                [recorderConfigurations addObject:[[ORKHealthQuantityTypeRecorderConfiguration alloc] initWithIdentifier:ORKHeartRateRecorderIdentifier
                                                                                                      healthQuantityType:heartRateType unit:bpmUnit]];
            }
            
            ORKFitnessStep *stillStep = [[ORKFitnessStep alloc] initWithIdentifier:ORKFitnessRestStepIdentifier];
            stillStep.stepDuration = restDuration;
            stillStep.title = ORKLocalizedString(@"FITNESS_TASK_TITLE", nil);
            stillStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"FITNESS_SIT_INSTRUCTION_FORMAT", nil), [formatter stringFromTimeInterval:restDuration]];
            stillStep.spokenInstruction = stillStep.text;
            stillStep.recorderConfigurations = recorderConfigurations;
            stillStep.shouldContinueOnFinish = YES;
            stillStep.optional = NO;
            stillStep.shouldStartTimerAutomatically = YES;
            stillStep.shouldTintImages = YES;
            stillStep.image = [UIImage imageNamed:@"sittingman" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            stillStep.shouldVibrateOnStart = YES;
            stillStep.shouldPlaySoundOnStart = YES;
            stillStep.shouldPlaySoundOnFinish = YES;
            stillStep.shouldVibrateOnFinish = YES;
            
            ORKStepArrayAddStep(steps, stillStep);
        }
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    return task;
}


#pragma mark - shortWalkTask

NSString *const ORKShortWalkOutboundStepIdentifier = @"walking.outbound";
NSString *const ORKShortWalkReturnStepIdentifier = @"walking.return";
NSString *const ORKShortWalkRestStepIdentifier = @"walking.rest";

+ (ORKOrderedTask *)shortWalkTaskWithIdentifier:(NSString *)identifier
                         intendedUseDescription:(NSString *)intendedUseDescription
                            numberOfStepsPerLeg:(NSInteger)numberOfStepsPerLeg
                                   restDuration:(NSTimeInterval)restDuration
                                        options:(ORKPredefinedTaskOption)options {
    
    NSDateComponentsFormatter *formatter = [self textTimeFormatter];
    
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"WALK_INTRO_TEXT", nil);
            step.shouldTintImages = YES;
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_INTRO_2_TEXT_%ld", nil),numberOfStepsPerLeg];
            step.detailText = ORKLocalizedString(@"WALK_INTRO_2_DETAIL", nil);
            step.image = [UIImage imageNamed:@"pocket" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
        step.stepDuration = 5.0;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        {
            NSMutableArray *recorderConfigurations = [NSMutableArray array];
            if (!(ORKPredefinedTaskOptionExcludePedometer & options)) {
                [recorderConfigurations addObject:[[ORKPedometerRecorderConfiguration alloc] initWithIdentifier:ORKPedometerRecorderIdentifier]];
            }
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }

            ORKWalkingTaskStep *walkingStep = [[ORKWalkingTaskStep alloc] initWithIdentifier:ORKShortWalkOutboundStepIdentifier];
            walkingStep.numberOfStepsPerLeg = numberOfStepsPerLeg;
            walkingStep.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            walkingStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_OUTBOUND_INSTRUCTION_FORMAT", nil), (long long)numberOfStepsPerLeg];
            walkingStep.spokenInstruction = walkingStep.text;
            walkingStep.recorderConfigurations = recorderConfigurations;
            walkingStep.shouldContinueOnFinish = YES;
            walkingStep.optional = NO;
            walkingStep.shouldStartTimerAutomatically = YES;
            walkingStep.stepDuration = numberOfStepsPerLeg * 1.5; // fallback duration in case no step count
            walkingStep.shouldVibrateOnStart = YES;
            walkingStep.shouldPlaySoundOnStart = YES;
            
            ORKStepArrayAddStep(steps, walkingStep);
        }
        
        {
            NSMutableArray *recorderConfigurations = [NSMutableArray array];
            if (!(ORKPredefinedTaskOptionExcludePedometer & options)) {
                [recorderConfigurations addObject:[[ORKPedometerRecorderConfiguration alloc] initWithIdentifier:ORKPedometerRecorderIdentifier]];
            }
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }

            ORKWalkingTaskStep *walkingStep = [[ORKWalkingTaskStep alloc] initWithIdentifier:ORKShortWalkReturnStepIdentifier];
            walkingStep.numberOfStepsPerLeg = numberOfStepsPerLeg;
            walkingStep.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            walkingStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_RETURN_INSTRUCTION_FORMAT", nil), (long long)numberOfStepsPerLeg];
            walkingStep.spokenInstruction = walkingStep.text;
            walkingStep.recorderConfigurations = recorderConfigurations;
            walkingStep.shouldContinueOnFinish = YES;
            walkingStep.shouldStartTimerAutomatically = YES;
            walkingStep.optional = NO;
            walkingStep.stepDuration = numberOfStepsPerLeg * 1.5; // fallback duration in case no step count
            walkingStep.shouldVibrateOnStart = YES;
            walkingStep.shouldPlaySoundOnStart = YES;
            
            ORKStepArrayAddStep(steps, walkingStep);
        }
        
        if (restDuration > 0) {
            NSMutableArray *recorderConfigurations = [NSMutableArray array];
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }

            ORKFitnessStep *activeStep = [[ORKFitnessStep alloc] initWithIdentifier:ORKShortWalkRestStepIdentifier];
            activeStep.recorderConfigurations = recorderConfigurations;
            NSString *durationString = [formatter stringFromTimeInterval:restDuration];
            activeStep.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            activeStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_STAND_INSTRUCTION_FORMAT", nil), durationString];
            activeStep.spokenInstruction = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_STAND_VOICE_INSTRUCTION_FORMAT", nil), durationString];
            activeStep.shouldStartTimerAutomatically = YES;
            activeStep.stepDuration = restDuration;
            activeStep.shouldContinueOnFinish = YES;
            activeStep.optional = NO;
            activeStep.shouldVibrateOnStart = YES;
            activeStep.shouldPlaySoundOnStart = YES;
            activeStep.shouldVibrateOnFinish = YES;
            activeStep.shouldPlaySoundOnFinish = YES;
            
            ORKStepArrayAddStep(steps, activeStep);
        }
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - walkBackAndForthTask

+ (ORKOrderedTask *)walkBackAndForthTaskWithIdentifier:(NSString *)identifier
                                intendedUseDescription:(NSString *)intendedUseDescription
                                          walkDuration:(NSTimeInterval)walkDuration
                                          restDuration:(NSTimeInterval)restDuration
                                               options:(ORKPredefinedTaskOption)options {
    
    NSDateComponentsFormatter *formatter = [self textTimeFormatter];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"WALK_INTRO_TEXT", nil);
            step.shouldTintImages = YES;
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            step.text = ORKLocalizedString(@"WALK_INTRO_2_TEXT_BACK_AND_FORTH_INSTRUCTION", nil);
            step.detailText = ORKLocalizedString(@"WALK_INTRO_2_DETAIL_BACK_AND_FORTH_INSTRUCTION", nil);
            step.image = [UIImage imageNamed:@"pocket" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
        step.stepDuration = 5.0;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        {
            NSMutableArray *recorderConfigurations = [NSMutableArray array];
            if (!(ORKPredefinedTaskOptionExcludePedometer & options)) {
                [recorderConfigurations addObject:[[ORKPedometerRecorderConfiguration alloc] initWithIdentifier:ORKPedometerRecorderIdentifier]];
            }
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }
            
            ORKWalkingTaskStep *walkingStep = [[ORKWalkingTaskStep alloc] initWithIdentifier:ORKShortWalkOutboundStepIdentifier];
            walkingStep.numberOfStepsPerLeg = 1000; // Set the number of steps very high so it is ignored
            NSString *walkingDurationString = [formatter stringFromTimeInterval:walkDuration];
            walkingStep.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);

            walkingStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_BACK_AND_FORTH_INSTRUCTION_FORMAT", nil), walkingDurationString];
            walkingStep.spokenInstruction = walkingStep.text;
            walkingStep.recorderConfigurations = recorderConfigurations;
            walkingStep.shouldContinueOnFinish = YES;
            walkingStep.optional = NO;
            walkingStep.shouldStartTimerAutomatically = YES;
            walkingStep.stepDuration = walkDuration; // Set the walking duration to the step duration
            walkingStep.shouldVibrateOnStart = YES;
            walkingStep.shouldPlaySoundOnStart = YES;
            walkingStep.shouldSpeakRemainingTimeAtHalfway = (walkDuration > 20);
            
            ORKStepArrayAddStep(steps, walkingStep);
        }
        
        if (restDuration > 0) {
            NSMutableArray *recorderConfigurations = [NSMutableArray array];
            if (!(ORKPredefinedTaskOptionExcludeAccelerometer & options)) {
                [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                          frequency:100]];
            }
            if (!(ORKPredefinedTaskOptionExcludeDeviceMotion & options)) {
                [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                         frequency:100]];
            }
            
            ORKFitnessStep *activeStep = [[ORKFitnessStep alloc] initWithIdentifier:ORKShortWalkRestStepIdentifier];
            activeStep.recorderConfigurations = recorderConfigurations;
            NSString *durationString = [formatter stringFromTimeInterval:restDuration];
            activeStep.title = ORKLocalizedString(@"WALK_TASK_TITLE", nil);
            activeStep.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"WALK_BACK_AND_FORTH_STAND_INSTRUCTION_FORMAT", nil), durationString];
            activeStep.spokenInstruction = activeStep.text;
            activeStep.shouldStartTimerAutomatically = YES;
            activeStep.stepDuration = restDuration;
            activeStep.shouldContinueOnFinish = YES;
            activeStep.optional = NO;
            activeStep.shouldVibrateOnStart = YES;
            activeStep.shouldPlaySoundOnStart = YES;
            activeStep.shouldVibrateOnFinish = YES;
            activeStep.shouldPlaySoundOnFinish = YES;
            activeStep.finishedSpokenInstruction = ORKLocalizedString(@"WALK_BACK_AND_FORTH_FINISHED_VOICE", nil);
            activeStep.shouldSpeakRemainingTimeAtHalfway = (restDuration > 20);
            
            ORKStepArrayAddStep(steps, activeStep);
        }
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - kneeRangeOfMotionTask

NSString *const ORKKneeRangeOfMotionStepIdentifier = @"knee.range.of.motion";

+ (ORKOrderedTask *)kneeRangeOfMotionTaskWithIdentifier:(NSString *)identifier
                                             limbOption:(ORKPredefinedTaskLimbOption)limbOption
                                 intendedUseDescription:(NSString *)intendedUseDescription
                                                options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    NSString *limbType = ORKLocalizedString(@"LIMB_RIGHT", nil);
    UIImage *kneeFlexedImage = [UIImage imageNamed:@"knee_flexed_right" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    UIImage *kneeExtendedImage = [UIImage imageNamed:@"knee_extended_right" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    if (limbOption == ORKPredefinedTaskLimbOptionLeft) {
        limbType = ORKLocalizedString(@"LIMB_LEFT", nil);
        
        kneeFlexedImage = [UIImage imageNamed:@"knee_flexed_left" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        kneeExtendedImage = [UIImage imageNamed:@"knee_extended_left" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        ORKInstructionStep *instructionStep0 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
        instructionStep0.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep0.text = intendedUseDescription ? : ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_RIGHT", nil);;
        instructionStep0.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_0_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_0_RIGHT", nil);
        instructionStep0.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep0);
        
        ORKInstructionStep *instructionStep1 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
        instructionStep1.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep1.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        
        instructionStep1.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_1_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_1_RIGHT", nil);
        ORKStepArrayAddStep(steps, instructionStep1);
        
        ORKInstructionStep *instructionStep2 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction2StepIdentifier];
        instructionStep2.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep2.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        
        instructionStep2.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_2_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_2_RIGHT", nil);
        instructionStep2.image = kneeFlexedImage;
        instructionStep2.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep2);
        
        ORKInstructionStep *instructionStep3 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction3StepIdentifier];
        instructionStep3.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep3.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        instructionStep3.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_3_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TEXT_INSTRUCTION_3_RIGHT", nil);
        
        instructionStep3.image = kneeExtendedImage;
        instructionStep3.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep3);
    }
    NSString *instructionText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TOUCH_ANYWHERE_STEP_INSTRUCTION_LEFT", nil) : ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_TOUCH_ANYWHERE_STEP_INSTRUCTION_RIGHT", nil);
    ORKTouchAnywhereStep *touchAnywhereStep = [[ORKTouchAnywhereStep alloc] initWithIdentifier:ORKTouchAnywhereStepIdentifier instructionText:instructionText];
    touchAnywhereStep.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
    ORKStepArrayAddStep(steps, touchAnywhereStep);
    
    ORKDeviceMotionRecorderConfiguration *deviceMotionRecorderConfig = [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier frequency:100];
    
    ORKRangeOfMotionStep *kneeRangeOfMotionStep = [[ORKRangeOfMotionStep alloc] initWithIdentifier:ORKKneeRangeOfMotionStepIdentifier limbOption:limbOption];
    kneeRangeOfMotionStep.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
    kneeRangeOfMotionStep.text = ([limbType isEqualToString: ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_SPOKEN_INSTRUCTION_LEFT", nil) :
    ORKLocalizedString(@"KNEE_RANGE_OF_MOTION_SPOKEN_INSTRUCTION_RIGHT", nil);
    
    kneeRangeOfMotionStep.spokenInstruction = kneeRangeOfMotionStep.text;
    kneeRangeOfMotionStep.recorderConfigurations = @[deviceMotionRecorderConfig];
    kneeRangeOfMotionStep.optional = NO;
    
    ORKStepArrayAddStep(steps, kneeRangeOfMotionStep);
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKCompletionStep *completionStep = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, completionStep);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - shoulderRangeOfMotionTask

NSString *const ORKShoulderRangeOfMotionStepIdentifier = @"shoulder.range.of.motion";

+ (ORKOrderedTask *)shoulderRangeOfMotionTaskWithIdentifier:(NSString *)identifier
                                                 limbOption:(ORKPredefinedTaskLimbOption)limbOption
                                     intendedUseDescription:(NSString *)intendedUseDescription
                                                    options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    NSString *limbType = ORKLocalizedString(@"LIMB_RIGHT", nil);
    UIImage *shoulderFlexedImage = [UIImage imageNamed:@"shoulder_flexed_right" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    UIImage *shoulderExtendedImage = [UIImage imageNamed:@"shoulder_extended_right" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    if (limbOption == ORKPredefinedTaskLimbOptionLeft) {
        limbType = ORKLocalizedString(@"LIMB_LEFT", nil);
        shoulderFlexedImage = [UIImage imageNamed:@"shoulder_flexed_left" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        shoulderExtendedImage = [UIImage imageNamed:@"shoulder_extended_left" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        ORKInstructionStep *instructionStep0 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
        instructionStep0.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep0.text = intendedUseDescription ? : ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_RIGHT", nil);;
        instructionStep0.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_0_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_0_RIGHT", nil);
        instructionStep0.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep0);
        
        ORKInstructionStep *instructionStep1 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
        instructionStep1.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep1.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        
        instructionStep1.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_1_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_1_RIGHT", nil);
        ORKStepArrayAddStep(steps, instructionStep1);
        
        ORKInstructionStep *instructionStep2 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction2StepIdentifier];
        instructionStep2.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep2.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        
        instructionStep2.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_2_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_2_RIGHT", nil);
        instructionStep2.image = shoulderFlexedImage;
        instructionStep2.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep2);
        
        ORKInstructionStep *instructionStep3 = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction3StepIdentifier];
        instructionStep3.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        instructionStep3.text = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TITLE_RIGHT", nil);
        
        instructionStep3.detailText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_3_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TEXT_INSTRUCTION_3_RIGHT", nil);
        instructionStep3.image = shoulderExtendedImage;
        instructionStep3.shouldTintImages = YES;
        ORKStepArrayAddStep(steps, instructionStep3);
    }
    
    NSString *instructionText = ([limbType isEqualToString:ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TOUCH_ANYWHERE_STEP_INSTRUCTION_LEFT", nil) : ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_TOUCH_ANYWHERE_STEP_INSTRUCTION_RIGHT", nil);
    ORKTouchAnywhereStep *touchAnywhereStep = [[ORKTouchAnywhereStep alloc] initWithIdentifier:ORKTouchAnywhereStepIdentifier instructionText:instructionText];
    touchAnywhereStep.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
    ORKStepArrayAddStep(steps, touchAnywhereStep);
    
    ORKDeviceMotionRecorderConfiguration *deviceMotionRecorderConfig = [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier frequency:100];
    
    ORKShoulderRangeOfMotionStep *shoulderRangeOfMotionStep = [[ORKShoulderRangeOfMotionStep alloc] initWithIdentifier:ORKShoulderRangeOfMotionStepIdentifier limbOption:limbOption];
    shoulderRangeOfMotionStep.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
    shoulderRangeOfMotionStep.text = ([limbType isEqualToString: ORKLocalizedString(@"LIMB_LEFT", nil)])? ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_SPOKEN_INSTRUCTION_LEFT", nil) :
    ORKLocalizedString(@"SHOULDER_RANGE_OF_MOTION_SPOKEN_INSTRUCTION_RIGHT", nil);
    
    shoulderRangeOfMotionStep.spokenInstruction = shoulderRangeOfMotionStep.text;
    
    shoulderRangeOfMotionStep.recorderConfigurations = @[deviceMotionRecorderConfig];
    shoulderRangeOfMotionStep.optional = NO;
    
    ORKStepArrayAddStep(steps, shoulderRangeOfMotionStep);
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKCompletionStep *completionStep = [self makeCompletionStep];
        completionStep.title = ORKLocalizedString(@"RANGE_OF_MOTION_TITLE", nil);
        ORKStepArrayAddStep(steps, completionStep);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - spatialSpanMemoryTask

NSString *const ORKSpatialSpanMemoryStepIdentifier = @"cognitive.memory.spatialspan";

+ (ORKOrderedTask *)spatialSpanMemoryTaskWithIdentifier:(NSString *)identifier
                                 intendedUseDescription:(NSString *)intendedUseDescription
                                            initialSpan:(NSInteger)initialSpan
                                            minimumSpan:(NSInteger)minimumSpan
                                            maximumSpan:(NSInteger)maximumSpan
                                              playSpeed:(NSTimeInterval)playSpeed
                                               maximumTests:(NSInteger)maximumTests
                                 maximumConsecutiveFailures:(NSInteger)maximumConsecutiveFailures
                                      customTargetImage:(UIImage *)customTargetImage
                                 customTargetPluralName:(NSString *)customTargetPluralName
                                        requireReversal:(BOOL)requireReversal
                                                options:(ORKPredefinedTaskOption)options {
    
    NSString *targetPluralName = customTargetPluralName ? : ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_TARGET_PLURAL", nil);
    
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = [NSString localizedStringWithFormat:ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_INTRO_TEXT_%@", nil),targetPluralName];
            
            step.image = [UIImage imageNamed:@"phone-memory" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:requireReversal ? ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_INTRO_2_TEXT_REVERSE_%@", nil) : ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_INTRO_2_TEXT_%@", nil), targetPluralName, targetPluralName];
            step.detailText = ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_CALL_TO_ACTION", nil);
            
            if (!customTargetImage) {
                step.image = [UIImage imageNamed:@"memory-second-screen" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            } else {
                step.image = customTargetImage;
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKSpatialSpanMemoryStep *step = [[ORKSpatialSpanMemoryStep alloc] initWithIdentifier:ORKSpatialSpanMemoryStepIdentifier];
        step.title = ORKLocalizedString(@"SPATIAL_SPAN_MEMORY_TITLE", nil);
        step.text = nil;
        
        step.initialSpan = initialSpan;
        step.minimumSpan = minimumSpan;
        step.maximumSpan = maximumSpan;
        step.playSpeed = playSpeed;
        step.maximumTests = maximumTests;
        step.maximumConsecutiveFailures = maximumConsecutiveFailures;
        step.customTargetImage = customTargetImage;
        step.customTargetPluralName = customTargetPluralName;
        step.requireReversal = requireReversal;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - speechRecognitionTask

NSString *const ORKSpeechRecognitionStepIdentifier = @"speech.recognition";

+ (ORKOrderedTask *)speechRecognitionTaskWithIdentifier:(NSString *)identifier
                                 intendedUseDescription:(nullable NSString *)intendedUseDescription
                                 speechRecognizerLocale:(ORKSpeechRecognizerLocale)speechRecognizerLocale
                                 speechRecognitionImage:(nullable UIImage *)speechRecognitionImage
                                  speechRecognitionText:(nullable NSString *)speechRecognitionText
                                   shouldHideTranscript:(BOOL)shouldHideTranscript
                               allowsEdittingTranscript:(BOOL)allowsEdittingTranscript
                                                options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"SPEECH_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"SPEECH_RECOGNITION_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"phonewaves" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"SPEECH_TASK_TITLE", nil);
            step.text = ORKLocalizedString(@"SPEECH_RECOGNITION_INTRO_2_TEXT", nil);
            step.detailText = ORKLocalizedString(@"SPEECH_RECOGNITION_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"phonewavesspeech" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    ORKSpeechRecognitionStep *step = [[ORKSpeechRecognitionStep alloc] initWithIdentifier: ORKSpeechRecognitionStepIdentifier image:speechRecognitionImage text:speechRecognitionText];
    ORKStreamingAudioRecorderConfiguration *config = [[ORKStreamingAudioRecorderConfiguration alloc] initWithIdentifier: ORKStreamingAudioRecorderIdentifier];
    step.title = ORKLocalizedString(@"SPEECH_TASK_TITLE", nil);
    step.shouldHideTranscript = shouldHideTranscript;
    step.recorderConfigurations = @[config];
    step.speechRecognizerLocale = speechRecognizerLocale;
    step.shouldContinueOnFinish = NO;
    
    ORKStepArrayAddStep(steps, step);
    
    if (allowsEdittingTranscript) {
        ORKQuestionStep *editTranscriptStep = [ORKQuestionStep questionStepWithIdentifier:ORKEditSpeechTranscript0StepIdentifier
                                                                                    title:ORKLocalizedString(@"SPEECH_RECOGNITION_QUESTION_TITLE", nil)
                                                                                 question:nil
                                                                                   answer:[ORKTextAnswerFormat new]];
        editTranscriptStep.text = ORKLocalizedString(@"SPEECH_RECOGNITION_QUESTION_TEXT", nil);
        ORKStepArrayAddStep(steps, editTranscriptStep);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}

#pragma mark - speechInNoiseTask

NSString *const ORKSpeechInNoiseStep0Identifier = @"speech.in.noise0";
NSString *const ORKSpeechInNoiseStep1Identifier = @"speech.in.noise1";
NSString *const ORKSpeechInNoiseStep2Identifier = @"speech.in.noise2";

+ (ORKOrderedTask *)speechInNoiseTaskWithIdentifier:(NSString *)identifier
                             intendedUseDescription:(nullable NSString *)intendedUseDescription
                                            options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
        step.title = ORKLocalizedString(@"SPEECH_IN_NOISE_TITLE", nil);
        step.detailText = intendedUseDescription;
        step.text = intendedUseDescription ? : ORKLocalizedString(@"SPEECH_IN_NOISE_INTRO_TEXT", nil);
        step.image = [UIImage imageNamed:@"speechInNoise" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        step.shouldTintImages = YES;
        
        ORKStepArrayAddStep(steps, step);
    }
    {
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
        step.title = ORKLocalizedString(@"SPEECH_IN_NOISE_TITLE", nil);
        step.detailText = ORKLocalizedString(@"SPEECH_IN_NOISE_DETAIL_TEXT", nil);
        step.image = [UIImage imageNamed:@"speechInNoise" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        step.shouldTintImages = YES;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    // SNR ranging from 18 dB to 0 dB with a 3 dB step
    NSMutableArray *gainValues = [NSMutableArray new];
    [gainValues addObject:[NSNumber numberWithDouble:0.18]];
    [gainValues addObject:[NSNumber numberWithDouble:0.25]];
    [gainValues addObject:[NSNumber numberWithDouble:0.36]];
    [gainValues addObject:[NSNumber numberWithDouble:0.51]];
    [gainValues addObject:[NSNumber numberWithDouble:0.73]];
    [gainValues addObject:[NSNumber numberWithDouble:1.03]];
    [gainValues addObject:[NSNumber numberWithDouble:1.46]];
    
    
    {
        ORKSpeechInNoiseStep *step = [[ORKSpeechInNoiseStep alloc] initWithIdentifier:ORKSpeechInNoiseStep1Identifier];
        step.speechFileNameWithExtension = @"Sentence1.wav";
        step.gainAppliedToNoise = [gainValues[0] doubleValue];
        step.title = ORKLocalizedString(@"SPEECH_IN_NOISE_STEP_TITLE", nil);
        step.text = ORKLocalizedString(@"SPEECH_IN_NOISE_STEP_TEXT", nil);
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKSpeechRecognitionStep *step = [[ORKSpeechRecognitionStep alloc] initWithIdentifier: ORKSpeechInNoiseStep2Identifier image:nil text:nil];
        ORKStreamingAudioRecorderConfiguration *config = [[ORKStreamingAudioRecorderConfiguration alloc] initWithIdentifier: ORKStreamingAudioRecorderIdentifier];
        step.title = ORKLocalizedString(@"SPEECH_IN_NOISE_SPEAK_TITLE", nil);
        step.text = ORKLocalizedString(@"SPEECH_IN_NOISE_SPEAK_TEXT", nil);
        step.shouldHideTranscript = YES;
        step.recorderConfigurations = @[config];
        step.speechRecognizerLocale = ORKSpeechRecognizerLocaleEnglishUS;
        step.shouldContinueOnFinish = NO;
        step.optional = YES;
        
        ORKStepArrayAddStep(steps, step);
    }
    {
        ORKQuestionStep *editTranscriptStep = [ORKQuestionStep questionStepWithIdentifier:ORKEditSpeechTranscript0StepIdentifier
                                                                                    title:ORKLocalizedString(@"SPEECH_RECOGNITION_QUESTION_TITLE", nil)
                                                                                 question:nil
                                                                                   answer:[ORKTextAnswerFormat new]];
        editTranscriptStep.text = ORKLocalizedString(@"SPEECH_RECOGNITION_QUESTION_TEXT", nil);
        ORKStepArrayAddStep(steps, editTranscriptStep);
    }
    
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
    
}

#pragma mark - stroopTask

NSString *const ORKStroopStepIdentifier = @"stroop";

+ (ORKOrderedTask *)stroopTaskWithIdentifier:(NSString *)identifier
                      intendedUseDescription:(nullable NSString *)intendedUseDescription
                            numberOfAttempts:(NSInteger)numberOfAttempts
                                     options:(ORKPredefinedTaskOption)options {
    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"STROOP_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"STROOP_TASK_INTRO1_DETAIL_TEXT", nil);
            step.image = [UIImage imageNamed:@"phonestrooplabel" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"STROOP_TASK_TITLE", nil);
            step.detailText = ORKLocalizedString(@"STROOP_TASK_INTRO2_DETAIL_TEXT", nil);
            step.image = [UIImage imageNamed:@"phonestroopbutton" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"STROOP_TASK_TITLE", nil);
        step.stepDuration = 5.0;
        
        ORKStepArrayAddStep(steps, step);
    }
    {
        ORKStroopStep *step = [[ORKStroopStep alloc] initWithIdentifier:ORKStroopStepIdentifier];
        step.title = ORKLocalizedString(@"STROOP_TASK_TITLE", nil);
        step.text = ORKLocalizedString(@"STROOP_TASK_STEP_TEXT", nil);
        step.spokenInstruction = step.text;
        step.numberOfAttempts = numberOfAttempts;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - toneAudiometryTask

NSString *const ORKToneAudiometryPracticeStepIdentifier = @"tone.audiometry.practice";
NSString *const ORKToneAudiometryStepIdentifier = @"tone.audiometry";

+ (ORKOrderedTask *)toneAudiometryTaskWithIdentifier:(NSString *)identifier
                              intendedUseDescription:(nullable NSString *)intendedUseDescription
                                   speechInstruction:(nullable NSString *)speechInstruction
                              shortSpeechInstruction:(nullable NSString *)shortSpeechInstruction
                                        toneDuration:(NSTimeInterval)toneDuration
                                             options:(ORKPredefinedTaskOption)options {

    if (options & ORKPredefinedTaskOptionExcludeAudio) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Audio collection cannot be excluded from audio task" userInfo:nil];
    }

    NSMutableArray *steps = [NSMutableArray array];
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TONE_AUDIOMETRY_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"TONE_AUDIOMETRY_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"phonewaves_inverted" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;

            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"TONE_AUDIOMETRY_TASK_TITLE", nil);
            step.text = speechInstruction ? : ORKLocalizedString(@"TONE_AUDIOMETRY_INTRO_TEXT", nil);
            step.detailText = ORKLocalizedString(@"TONE_AUDIOMETRY_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"phonefrequencywaves" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;

            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKToneAudiometryStep *step = [[ORKToneAudiometryStep alloc] initWithIdentifier:ORKToneAudiometryPracticeStepIdentifier];
        step.title = ORKLocalizedString(@"TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.text = speechInstruction ? : ORKLocalizedString(@"TONE_AUDIOMETRY_PREP_TEXT", nil);
        step.toneDuration = CGFLOAT_MAX;
        step.practiceStep = YES;
        ORKStepArrayAddStep(steps, step);
        
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.stepDuration = 5.0;

        ORKStepArrayAddStep(steps, step);
    }

    {
        ORKToneAudiometryStep *step = [[ORKToneAudiometryStep alloc] initWithIdentifier:ORKToneAudiometryStepIdentifier];
        step.title = ORKLocalizedString(@"TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.text = shortSpeechInstruction ? : ORKLocalizedString(@"TONE_AUDIOMETRY_INSTRUCTION", nil);
        step.toneDuration = toneDuration;

        ORKStepArrayAddStep(steps, step);
    }

    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];

        ORKStepArrayAddStep(steps, step);
    }

    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];

    return task;
}

#pragma mark - dBHLToneAudiometryTask

NSString *const ORKdBHLToneAudiometryStepIdentifier = @"dBHL.tone.audiometry";
NSString *const ORKdBHLToneAudiometryStep0Identifier = @"dBHL0.tone.audiometry";
NSString *const ORKdBHLToneAudiometryStep1Identifier = @"dBHL1.tone.audiometry";
NSString *const ORKdBHLToneAudiometryStep2Identifier = @"dBHL2.tone.audiometry";

+ (ORKOrderedTask *)dBHLToneAudiometryTaskWithIdentifier:(NSString *)identifier
                              intendedUseDescription:(nullable NSString *)intendedUseDescription
                                             options:(ORKPredefinedTaskOption)options {
    
    if (options & ORKPredefinedTaskOptionExcludeAudio) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Audio collection cannot be excluded from audio task" userInfo:nil];
    }

    NSMutableArray *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"audiometry" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
    }

    {
        ORKdBHLToneAudiometryOnboardingStep *step = [[ORKdBHLToneAudiometryOnboardingStep alloc] initWithIdentifier:ORKdBHLToneAudiometryStepIdentifier];
        step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.text = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_ONBOARDING", nil);
        
        step.optional = NO;
        
        ORKTextChoice *left = [ORKTextChoice choiceWithText:ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_OPTION_LEFT", nil)
                                                      value:@"LEFT"];
        ORKTextChoice *right = [ORKTextChoice choiceWithText:ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_OPTION_RIGHT", nil)
                                                       value:@"RIGHT"];
        ORKTextChoice *neither = [ORKTextChoice choiceWithText:ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_OPTION_NO_PREFERENCE", nil)
                                                         value:@"NEITHER"];
        
        ORKAnswerFormat *answerFormat = [ORKAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                         textChoices:@[right, left, neither]];
        
        ORKFormItem *formItem = [[ORKFormItem alloc] initWithIdentifier:ORKdBHLToneAudiometryStep0Identifier
                                                                   text:ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_ONBOARDING_QUESTION", nil)
                                                           answerFormat:answerFormat];
        formItem.optional = NO;
        
        step.formItems = @[formItem];
    
        ORKStepArrayAddStep(steps, step);
    }

    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
            step.text = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"audiometry" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.stepDuration = 5.0;
        step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKdBHLToneAudiometryStep *step = [[ORKdBHLToneAudiometryStep alloc] initWithIdentifier:ORKdBHLToneAudiometryStep1Identifier];
        step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.stepDuration = CGFLOAT_MAX;
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdown1StepIdentifier];
        step.stepDuration = 5.0;
        step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKdBHLToneAudiometryStep *step = [[ORKdBHLToneAudiometryStep alloc] initWithIdentifier:ORKdBHLToneAudiometryStep2Identifier];
        step.title = ORKLocalizedString(@"dBHL_TONE_AUDIOMETRY_TASK_TITLE", nil);
        step.stepDuration = CGFLOAT_MAX;
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    return task;
}



#pragma mark - towerOfHanoiTask

NSString *const ORKTowerOfHanoiStepIdentifier = @"towerOfHanoi";

+ (ORKOrderedTask *)towerOfHanoiTaskWithIdentifier:(NSString *)identifier
                            intendedUseDescription:(nullable NSString *)intendedUseDescription
                                     numberOfDisks:(NSUInteger)numberOfDisks
                                           options:(ORKPredefinedTaskOption)options {
    
    NSMutableArray *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"phone-tower-of-hanoi" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_TITLE", nil);
            step.text = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_INTRO_TEXT", nil);
            step.detailText = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_TASK_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"tower-of-hanoi-second-screen" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    ORKTowerOfHanoiStep *towerOfHanoiStep = [[ORKTowerOfHanoiStep alloc]initWithIdentifier:ORKTowerOfHanoiStepIdentifier];
    towerOfHanoiStep.title = ORKLocalizedString(@"TOWER_OF_HANOI_TASK_TITLE", nil);
    towerOfHanoiStep.numberOfDisks = numberOfDisks;
    ORKStepArrayAddStep(steps, towerOfHanoiStep);
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc]initWithIdentifier:identifier steps:steps];
    
    return task;
}


#pragma mark - reactionTimeTask

NSString *const ORKReactionTimeStepIdentifier = @"reactionTime";

+ (ORKOrderedTask *)reactionTimeTaskWithIdentifier:(NSString *)identifier
                            intendedUseDescription:(nullable NSString *)intendedUseDescription
                           maximumStimulusInterval:(NSTimeInterval)maximumStimulusInterval
                           minimumStimulusInterval:(NSTimeInterval)minimumStimulusInterval
                             thresholdAcceleration:(double)thresholdAcceleration
                                  numberOfAttempts:(int)numberOfAttempts
                                           timeout:(NSTimeInterval)timeout
                                      successSound:(UInt32)successSoundID
                                      timeoutSound:(UInt32)timeoutSoundID
                                      failureSound:(UInt32)failureSoundID
                                           options:(ORKPredefinedTaskOption)options {
    
    NSMutableArray *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"REACTION_TIME_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"REACTION_TIME_TASK_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"phoneshake" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"REACTION_TIME_TASK_TITLE", nil);
            step.text = [NSString localizedStringWithFormat: ORKLocalizedString(@"REACTION_TIME_TASK_INTRO_TEXT_FORMAT", nil), numberOfAttempts];
            step.detailText = ORKLocalizedString(@"REACTION_TIME_TASK_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"phoneshakecircle" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    ORKReactionTimeStep *step = [[ORKReactionTimeStep alloc] initWithIdentifier:ORKReactionTimeStepIdentifier];
    step.title = ORKLocalizedString(@"REACTION_TIME_TASK_TITLE", nil);
    step.maximumStimulusInterval = maximumStimulusInterval;
    step.minimumStimulusInterval = minimumStimulusInterval;
    step.thresholdAcceleration = thresholdAcceleration;
    step.numberOfAttempts = numberOfAttempts;
    step.timeout = timeout;
    step.successSound = successSoundID;
    step.timeoutSound = timeoutSoundID;
    step.failureSound = failureSoundID;
    step.recorderConfigurations = @[ [[ORKDeviceMotionRecorderConfiguration  alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier frequency: 100]];

    ORKStepArrayAddStep(steps, step);
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    return task;
}

#pragma mark - timedWalkTask

NSString *const ORKTimedWalkFormStepIdentifier = @"timed.walk.form";
NSString *const ORKTimedWalkFormAFOStepIdentifier = @"timed.walk.form.afo";
NSString *const ORKTimedWalkFormAssistanceStepIdentifier = @"timed.walk.form.assistance";
NSString *const ORKTimedWalkTrial1StepIdentifier = @"timed.walk.trial1";
NSString *const ORKTimedWalkTurnAroundStepIdentifier = @"timed.walk.turn.around";
NSString *const ORKTimedWalkTrial2StepIdentifier = @"timed.walk.trial2";

+ (ORKOrderedTask *)timedWalkTaskWithIdentifier:(NSString *)identifier
                         intendedUseDescription:(nullable NSString *)intendedUseDescription
                               distanceInMeters:(double)distanceInMeters
                                      timeLimit:(NSTimeInterval)timeLimit
                            turnAroundTimeLimit:(NSTimeInterval)turnAroundTimeLimit
                     includeAssistiveDeviceForm:(BOOL)includeAssistiveDeviceForm
                                        options:(ORKPredefinedTaskOption)options {

    NSMutableArray *steps = [NSMutableArray array];

    NSLengthFormatter *lengthFormatter = [NSLengthFormatter new];
    lengthFormatter.numberFormatter.maximumFractionDigits = 1;
    lengthFormatter.numberFormatter.maximumSignificantDigits = 3;
    NSString *formattedLength = [lengthFormatter stringFromMeters:distanceInMeters];

    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"TIMED_WALK_INTRO_DETAIL", nil);
            step.shouldTintImages = YES;

            ORKStepArrayAddStep(steps, step);
        }
    }

    if (includeAssistiveDeviceForm) {
        ORKFormStep *step = [[ORKFormStep alloc] initWithIdentifier:ORKTimedWalkFormStepIdentifier
                                                              title:ORKLocalizedString(@"TIMED_WALK_FORM_TITLE", nil)
                                                               text:ORKLocalizedString(@"TIMED_WALK_FORM_TEXT", nil)];

        ORKAnswerFormat *answerFormat1 = [ORKAnswerFormat booleanAnswerFormat];
        ORKFormItem *formItem1 = [[ORKFormItem alloc] initWithIdentifier:ORKTimedWalkFormAFOStepIdentifier
                                                                    text:ORKLocalizedString(@"TIMED_WALK_QUESTION_TEXT", nil)
                                                            answerFormat:answerFormat1];
        formItem1.optional = NO;

        NSArray *textChoices = @[ [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE"],
                                  [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE_2", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE_2"],
                                  [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE_3", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE_3"],
                                  [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE_4", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE_4"],
                                  [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE_5", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE_5"],
                                  [ORKTextChoice choiceWithText:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_CHOICE_6", nil) value:@"TIMED_WALK_QUESTION_2_CHOICE_6"] ];
        ORKAnswerFormat *answerFormat2 = [ORKAnswerFormat valuePickerAnswerFormatWithTextChoices:textChoices];
        ORKFormItem *formItem2 = [[ORKFormItem alloc] initWithIdentifier:ORKTimedWalkFormAssistanceStepIdentifier
                                                                    text:ORKLocalizedString(@"TIMED_WALK_QUESTION_2_TITLE", nil)
                                                            answerFormat:answerFormat2];
        formItem2.placeholder = ORKLocalizedString(@"TIMED_WALK_QUESTION_2_TEXT", nil);
        formItem2.optional = NO;

        step.formItems = @[formItem1, formItem2];
        step.optional = NO;

        ORKStepArrayAddStep(steps, step);
    }

    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"TIMED_WALK_INTRO_2_TEXT_%@", nil), formattedLength];
            step.detailText = ORKLocalizedString(@"TIMED_WALK_INTRO_2_DETAIL", nil);
            step.image = [UIImage imageNamed:@"timer" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;

            ORKStepArrayAddStep(steps, step);
        }
    }

    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
        step.stepDuration = 5.0;

        ORKStepArrayAddStep(steps, step);
    }

    {
        NSMutableArray *recorderConfigurations = [NSMutableArray array];
        if (!(options & ORKPredefinedTaskOptionExcludePedometer)) {
            [recorderConfigurations addObject:[[ORKPedometerRecorderConfiguration alloc] initWithIdentifier:ORKPedometerRecorderIdentifier]];
        }
        if (!(options & ORKPredefinedTaskOptionExcludeAccelerometer)) {
            [recorderConfigurations addObject:[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:ORKAccelerometerRecorderIdentifier
                                                                                                      frequency:100]];
        }
        if (!(options & ORKPredefinedTaskOptionExcludeDeviceMotion)) {
            [recorderConfigurations addObject:[[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:ORKDeviceMotionRecorderIdentifier
                                                                                                     frequency:100]];
        }
        if (! (options & ORKPredefinedTaskOptionExcludeLocation)) {
            [recorderConfigurations addObject:[[ORKLocationRecorderConfiguration alloc] initWithIdentifier:ORKLocationRecorderIdentifier]];
        }

        {
            ORKTimedWalkStep *step = [[ORKTimedWalkStep alloc] initWithIdentifier:ORKTimedWalkTrial1StepIdentifier];
            step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
            step.text = [[[NSString alloc] initWithFormat:ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_%@", nil), formattedLength] stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.recorderConfigurations = recorderConfigurations;
            step.distanceInMeters = distanceInMeters;
            step.shouldTintImages = YES;
            step.image = [UIImage imageNamed:@"timed-walkingman-outbound" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.stepDuration = timeLimit == 0 ? CGFLOAT_MAX : timeLimit;

            ORKStepArrayAddStep(steps, step);
        }

        {
            if (turnAroundTimeLimit > 0) {
                ORKTimedWalkStep *step = [[ORKTimedWalkStep alloc] initWithIdentifier:ORKTimedWalkTurnAroundStepIdentifier];
                step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
                step.text = [ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_TURN", nil) stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_TEXT", nil)]];
                step.spokenInstruction = step.text;
                step.recorderConfigurations = recorderConfigurations;
                step.distanceInMeters = 1;
                step.shouldTintImages = YES;
                step.image = [UIImage imageNamed:@"turnaround" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                step.stepDuration = turnAroundTimeLimit == 0 ? CGFLOAT_MAX : turnAroundTimeLimit;

                ORKStepArrayAddStep(steps, step);
            }
        }

        {
            ORKTimedWalkStep *step = [[ORKTimedWalkStep alloc] initWithIdentifier:ORKTimedWalkTrial2StepIdentifier];
            step.title = ORKLocalizedString(@"TIMED_WALK_TITLE", nil);
            step.text = [[[NSString alloc] initWithFormat:ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_2", nil), formattedLength] stringByAppendingString:[@"\n" stringByAppendingString:ORKLocalizedString(@"TIMED_WALK_INSTRUCTION_TEXT", nil)]];
            step.spokenInstruction = step.text;
            step.recorderConfigurations = recorderConfigurations;
            step.distanceInMeters = distanceInMeters;
            step.shouldTintImages = YES;
            step.image = [UIImage imageNamed:@"timed-walkingman-return" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.stepDuration = timeLimit == 0 ? CGFLOAT_MAX : timeLimit;

            ORKStepArrayAddStep(steps, step);
        }
    }

    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];

        ORKStepArrayAddStep(steps, step);
    }

    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    return task;
}


#pragma mark - PSATTask

NSString *const ORKPSATStepIdentifier = @"psat";

+ (ORKOrderedTask *)PSATTaskWithIdentifier:(NSString *)identifier
                    intendedUseDescription:(nullable NSString *)intendedUseDescription
                          presentationMode:(ORKPSATPresentationMode)presentationMode
                     interStimulusInterval:(NSTimeInterval)interStimulusInterval
                          stimulusDuration:(NSTimeInterval)stimulusDuration
                              seriesLength:(NSInteger)seriesLength
                                   options:(ORKPredefinedTaskOption)options {
    
    NSMutableArray *steps = [NSMutableArray array];
    NSString *versionTitle = @"";
    NSString *versionDetailText = @"";
    
    if (presentationMode == ORKPSATPresentationModeAuditory) {
        versionTitle = ORKLocalizedString(@"PASAT_TITLE", nil);
        versionDetailText = ORKLocalizedString(@"PASAT_INTRO_TEXT", nil);
    } else if (presentationMode == ORKPSATPresentationModeVisual) {
        versionTitle = ORKLocalizedString(@"PVSAT_TITLE", nil);
        versionDetailText = ORKLocalizedString(@"PVSAT_INTRO_TEXT", nil);
    } else {
        versionTitle = ORKLocalizedString(@"PAVSAT_TITLE", nil);
        versionDetailText = ORKLocalizedString(@"PAVSAT_INTRO_TEXT", nil);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = versionTitle;
            step.detailText = versionDetailText;
            step.text = intendedUseDescription;
            step.image = [UIImage imageNamed:@"phonepsat" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = versionTitle;
            step.text = [NSString localizedStringWithFormat:ORKLocalizedString(@"PSAT_INTRO_TEXT_2_%@", nil), [NSNumberFormatter localizedStringFromNumber:@(interStimulusInterval) numberStyle:NSNumberFormatterDecimalStyle]];
            step.detailText = ORKLocalizedString(@"PSAT_CALL_TO_ACTION", nil);
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.stepDuration = 5.0;
        step.title = versionTitle;

        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKPSATStep *step = [[ORKPSATStep alloc] initWithIdentifier:ORKPSATStepIdentifier];
        step.title = versionTitle;
        step.text = ORKLocalizedString(@"PSAT_INITIAL_INSTRUCTION", nil);
        step.stepDuration = (seriesLength + 1) * interStimulusInterval;
        step.presentationMode = presentationMode;
        step.interStimulusInterval = interStimulusInterval;
        step.stimulusDuration = stimulusDuration;
        step.seriesLength = seriesLength;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:[steps copy]];
    
    return task;
}


#pragma mark - tremorTestTask

NSString *const ORKTremorTestInLapStepIdentifier = @"tremor.handInLap";
NSString *const ORKTremorTestExtendArmStepIdentifier = @"tremor.handAtShoulderLength";
NSString *const ORKTremorTestBendArmStepIdentifier = @"tremor.handAtShoulderLengthWithElbowBent";
NSString *const ORKTremorTestTouchNoseStepIdentifier = @"tremor.handToNose";
NSString *const ORKTremorTestTurnWristStepIdentifier = @"tremor.handQueenWave";

+ (NSString *)stepIdentifier:(NSString *)stepIdentifier withHandIdentifier:(NSString *)handIdentifier {
    return [NSString stringWithFormat:@"%@.%@", stepIdentifier, handIdentifier];
}

+ (NSMutableArray *)stepsForOneHandTremorTestTaskWithIdentifier:(NSString *)identifier
                                             activeStepDuration:(NSTimeInterval)activeStepDuration
                                              activeTaskOptions:(ORKTremorActiveTaskOption)activeTaskOptions
                                                       lastHand:(BOOL)lastHand
                                                       leftHand:(BOOL)leftHand
                                                 handIdentifier:(NSString *)handIdentifier
                                                introDetailText:(NSString *)detailText
                                                        options:(ORKPredefinedTaskOption)options {
    NSMutableArray<ORKActiveStep *> *steps = [NSMutableArray array];
    NSString *stepFinishedInstruction = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_FINISHED_INSTRUCTION", nil);
    BOOL rightHand = !leftHand && ![handIdentifier isEqualToString:ORKActiveTaskMostAffectedHandIdentifier];
    
    {
        NSString *stepIdentifier = [self stepIdentifier:ORKInstruction1StepIdentifier withHandIdentifier:handIdentifier];
        ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
        step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
        
        if ([identifier isEqualToString:ORKActiveTaskMostAffectedHandIdentifier]) {
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DEFAULT_TEXT", nil);
            step.text = detailText;
        } else {
            if (leftHand) {
                step.detailText = ORKLocalizedString(@"TREMOR_TEST_INTRO_2_LEFT_HAND_TEXT", nil);
            } else {
                step.detailText = ORKLocalizedString(@"TREMOR_TEST_INTRO_2_RIGHT_HAND_TEXT", nil);
            }
        }
        
        NSString *imageName = leftHand ? @"tremortestLeft" : @"tremortestRight";
        step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        step.shouldTintImages = YES;
        
        ORKStepArrayAddStep(steps, step);
    }

    if (!(activeTaskOptions & ORKTremorActiveTaskOptionExcludeHandInLap)) {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            NSString *stepIdentifier = [self stepIdentifier:ORKInstruction2StepIdentifier withHandIdentifier:handIdentifier];
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_IN_LAP_INTRO", nil);
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"tremortest3a" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.auxiliaryImage = [UIImage imageNamed:@"tremortest3b" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_IN_LAP_INTRO_LEFT", nil);
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
                step.auxiliaryImage = [step.auxiliaryImage ork_flippedImage:UIImageOrientationUpMirrored];
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_IN_LAP_INTRO_RIGHT", nil);
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *stepIdentifier = [self stepIdentifier:ORKCountdown1StepIdentifier withHandIdentifier:handIdentifier];
            ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *titleFormat = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_IN_LAP_INSTRUCTION_%ld", nil);
            NSString *stepIdentifier = [self stepIdentifier:ORKTremorTestInLapStepIdentifier withHandIdentifier:handIdentifier];
            ORKActiveStep *step = [[ORKActiveStep alloc] initWithIdentifier:stepIdentifier];
            step.recorderConfigurations = @[[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:@"ac1_acc" frequency:100.0], [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:@"ac1_motion" frequency:100.0]];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:titleFormat, (long)activeStepDuration];
            step.spokenInstruction = step.text;
            step.finishedSpokenInstruction = stepFinishedInstruction;
            step.stepDuration = activeStepDuration;
            step.shouldPlaySoundOnStart = YES;
            step.shouldVibrateOnStart = YES;
            step.shouldPlaySoundOnFinish = YES;
            step.shouldVibrateOnFinish = YES;
            step.shouldContinueOnFinish = NO;
            step.shouldStartTimerAutomatically = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    if (!(activeTaskOptions & ORKTremorActiveTaskOptionExcludeHandAtShoulderHeight)) {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            NSString *stepIdentifier = [self stepIdentifier:ORKInstruction4StepIdentifier withHandIdentifier:handIdentifier];
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_EXTEND_ARM_INTRO", nil);
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"tremortest4a" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.auxiliaryImage = [UIImage imageNamed:@"tremortest4b" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_EXTEND_ARM_INTRO_LEFT", nil);
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
                step.auxiliaryImage = [step.auxiliaryImage ork_flippedImage:UIImageOrientationUpMirrored];
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_EXTEND_ARM_INTRO_RIGHT", nil);
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *stepIdentifier = [self stepIdentifier:ORKCountdown2StepIdentifier withHandIdentifier:handIdentifier];
            ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *titleFormat = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_EXTEND_ARM_INSTRUCTION_%ld", nil);
            NSString *stepIdentifier = [self stepIdentifier:ORKTremorTestExtendArmStepIdentifier withHandIdentifier:handIdentifier];
            ORKActiveStep *step = [[ORKActiveStep alloc] initWithIdentifier:stepIdentifier];
            step.recorderConfigurations = @[[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:@"ac2_acc" frequency:100.0], [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:@"ac2_motion" frequency:100.0]];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:titleFormat, (long)activeStepDuration];
            step.spokenInstruction = step.text;
            step.finishedSpokenInstruction = stepFinishedInstruction;
            step.stepDuration = activeStepDuration;
            step.image = [UIImage imageNamed:@"tremortest4a" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
            }
            step.shouldPlaySoundOnStart = YES;
            step.shouldVibrateOnStart = YES;
            step.shouldPlaySoundOnFinish = YES;
            step.shouldVibrateOnFinish = YES;
            step.shouldContinueOnFinish = NO;
            step.shouldStartTimerAutomatically = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    if (!(activeTaskOptions & ORKTremorActiveTaskOptionExcludeHandAtShoulderHeightElbowBent)) {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            NSString *stepIdentifier = [self stepIdentifier:ORKInstruction5StepIdentifier withHandIdentifier:handIdentifier];
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_BEND_ARM_INTRO", nil);
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"tremortest5a" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.auxiliaryImage = [UIImage imageNamed:@"tremortest5b" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_BEND_ARM_INTRO_LEFT", nil);
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
                step.auxiliaryImage = [step.auxiliaryImage ork_flippedImage:UIImageOrientationUpMirrored];
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_BEND_ARM_INTRO_RIGHT", nil);
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *stepIdentifier = [self stepIdentifier:ORKCountdown3StepIdentifier withHandIdentifier:handIdentifier];
            ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *titleFormat = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_BEND_ARM_INSTRUCTION_%ld", nil);
            NSString *stepIdentifier = [self stepIdentifier:ORKTremorTestBendArmStepIdentifier withHandIdentifier:handIdentifier];
            ORKActiveStep *step = [[ORKActiveStep alloc] initWithIdentifier:stepIdentifier];
            step.recorderConfigurations = @[[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:@"ac3_acc" frequency:100.0], [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:@"ac3_motion" frequency:100.0]];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:titleFormat, (long)activeStepDuration];
            step.spokenInstruction = step.text;
            step.finishedSpokenInstruction = stepFinishedInstruction;
            step.stepDuration = activeStepDuration;
            step.shouldPlaySoundOnStart = YES;
            step.shouldVibrateOnStart = YES;
            step.shouldPlaySoundOnFinish = YES;
            step.shouldVibrateOnFinish = YES;
            step.shouldContinueOnFinish = NO;
            step.shouldStartTimerAutomatically = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    if (!(activeTaskOptions & ORKTremorActiveTaskOptionExcludeHandToNose)) {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            NSString *stepIdentifier = [self stepIdentifier:ORKInstruction6StepIdentifier withHandIdentifier:handIdentifier];
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TOUCH_NOSE_INTRO", nil);
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"tremortest6a" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.auxiliaryImage = [UIImage imageNamed:@"tremortest6b" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TOUCH_NOSE_INTRO_LEFT", nil);
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
                step.auxiliaryImage = [step.auxiliaryImage ork_flippedImage:UIImageOrientationUpMirrored];
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TOUCH_NOSE_INTRO_RIGHT", nil);
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *stepIdentifier = [self stepIdentifier:ORKCountdown4StepIdentifier withHandIdentifier:handIdentifier];
            ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *titleFormat = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TOUCH_NOSE_INSTRUCTION_%ld", nil);
            NSString *stepIdentifier = [self stepIdentifier:ORKTremorTestTouchNoseStepIdentifier withHandIdentifier:handIdentifier];
            ORKActiveStep *step = [[ORKActiveStep alloc] initWithIdentifier:stepIdentifier];
            step.recorderConfigurations = @[[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:@"ac4_acc" frequency:100.0], [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:@"ac4_motion" frequency:100.0]];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:titleFormat, (long)activeStepDuration];
            step.spokenInstruction = step.text;
            step.finishedSpokenInstruction = stepFinishedInstruction;
            step.stepDuration = activeStepDuration;
            step.shouldPlaySoundOnStart = YES;
            step.shouldVibrateOnStart = YES;
            step.shouldPlaySoundOnFinish = YES;
            step.shouldVibrateOnFinish = YES;
            step.shouldContinueOnFinish = NO;
            step.shouldStartTimerAutomatically = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    if (!(activeTaskOptions & ORKTremorActiveTaskOptionExcludeQueenWave)) {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            NSString *stepIdentifier = [self stepIdentifier:ORKInstruction7StepIdentifier withHandIdentifier:handIdentifier];
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TURN_WRIST_INTRO", nil);
            step.detailText = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_INTRO_TEXT", nil);
            step.image = [UIImage imageNamed:@"tremortest7" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (leftHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TURN_WRIST_INTRO_LEFT", nil);
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
            } else if (rightHand) {
                step.text = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TURN_WRIST_INTRO_RIGHT", nil);
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *stepIdentifier = [self stepIdentifier:ORKCountdown5StepIdentifier withHandIdentifier:handIdentifier];
            ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:stepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            NSString *titleFormat = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_TURN_WRIST_INSTRUCTION_%ld", nil);
            NSString *stepIdentifier = [self stepIdentifier:ORKTremorTestTurnWristStepIdentifier withHandIdentifier:handIdentifier];
            ORKActiveStep *step = [[ORKActiveStep alloc] initWithIdentifier:stepIdentifier];
            step.recorderConfigurations = @[[[ORKAccelerometerRecorderConfiguration alloc] initWithIdentifier:@"ac5_acc" frequency:100.0], [[ORKDeviceMotionRecorderConfiguration alloc] initWithIdentifier:@"ac5_motion" frequency:100.0]];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.text = [NSString localizedStringWithFormat:titleFormat, (long)activeStepDuration];
            step.spokenInstruction = step.text;
            step.finishedSpokenInstruction = stepFinishedInstruction;
            step.stepDuration = activeStepDuration;
            step.shouldPlaySoundOnStart = YES;
            step.shouldVibrateOnStart = YES;
            step.shouldPlaySoundOnFinish = YES;
            step.shouldVibrateOnFinish = YES;
            step.shouldContinueOnFinish = NO;
            step.shouldStartTimerAutomatically = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    // fix the spoken instruction on the last included step, depending on which hand we're on
    ORKActiveStep *lastStep = (ORKActiveStep *)[steps lastObject];
    if (lastHand) {
        lastStep.finishedSpokenInstruction = ORKLocalizedString(@"TREMOR_TEST_COMPLETED_INSTRUCTION", nil);
    } else if (leftHand) {
        lastStep.finishedSpokenInstruction = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_SWITCH_HANDS_RIGHT_INSTRUCTION", nil);
    } else {
        lastStep.finishedSpokenInstruction = ORKLocalizedString(@"TREMOR_TEST_ACTIVE_STEP_SWITCH_HANDS_LEFT_INSTRUCTION", nil);
    }
    
    return steps;
}

+ (ORKNavigableOrderedTask *)tremorTestTaskWithIdentifier:(NSString *)identifier
                                   intendedUseDescription:(nullable NSString *)intendedUseDescription
                                       activeStepDuration:(NSTimeInterval)activeStepDuration
                                        activeTaskOptions:(ORKTremorActiveTaskOption)activeTaskOptions
                                              handOptions:(ORKPredefinedTaskHandOption)handOptions
                                                  options:(ORKPredefinedTaskOption)options {
    
    NSMutableArray<__kindof ORKStep *> *steps = [NSMutableArray array];
    // coin toss for which hand first (in case we're doing both)
    BOOL leftFirstIfDoingBoth = arc4random_uniform(2) == 1;
    BOOL doingBoth = ((handOptions & ORKPredefinedTaskHandOptionLeft) && (handOptions & ORKPredefinedTaskHandOptionRight));
    BOOL firstIsLeft = (leftFirstIfDoingBoth && doingBoth) || (!doingBoth && (handOptions & ORKPredefinedTaskHandOptionLeft));
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TREMOR_TEST_TITLE", nil);
            step.detailText = intendedUseDescription;
            step.text = ORKLocalizedString(@"TREMOR_TEST_INTRO_1_DETAIL", nil);
            step.image = [UIImage imageNamed:@"tremortest1" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            if (firstIsLeft) {
                step.image = [step.image ork_flippedImage:UIImageOrientationUpMirrored];
            }
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    // Build the string for the detail texts
    NSArray<NSString *>*detailStringForNumberOfTasks = @[
                                                         ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_1_TASK", nil),
                                                         ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_2_TASK", nil),
                                                         ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_3_TASK", nil),
                                                         ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_4_TASK", nil),
                                                         ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_5_TASK", nil)
                                                         ];
    
    // start with the count for all the tasks, then subtract one for each excluded task flag
    static const NSInteger allTasks = 5; // hold in lap, outstretched arm, elbow bent, repeatedly touching nose, queen wave
    NSInteger actualTasksIndex = allTasks - 1;
    for (NSInteger i = 0; i < allTasks; ++i) {
        if (activeTaskOptions & (1 << i)) {
            actualTasksIndex--;
        }
    }
    
    NSString *detailFormat = doingBoth ? ORKLocalizedString(@"TREMOR_TEST_SKIP_QUESTION_BOTH_HANDS_%@", nil) : ORKLocalizedString(@"TREMOR_TEST_INTRO_2_DETAIL_DEFAULT_%@", nil);
    NSString *detailText = [NSString localizedStringWithFormat:detailFormat, detailStringForNumberOfTasks[actualTasksIndex]];
    
    if (doingBoth) {
        // If doing both hands then ask the user if they need to skip one of the hands
        ORKTextChoice *skipRight = [ORKTextChoice choiceWithText:ORKLocalizedString(@"TREMOR_SKIP_RIGHT_HAND", nil)
                                                          value:ORKActiveTaskRightHandIdentifier];
        ORKTextChoice *skipLeft = [ORKTextChoice choiceWithText:ORKLocalizedString(@"TREMOR_SKIP_LEFT_HAND", nil)
                                                          value:ORKActiveTaskLeftHandIdentifier];
        ORKTextChoice *skipNeither = [ORKTextChoice choiceWithText:ORKLocalizedString(@"TREMOR_SKIP_NEITHER", nil)
                                                             value:@""];

        ORKAnswerFormat *answerFormat = [ORKAnswerFormat choiceAnswerFormatWithStyle:ORKChoiceAnswerStyleSingleChoice
                                                                         textChoices:@[skipRight, skipLeft, skipNeither]];
        ORKQuestionStep *step = [ORKQuestionStep questionStepWithIdentifier:ORKActiveTaskSkipHandStepIdentifier
                                                                      title:ORKLocalizedString(@"TREMOR_TEST_TITLE", nil)
                                                                   question:nil
                                                                     answer:answerFormat];
        step.optional = NO;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    // right or most-affected hand
    NSArray<__kindof ORKStep *> *rightSteps = nil;
    if (handOptions == ORKPredefinedTaskHandOptionUnspecified) {
        rightSteps = [self stepsForOneHandTremorTestTaskWithIdentifier:identifier
                                                    activeStepDuration:activeStepDuration
                                                     activeTaskOptions:activeTaskOptions
                                                              lastHand:YES
                                                              leftHand:NO
                                                        handIdentifier:ORKActiveTaskMostAffectedHandIdentifier
                                                       introDetailText:detailText
                                                               options:options];
    } else if (handOptions & ORKPredefinedTaskHandOptionRight) {
        rightSteps = [self stepsForOneHandTremorTestTaskWithIdentifier:identifier
                                                    activeStepDuration:activeStepDuration
                                                     activeTaskOptions:activeTaskOptions
                                                              lastHand:firstIsLeft
                                                              leftHand:NO
                                                        handIdentifier:ORKActiveTaskRightHandIdentifier
                                                       introDetailText:nil
                                                               options:options];
    }
    
    // left hand
    NSArray<__kindof ORKStep *> *leftSteps = nil;
    if (handOptions & ORKPredefinedTaskHandOptionLeft) {
        leftSteps = [self stepsForOneHandTremorTestTaskWithIdentifier:identifier
                                                   activeStepDuration:activeStepDuration
                                                    activeTaskOptions:activeTaskOptions
                                                             lastHand:!firstIsLeft || !(handOptions & ORKPredefinedTaskHandOptionRight)
                                                             leftHand:YES
                                                       handIdentifier:ORKActiveTaskLeftHandIdentifier
                                                      introDetailText:nil
                                                              options:options];
    }
    
    if (firstIsLeft && leftSteps != nil) {
        [steps addObjectsFromArray:leftSteps];
    }
    
    if (rightSteps != nil) {
        [steps addObjectsFromArray:rightSteps];
    }
    
    if (!firstIsLeft && leftSteps != nil) {
        [steps addObjectsFromArray:leftSteps];
    }
    
    BOOL hasCompletionStep = NO;
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        hasCompletionStep = YES;
        ORKCompletionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }

    ORKNavigableOrderedTask *task = [[ORKNavigableOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    if (doingBoth) {
        // Setup rules for skipping all the steps in either the left or right hand if called upon to do so.
        ORKResultSelector *resultSelector = [ORKResultSelector selectorWithStepIdentifier:ORKActiveTaskSkipHandStepIdentifier
                                                                         resultIdentifier:ORKActiveTaskSkipHandStepIdentifier];
        NSPredicate *predicateRight = [ORKResultPredicate predicateForChoiceQuestionResultWithResultSelector:resultSelector expectedAnswerValue:ORKActiveTaskRightHandIdentifier];
        NSPredicate *predicateLeft = [ORKResultPredicate predicateForChoiceQuestionResultWithResultSelector:resultSelector expectedAnswerValue:ORKActiveTaskLeftHandIdentifier];
        
        // Setup rule for skipping first hand
        NSString *secondHandIdentifier = firstIsLeft ? [[rightSteps firstObject] identifier] : [[leftSteps firstObject] identifier];
        NSPredicate *firstPredicate = firstIsLeft ? predicateLeft : predicateRight;
        ORKStepNavigationRule *skipFirst = [[ORKPredicateStepNavigationRule alloc] initWithResultPredicates:@[firstPredicate]
                                                                                 destinationStepIdentifiers:@[secondHandIdentifier]];
        [task setNavigationRule:skipFirst forTriggerStepIdentifier:ORKActiveTaskSkipHandStepIdentifier];
        
        // Setup rule for skipping the second hand
        NSString *triggerIdentifier = firstIsLeft ? [[leftSteps lastObject] identifier] : [[rightSteps lastObject] identifier];
        NSString *conclusionIdentifier = hasCompletionStep ? [[steps lastObject] identifier] : ORKNullStepIdentifier;
        NSPredicate *secondPredicate = firstIsLeft ? predicateRight : predicateLeft;
        ORKStepNavigationRule *skipSecond = [[ORKPredicateStepNavigationRule alloc] initWithResultPredicates:@[secondPredicate]
                                                                                  destinationStepIdentifiers:@[conclusionIdentifier]];
        [task setNavigationRule:skipSecond forTriggerStepIdentifier:triggerIdentifier];
        
        // Setup step modifier to change the finished spoken step if skipping the second hand
        NSString *key = NSStringFromSelector(@selector(finishedSpokenInstruction));
        NSString *value = ORKLocalizedString(@"TREMOR_TEST_COMPLETED_INSTRUCTION", nil);
        ORKStepModifier *stepModifier = [[ORKKeyValueStepModifier alloc] initWithResultPredicate:secondPredicate
                                                                                     keyValueMap:@{key: value}];
        [task setStepModifier:stepModifier forStepIdentifier:triggerIdentifier];
    }
    
    return task;
}


#pragma mark - trailmakingTask

NSString *const ORKTrailmakingStepIdentifier = @"trailmaking";

+ (ORKOrderedTask *)trailmakingTaskWithIdentifier:(NSString *)identifier
                           intendedUseDescription:(nullable NSString *)intendedUseDescription
                           trailmakingInstruction:(nullable NSString *)trailmakingInstruction
                                        trailType:(ORKTrailMakingTypeIdentifier)trailType
                                          options:(ORKPredefinedTaskOption)options {
    
    NSArray *supportedTypes = @[ORKTrailMakingTypeIdentifierA, ORKTrailMakingTypeIdentifierB];
    NSAssert1([supportedTypes containsObject:trailType], @"Trail type %@ is not supported.", trailType);
    
    NSMutableArray<__kindof ORKStep *> *steps = [NSMutableArray array];
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction0StepIdentifier];
            step.title = ORKLocalizedString(@"TRAILMAKING_TASK_TITLE", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"TRAILMAKING_INTENDED_USE", nil);
            step.image = [UIImage imageNamed:@"trailmaking" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction1StepIdentifier];
            step.title = ORKLocalizedString(@"TRAILMAKING_TASK_TITLE", nil);
            if ([trailType isEqualToString:ORKTrailMakingTypeIdentifierA]) {
                step.detailText = ORKLocalizedString(@"TRAILMAKING_INTENDED_USE2_A", nil);
            } else {
                step.detailText = ORKLocalizedString(@"TRAILMAKING_INTENDED_USE2_B", nil);
            }
            step.image = [UIImage imageNamed:@"trailmaking" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
        
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKInstruction2StepIdentifier];
            step.title = ORKLocalizedString(@"TRAILMAKING_TASK_TITLE", nil);
            step.text = trailmakingInstruction ? : ORKLocalizedString(@"TRAILMAKING_INTRO_TEXT",nil);
            step.detailText = ORKLocalizedString(@"TRAILMAKING_CALL_TO_ACTION", nil);
            step.image = [UIImage imageNamed:@"trailmaking" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
            step.shouldTintImages = YES;
            
            ORKStepArrayAddStep(steps, step);
        }
    }
    
    {
        ORKCountdownStep *step = [[ORKCountdownStep alloc] initWithIdentifier:ORKCountdownStepIdentifier];
        step.title = ORKLocalizedString(@"TRAILMAKING_TASK_TITLE", nil);
        step.stepDuration = 3.0;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    {
        ORKTrailmakingStep *step = [[ORKTrailmakingStep alloc] initWithIdentifier:ORKTrailmakingStepIdentifier];
        step.title = ORKLocalizedString(@"TRAILMAKING_TASK_TITLE", nil);
        step.trailType = trailType;
        
        ORKStepArrayAddStep(steps, step);
    }
    
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKInstructionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }

    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:steps];
    
    return task;
}


#pragma mark - implicitAssociationTask

+ (ORKOrderedTask *)implicitAssociationTaskWithIdentifier:(NSString *)identifier
                                   intendedUseDescription:(nullable NSString *)intendedUseDescription
                                       attributeACategory:(NSString *)attributeACategory
                                          attributeAItems:(NSArray *)attributeAItems
                                       attributeBCategory:(NSString *)attributeBCategory
                                          attributeBItems:(NSArray *)attributeBItems
                                         conceptACategory:(NSString *)conceptACategory
                                            conceptAItems:(NSArray *)conceptAItems
                                         conceptBCategory:(NSString *)conceptBCategory
                                            conceptBItems:(NSArray *)conceptBItems
                                                  options:(ORKPredefinedTaskOption)options {
    return [self implicitAssociationTaskWithIdentifier:identifier
                                intendedUseDescription:intendedUseDescription
                                    attributeACategory:attributeACategory
                                       attributeAItems:attributeAItems
                                    attributeBCategory:attributeBCategory
                                       attributeBItems:attributeBItems
                                      conceptACategory:conceptACategory
                                         conceptAItems:conceptAItems
                                      conceptBCategory:conceptBCategory
                                         conceptBItems:conceptBItems
                                          trialsBlock1:@20
                                          trialsBlock2:@20
                                          trialsBlock3:@20
                                          trialsBlock4:@40
                                          trialsBlock5:@28
                                          trialsBlock6:@20
                                          trialsBlock7:@40
                                               options:options];
}

+ (ORKOrderedTask *)implicitAssociationTaskWithIdentifier:(NSString *)identifier
                                   intendedUseDescription:(nullable NSString *)intendedUseDescription
                                       attributeACategory:(NSString *)attributeACategory
                                          attributeAItems:(NSArray *)attributeAItems
                                       attributeBCategory:(NSString *)attributeBCategory
                                          attributeBItems:(NSArray *)attributeBItems
                                         conceptACategory:(NSString *)conceptACategory
                                            conceptAItems:(NSArray *)conceptAItems
                                         conceptBCategory:(NSString *)conceptBCategory
                                            conceptBItems:(NSArray *)conceptBItems
                                             trialsBlock1:(NSNumber *)trialsBlock1
                                             trialsBlock2:(NSNumber *)trialsBlock2
                                             trialsBlock3:(NSNumber *)trialsBlock3
                                             trialsBlock4:(NSNumber *)trialsBlock4
                                             trialsBlock5:(NSNumber *)trialsBlock5
                                             trialsBlock6:(NSNumber *)trialsBlock6
                                             trialsBlock7:(NSNumber *)trialsBlock7
                                                  options:(ORKPredefinedTaskOption)options {
    
    typedef NS_ENUM(NSUInteger, ORKImplicitAssociationStepBlock) {
        ORKImplicitAssociationStepBlockSortCategory,
        ORKImplicitAssociationStepBlockSortAttribute,
        ORKImplicitAssociationStepBlockCombinedPractice,
        ORKImplicitAssociationStepBlockCombinedCritical,
        ORKImplicitAssociationStepBlockSortCategoryReverse,
        ORKImplicitAssociationStepBlockCombinedPracticeReverse,
        ORKImplicitAssociationStepBlockCombinedCriticalReverse
    };
#define ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlock) [[@[trialsBlock1, trialsBlock2, trialsBlock3, trialsBlock4, trialsBlock5, trialsBlock6, trialsBlock7] objectAtIndex:ORKImplicitAssociationStepBlock] unsignedIntegerValue]
    
    typedef NS_ENUM(NSUInteger, ORKImplicitAssociationBlock) {
        ORKImplicitAssociationIntroductionCategories,
        ORKImplicitAssociationIntroductionBlocks,
        ORKImplicitAssociationBlock1Intro,
        ORKImplicitAssociationBlock1Test,
        ORKImplicitAssociationBlock2Intro,
        ORKImplicitAssociationBlock2Test,
        ORKImplicitAssociationBlock3Intro,
        ORKImplicitAssociationBlock3Test,
        ORKImplicitAssociationBlock4Intro,
        ORKImplicitAssociationBlock4Test,
        ORKImplicitAssociationBlock5Intro,
        ORKImplicitAssociationBlock5Test,
        ORKImplicitAssociationBlock6Intro,
        ORKImplicitAssociationBlock6Test,
        ORKImplicitAssociationBlock7Intro,
        ORKImplicitAssociationBlock7Test
    };
    
    NSMutableArray *steps = [@[ [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null] ] mutableCopy];
    
    
    //not required by minno-time, but makes it balanced
    NSAssert(trialsBlock1.integerValue % 2 == 0, @"number of trials in block 1 have to be even");
    NSAssert(trialsBlock2.integerValue % 2 == 0, @"number of trials in block 2 have to be even");
    NSAssert(trialsBlock3.integerValue % 4 == 0, @"number of trials in block 3 have to be divisible by 4");
    NSAssert(trialsBlock4.integerValue % 4 == 0, @"number of trials in block 4 have to be divisible by 4");
    NSAssert(trialsBlock5.integerValue % 2 == 0, @"number of trials in block 5 have to be even");
    NSAssert(trialsBlock6.integerValue % 4 == 0, @"number of trials in block 6 have to be divisible by 4");
    NSAssert(trialsBlock7.integerValue % 4 == 0, @"number of trials in block 7 have to be divisible by 4");
    NSAssert(conceptAItems.count == conceptBItems.count, @"Number of concepts A and concepts B have to be equal");
    NSAssert(attributeAItems.count == attributeBItems.count, @"Number of attributes A and attributes B have to be equal");
    
    
    //Concepts
    NSMutableArray *conceptsAll = [NSMutableArray array];
    [conceptsAll addObjectsFromArray:conceptAItems];
    [conceptsAll addObjectsFromArray:conceptBItems];
    
    //Attributes
    NSMutableArray *attributesAll = [NSMutableArray array];
    [attributesAll addObjectsFromArray:attributeAItems];
    [attributesAll addObjectsFromArray:attributeBItems];
    
    
    //Terms Block 1 & Block 5
    NSArray *termsBlock1 = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock1.integerValue];
    NSArray *termsBlock5 = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock5.integerValue];
    
    //Terms Block 2
    NSArray *termsBlock2 = [ORKOrderedTask exRandomOfArray:attributesAll forNumberOfItems:trialsBlock2.integerValue];
    
    //Terms Block 3
    NSArray *termsBlock3Concepts = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock3.integerValue/2];
    NSArray *termsBlock3Attributes = [ORKOrderedTask exRandomOfArray:attributesAll forNumberOfItems:trialsBlock3.integerValue/2];
    NSMutableArray *termsBlock3 = [NSMutableArray array];
    for (int i=0; i<trialsBlock3.integerValue/2; ++i) {
        //always first concept, second attribute as in minno-time
        [termsBlock3 addObject:termsBlock3Concepts[i]];
        [termsBlock3 addObject:termsBlock3Attributes[i]];
    }
    
    //Terms Block 4
    NSArray *termsBlock4Concepts = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock4.integerValue/2];
    NSArray *termsBlock4Attributes = [ORKOrderedTask exRandomOfArray:attributesAll forNumberOfItems:trialsBlock4.integerValue/2];
    NSMutableArray *termsBlock4 = [NSMutableArray array];
    for (int i=0; i<trialsBlock4.integerValue/2; ++i) {
        //always first concept, second attribute as in minno-time
        [termsBlock4 addObject:termsBlock4Concepts[i]];
        [termsBlock4 addObject:termsBlock4Attributes[i]];
    }
    
    //Terms Block 6
    NSArray *termsBlock6Concepts = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock6.integerValue/2];
    NSArray *termsBlock6Attributes = [ORKOrderedTask exRandomOfArray:attributesAll forNumberOfItems:trialsBlock6.integerValue/2];
    NSMutableArray *termsBlock6 = [NSMutableArray array];
    for (int i=0; i<trialsBlock6.integerValue/2; ++i) {
        //always first concept, second attribute as in minno-time
        [termsBlock6 addObject:termsBlock6Concepts[i]];
        [termsBlock6 addObject:termsBlock6Attributes[i]];
    }
    
    //Terms Block 7
    NSArray *termsBlock7Concepts = [ORKOrderedTask exRandomOfArray:conceptsAll forNumberOfItems:trialsBlock7.integerValue/2];
    NSArray *termsBlock7Attributes = [ORKOrderedTask exRandomOfArray:attributesAll forNumberOfItems:trialsBlock7.integerValue/2];
    NSMutableArray *termsBlock7 = [NSMutableArray array];
    for (int i=0; i<trialsBlock7.integerValue/2; ++i) {
        //always first concept, second attribute as in minno-time
        [termsBlock7 addObject:termsBlock7Concepts[i]];
        [termsBlock7 addObject:termsBlock7Attributes[i]];
    }
    
    
    //Labels
    NSString *left = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_LEFT_LABEL", nil);
    NSString *right = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_RIGHT_LABEL", nil);
    NSString *sortingConceptsBlock1 = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_SORTING_CONCEPTS_BLOCK1_LABEL", nil);
    NSString *sortingConceptsBlock5 = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_SORTING_CONCEPTS_BLOCK5_LABEL", nil);
    NSString *sortingAttributes = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_SORTING_ATTRIBUTES_LABEL", nil);
    NSString *combined = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_COMBINED_LABEL", nil);
    NSString *go = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_GO_LABEL", nil);
    NSString *hint = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_HINT_LABEL", nil);
    
    NSUInteger randomConceptSide = arc4random_uniform(2);
    
    
    // Introduction
    
    if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
        {
            ORKImplicitAssociationCategoriesInstructionStep *step = [[ORKImplicitAssociationCategoriesInstructionStep alloc] initWithIdentifier:ORKImplicitAssociationIntroductionCategoriesStepIdentifier];
            step.title = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INTRODUCTION_TITLE_LABEL", nil);
            step.text = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INTRODUCTION_TEXT_LABEL", nil);
            step.attributeACategory = attributeACategory;
            step.attributeAItems = attributeAItems;
            step.attributeBCategory = attributeBCategory;
            step.attributeBItems = attributeBItems;
            step.conceptACategory = conceptACategory;
            step.conceptAItems = conceptAItems;
            step.conceptBCategory = conceptBCategory;
            step.conceptBItems = conceptBItems;
            [steps replaceObjectAtIndex:ORKImplicitAssociationIntroductionCategories withObject:step];
        }
        
        {
            ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKImplicitAssociationIntroductionBlocksStepIdentifier];
            step.title = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INTRODUCTION_TITLE_LABEL", nil);
            step.text = intendedUseDescription;
            step.detailText = ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INTRODUCTION_PARTS_LABEL", nil);
            step.shouldTintImages = YES;
            [step validateParameters];
            [steps replaceObjectAtIndex:ORKImplicitAssociationIntroductionBlocks withObject:step];
        }
        
    }
    
    // Block 1 & Block 5 concept sorting
    
    {
        for (NSUInteger index = 0; index <= 1; index++) {
            if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
                {
                    ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock1IntroductionStepIdentifier : ORKImplicitAssociationBlock5IntroductionStepIdentifier];
                    step.title = index == 0 ? @"Part 1 of 7" : @"Part 5 of 7";
                    step.text = intendedUseDescription;
                    NSMutableString *detailText = [NSMutableString string];
                    if (index == 1) {
                        [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_WATCH_LABEL", nil)];
                        [detailText appendString:@"\n\n"];
                    }
                    [detailText appendString:[NSString localizedStringWithFormat:index == 0 ? sortingConceptsBlock1 : sortingConceptsBlock5, left, left, (index == 0 && randomConceptSide == 1) || (index == 1 && randomConceptSide == 0) ? conceptACategory : conceptBCategory]];
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:[NSString localizedStringWithFormat:index == 0 ? sortingConceptsBlock1 : sortingConceptsBlock5, right, right, (index == 0 && randomConceptSide == 1) || (index == 1 && randomConceptSide == 0) ? conceptBCategory : conceptACategory]];
                    if (index == 0) {
                        [detailText appendString:@"\n\n"];
                        [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_APPEAR_LABEL", nil)];
                    }
                    if (index == 0) {
                        [detailText appendString:@"\n\n"];
                        [detailText appendString:hint];
                    }
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:go];
                    step.attributedDetailText = [ORKImplicitAssociationHelper textToHTML:detailText];
                    
                    NSString *imageName = @"phonetapping";
                    if (![[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
                        imageName = [imageName stringByAppendingString:@"_notap"];
                    }
                    step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                    step.shouldTintImages = YES;
                    
                    [step validateParameters];
                    index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock1Intro withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock5Intro withObject:step];
                }
            }
            
            ORKImplicitAssociationStep *step = [[ORKImplicitAssociationStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock1StepIdentifier : ORKImplicitAssociationBlock5StepIdentifier];
            step.block = ORKImplicitAssociationBlockTypeSort;
            step.shouldContinueOnFinish = YES;
            NSMutableArray *trials = [NSMutableArray array];
            for (NSUInteger trial = 0; trial < (index == 0 ? ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockSortCategory) : ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockSortCategoryReverse)); trial++) {
                
                NSString *term = [(index == 0 ? termsBlock1 : termsBlock5) objectAtIndex:trial];
                
                ORKImplicitAssociationCorrect termCorrect;
                
                ORKImplicitAssociationTrial *iaTrial = [ORKImplicitAssociationTrial new];
                if ((index == 0 && randomConceptSide == 1) || (index == 1 && randomConceptSide == 0)) {
                    termCorrect = [conceptAItems containsObject:term] ? ORKImplicitAssociationCorrectTARG1left : ORKImplicitAssociationCorrectTARG2right;
                    iaTrial.leftItem1 = conceptACategory;
                    iaTrial.rightItem1 = conceptBCategory;
                } else {
                    termCorrect = [conceptAItems containsObject:term] ? ORKImplicitAssociationCorrectTARG1right : ORKImplicitAssociationCorrectTARG2left;
                    iaTrial.leftItem1 = conceptBCategory;
                    iaTrial.rightItem1 = conceptACategory;
                }
                
                iaTrial.term = term;
                iaTrial.category = ORKImplicitAssociationCategoryConcept;
                iaTrial.correct = termCorrect;
                [trials addObject:iaTrial];
            }
            step.trials = trials;
            
            [step validateParameters];
            index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock1Test withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock5Test withObject:step];
        }
    }
    
    // Block 2 attribute sorting
    
    {
        if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
            {
                ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:ORKImplicitAssociationBlock2IntroductionStepIdentifier];
                step.title = @"Part 2 of 7";
                step.text = intendedUseDescription;
                NSMutableString *detailText = [NSMutableString string];
                [detailText appendString:[NSString localizedStringWithFormat:sortingAttributes, left, left, attributeACategory]];
                [detailText appendString:@"\n\n"];
                [detailText appendString:[NSString localizedStringWithFormat:sortingAttributes, right, right, attributeBCategory]];
                [detailText appendString:@"\n\n"];
                [detailText appendString:hint];
                [detailText appendString:@"\n\n"];
                [detailText appendString:go];
                step.attributedDetailText = [ORKImplicitAssociationHelper textToHTML:detailText];
                
                NSString *imageName = @"phonetapping";
                if (![[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
                    imageName = [imageName stringByAppendingString:@"_notap"];
                }
                step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                step.shouldTintImages = YES;
                
                [step validateParameters];
                [steps replaceObjectAtIndex:ORKImplicitAssociationBlock2Intro withObject:step];
            }
        }
        
        ORKImplicitAssociationStep *step = [[ORKImplicitAssociationStep alloc] initWithIdentifier:ORKImplicitAssociationBlock2StepIdentifier];
        step.block = ORKImplicitAssociationBlockTypeSort;
        step.shouldContinueOnFinish = YES;
        NSMutableArray *trials =[NSMutableArray array];
        
        for (NSUInteger trial = 0; trial < ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockSortAttribute); trial++) {
            
            NSString *term = [termsBlock2 objectAtIndex:trial];
            
            ORKImplicitAssociationCorrect termCorrect = [attributeAItems containsObject:term] ? ORKImplicitAssociationCorrectATTRleft : ORKImplicitAssociationCorrectATTRright;
            
            ORKImplicitAssociationTrial *iaTrial = [ORKImplicitAssociationTrial new];
            iaTrial.term = term;
            iaTrial.category = ORKImplicitAssociationCategoryAttribute;
            iaTrial.leftItem1 = attributeACategory;
            iaTrial.rightItem1 = attributeBCategory;
            iaTrial.correct = termCorrect;
            
            [trials addObject:iaTrial];
        }
        
        step.trials = trials;
        
        [step validateParameters];
        [steps replaceObjectAtIndex:ORKImplicitAssociationBlock2Test withObject:step];
    }
    
    //Block 3 & Block 4 combined practice and critical
    
    {
        for (NSUInteger index = 0; index <= 1; index++) {
            if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
                {
                    ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock3IntroductionStepIdentifier : ORKImplicitAssociationBlock4IntroductionStepIdentifier];
                    step.title = index == 0 ? @"Part 3 of 7" : @"Part 4 of 7";
                    step.text = intendedUseDescription;
                    NSMutableString *detailText = [NSMutableString string];
                    if (index == 1) {
                        [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_PREVIOUS_LABEL", nil)];
                        [detailText appendString:@"\n\n"];
                    }
                    [detailText appendString:[NSString localizedStringWithFormat:combined, left, randomConceptSide == 0 ? conceptBCategory : conceptACategory, attributeACategory]];
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:[NSString localizedStringWithFormat:combined, right, randomConceptSide == 0 ? conceptACategory : conceptBCategory, attributeBCategory]];
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_EACH_LABEL", nil)];
                    if (index == 0) {
                        [detailText appendString:@"\n\n"];
                        [detailText appendString:hint];
                    }
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:go];
                    step.attributedDetailText = [ORKImplicitAssociationHelper textToHTML:detailText];
                    
                    NSString *imageName = @"phonetapping";
                    if (![[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
                        imageName = [imageName stringByAppendingString:@"_notap"];
                    }
                    step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                    step.shouldTintImages = YES;
                    
                    [step validateParameters];
                    index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock3Intro withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock4Intro withObject:step];
                }
            }
            
            ORKImplicitAssociationStep *step = [[ORKImplicitAssociationStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock3StepIdentifier : ORKImplicitAssociationBlock4StepIdentifier];
            step.block = ORKImplicitAssociationBlockTypeCombine;
            step.shouldContinueOnFinish = YES;
            NSMutableArray *trials =[NSMutableArray array];
            
            for (NSUInteger trial = 0; trial < (index == 0 ? ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockCombinedPractice) : ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockCombinedCritical)); trial++) {
                
                NSString *term = [(index == 0 ? termsBlock3 : termsBlock4) objectAtIndex:trial];
                
                ORKImplicitAssociationCorrect termCorrect;
                
                if ([attributeAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectATTRleft;
                if ([attributeBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectATTRright;
                
                if (randomConceptSide == 0 && [conceptBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG2left;
                if (randomConceptSide == 1 && [conceptBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG2right;
                
                if (randomConceptSide == 0 && [conceptAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG1right;
                if (randomConceptSide == 1 && [conceptAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG1left;
                
                ORKImplicitAssociationTrial *iaTrial = [ORKImplicitAssociationTrial new];
                iaTrial.term = term;
                iaTrial.category = [conceptsAll containsObject:term] ? ORKImplicitAssociationCategoryConcept : ORKImplicitAssociationCategoryAttribute;
                iaTrial.leftItem1 = attributeACategory;
                iaTrial.leftItem2 = randomConceptSide == 0 ? conceptBCategory : conceptACategory;
                iaTrial.rightItem1 = attributeBCategory;
                iaTrial.rightItem2 = randomConceptSide == 0 ? conceptACategory : conceptBCategory;
                iaTrial.correct = termCorrect;
                
                [trials addObject:iaTrial];
            }
            
            step.trials = trials;
            
            [step validateParameters];
            index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock3Test withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock4Test withObject:step];
        }
    }
    
    //Block 6 & Block 7 combined practice and critical
    
    {
        for (NSUInteger index = 0; index <= 1; index++) {
            if (!(options & ORKPredefinedTaskOptionExcludeInstructions)) {
                {
                    ORKInstructionStep *step = [[ORKInstructionStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock6IntroductionStepIdentifier : ORKImplicitAssociationBlock7IntroductionStepIdentifier];
                    step.title = index == 0 ? @"Part 6 of 7" : @"Part 7 of 7";
                    step.text = intendedUseDescription;
                    NSMutableString *detailText = [NSMutableString string];
                    if (index == 1) {
                        [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_PREVIOUS_LABEL", nil)];
                        [detailText appendString:@"\n\n"];
                    }
                    [detailText appendString:[NSString localizedStringWithFormat:combined, left, randomConceptSide == 0 ? conceptACategory : conceptBCategory, attributeACategory]];
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:[NSString localizedStringWithFormat:combined, right, randomConceptSide == 0 ? conceptBCategory : conceptACategory, attributeBCategory]];
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:ORKLocalizedString(@"IMPLICIT_ASSOCIATION_INSTRUCTION_EACH_LABEL", nil)];
                    if (index == 0) {
                        [detailText appendString:@"\n\n"];
                        [detailText appendString:hint];
                    }
                    [detailText appendString:@"\n\n"];
                    [detailText appendString:go];
                    step.attributedDetailText = [ORKImplicitAssociationHelper textToHTML:detailText];
                    
                    NSString *imageName = @"phonetapping";
                    if (![[NSLocale preferredLanguages].firstObject hasPrefix:@"en"]) {
                        imageName = [imageName stringByAppendingString:@"_notap"];
                    }
                    step.image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
                    step.shouldTintImages = YES;
                    
                    [step validateParameters];
                    index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock6Intro withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock7Intro withObject:step];
                }
            }
            
            ORKImplicitAssociationStep *step = [[ORKImplicitAssociationStep alloc] initWithIdentifier:index == 0 ? ORKImplicitAssociationBlock6StepIdentifier : ORKImplicitAssociationBlock7StepIdentifier];
            step.block = ORKImplicitAssociationBlockTypeCombine;
            step.shouldContinueOnFinish = YES;
            NSMutableArray *trials =[NSMutableArray array];
            
            for (NSUInteger trial = 0; trial < (index == 0 ? ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockCombinedPracticeReverse) : ORKImplicitAssociationBlockTrials(ORKImplicitAssociationStepBlockCombinedCriticalReverse)); trial++) {
                
                NSString *term = [(index == 0 ? termsBlock6 : termsBlock7) objectAtIndex:trial];
                
                ORKImplicitAssociationCorrect termCorrect;
                
                if ([attributeAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectATTRleft;
                if ([attributeBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectATTRright;
                
                if (randomConceptSide == 0 && [conceptAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG1left;
                if (randomConceptSide == 1 && [conceptAItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG1right;
                
                if (randomConceptSide == 0 && [conceptBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG2right;
                if (randomConceptSide == 1 && [conceptBItems containsObject:term]) termCorrect = ORKImplicitAssociationCorrectTARG2left;
                
                ORKImplicitAssociationTrial *iaTrial = [ORKImplicitAssociationTrial new];
                iaTrial.term = term;
                iaTrial.category = [conceptsAll containsObject:term] ? ORKImplicitAssociationCategoryConcept : ORKImplicitAssociationCategoryAttribute;
                iaTrial.leftItem1 = attributeACategory;
                iaTrial.leftItem2 = randomConceptSide == 0 ? conceptACategory : conceptBCategory;
                iaTrial.rightItem1 = attributeBCategory;
                iaTrial.rightItem2 = randomConceptSide == 0 ? conceptBCategory : conceptACategory;
                iaTrial.correct = termCorrect;
                
                [trials addObject:iaTrial];
            }
            
            step.trials = trials;
            
            [step validateParameters];
            index == 0 ? [steps replaceObjectAtIndex:ORKImplicitAssociationBlock6Test withObject:step] : [steps replaceObjectAtIndex:ORKImplicitAssociationBlock7Test withObject:step];
        }
    }
    
    [steps removeObject:[NSNull null]];
     
    if (!(options & ORKPredefinedTaskOptionExcludeConclusion)) {
        ORKCompletionStep *step = [self makeCompletionStep];
        
        ORKStepArrayAddStep(steps, step);
    }
    
    ORKOrderedTask *task = [[ORKOrderedTask alloc] initWithIdentifier:identifier steps:[steps copy]];
    
    return task;
}

+ (NSArray *)exRandomOfArray:(NSArray *)array forNumberOfItems:(NSInteger)numberOfItems {
    NSArray *shuffledArray = [ORKOrderedTask shuffle:array];
    NSMutableArray *distributedArray = [NSMutableArray array];
    NSUInteger currentElement = 0;
    //distribute elements
    for (NSUInteger trial = 0; trial < numberOfItems; trial++) {
        [distributedArray addObject:[shuffledArray objectAtIndex:currentElement]];
        currentElement++;
        if (currentElement == shuffledArray.count) {
            currentElement = 0;
        }
    }
    return [ORKOrderedTask shuffle:[distributedArray copy]];
}

+ (NSArray *)shuffle:(NSArray *)array {
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSUInteger i = mutableArray.count; i > 1; i--)
        [mutableArray exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    return [mutableArray copy];
}

@end
