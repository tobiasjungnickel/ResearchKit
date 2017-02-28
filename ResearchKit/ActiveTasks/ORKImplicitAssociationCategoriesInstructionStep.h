//
//  ORKImplicitAssociationCategoriesInstructionStep.h
//  ResearchKit
//
//  Created by Tobias Jungnickel on 26.02.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import <ResearchKit/ResearchKit.h>

@interface ORKImplicitAssociationCategoriesInstructionStep : ORKTableStep

@property (nonatomic, copy, nullable) NSString *attributeACategory;

@property (nonatomic, copy, nullable) NSArray <NSString *> *attributeAItems;

@property (nonatomic, copy, nullable) NSString *attributeBCategory;

@property (nonatomic, copy, nullable) NSArray <NSString *> *attributeBItems;

@property (nonatomic, copy, nullable) NSString *conceptACategory;

@property (nonatomic, copy, nullable) NSArray <NSString *> *conceptAItems;

@property (nonatomic, copy, nullable) NSString *conceptBCategory;

@property (nonatomic, copy, nullable) NSArray <NSString *> *conceptBItems;

@end
