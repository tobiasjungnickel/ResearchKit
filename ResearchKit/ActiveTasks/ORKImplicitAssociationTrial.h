//
//  ORKImplicitAssociationTrial.h
//  ResearchKit
//
//  Created by Tobias Jungnickel on 04.02.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORKResult.h"


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

@interface ORKImplicitAssociationTrial : NSObject

@property (nonatomic, strong) NSString *term;

@property (nonatomic, assign) ORKImplicitAssociationCategory category;

@property (nonatomic, strong) NSString *leftItem1;

@property (nonatomic, strong) NSString *rightItem1;

@property (nonatomic, strong) NSString *leftItem2;

@property (nonatomic, strong) NSString *rightItem2;

@property (nonatomic, assign) ORKImplicitAssociationCorrect correct;

- (ORKTappingButtonIdentifier)buttonIdentifier;

@end

NS_ASSUME_NONNULL_END
