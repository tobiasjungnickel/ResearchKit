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

@interface ORKImplicitAssociationTrial : NSObject

@property (nonatomic, strong) NSString *term;

@property (nonatomic, strong) NSString *leftItem1;

@property (nonatomic, strong) NSString *rightItem1;

@property (nonatomic, strong) NSString *leftItem2;

@property (nonatomic, strong) NSString *rightItem2;

@property (nonatomic, assign) ORKTappingButtonIdentifier correct;

@end

NS_ASSUME_NONNULL_END
