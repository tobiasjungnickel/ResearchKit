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
    ORKImplicitAssociationCorrectItemLeft,
    ORKImplicitAssociationCorrectItemRight,
    ORKImplicitAssociationCorrectItem1Left,
    ORKImplicitAssociationCorrectItem1Right,
    ORKImplicitAssociationCorrectItem2Left,
    ORKImplicitAssociationCorrectItem2Right
};
#define ORKImplicitAssociationCorrectValue(ORKImplicitAssociationCorrect) [@[@"ItemLeft", @"ItemRight", @"Item1Left", @"Item1Right", @"Item2Left", @"Item2Right"] objectAtIndex:ORKImplicitAssociationCorrect]

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
