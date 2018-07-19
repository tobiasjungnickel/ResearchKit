//
//  ORKImplicitAssociationTrial.h
//  ResearchKit
//
//  Created by Tobias Jungnickel on 04.02.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORKResult.h"
#import "ORKTappingIntervalResult.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ORKImplicitAssociationCategory) {
    ORKImplicitAssociationCategoryAttribute,
    ORKImplicitAssociationCategoryConcept
};

typedef NS_ENUM(NSUInteger, ORKImplicitAssociationCorrect) {
    ORKImplicitAssociationCorrectATTRleft,
    ORKImplicitAssociationCorrectATTRright,
    ORKImplicitAssociationCorrectTARG1left,
    ORKImplicitAssociationCorrectTARG1right,
    ORKImplicitAssociationCorrectTARG2left,
    ORKImplicitAssociationCorrectTARG2right
};
#define ORKImplicitAssociationCorrectValue(ORKImplicitAssociationCorrect) [@[@"ATTRleft", @"ATTRright", @"TARG1left", @"TARG1right", @"TARG2left", @"TARG2right"] objectAtIndex:ORKImplicitAssociationCorrect]

@interface ORKImplicitAssociationTrial : NSObject

@property (nonatomic, strong) NSObject *term;

@property (nonatomic, assign) ORKImplicitAssociationCategory category;

@property (nonatomic, strong) NSString *leftItem1;

@property (nonatomic, strong) NSString *rightItem1;

@property (nonatomic, strong) NSString *leftItem2;

@property (nonatomic, strong) NSString *rightItem2;

@property (nonatomic, assign) ORKImplicitAssociationCorrect correct;

- (ORKTappingButtonIdentifier)buttonIdentifier;

@end

NS_ASSUME_NONNULL_END
