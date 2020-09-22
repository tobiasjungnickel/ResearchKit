//
//  ORKImplicitAssociationResult.h
//  ResearchKit
//
//  Created by Tobias Jungnickel on 19.12.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import <ResearchKit/ORKResult.h>


NS_ASSUME_NONNULL_BEGIN

ORK_CLASS_AVAILABLE
@interface ORKImplicitAssociationResult: ORKResult

@property (nonatomic, assign) NSTimeInterval latency;
@property (nonatomic, copy, nullable) NSString *correct; //trialcode
@property (nonatomic, assign) NSInteger error; //correct
@property (nonatomic, copy, nullable) NSString *term;

@end

NS_ASSUME_NONNULL_END
