//
//  ORKImplicitAssociationResult.m
//  ResearchKit
//
//  Created by Tobias Jungnickel on 19.12.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import "ORKImplicitAssociationResult.h"

#import "ORKResult_Private.h"
#import "ORKHelpers_Internal.h"

@implementation ORKImplicitAssociationResult

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    ORK_ENCODE_DOUBLE(aCoder, latency);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        ORK_DECODE_DOUBLE(aDecoder, latency);
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isEqual:(id)object {
    BOOL isParentSame = [super isEqual:object];
    
    __typeof(self) castObject = object;
    return (isParentSame &&
            (self.latency == castObject.latency)) ;
}

- (NSUInteger)hash {
    return super.hash ^ [NSNumber numberWithDouble:self.latency].hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ORKImplicitAssociationResult *result = [super copyWithZone:zone];
    result.latency = self.latency;
    return result;
}

- (NSString *)descriptionWithNumberOfPaddingSpaces:(NSUInteger)numberOfPaddingSpaces {
    return [NSString stringWithFormat:@"%@; latency: %f; correct: %@; error: %lu%@", [self descriptionPrefixWithNumberOfPaddingSpaces:numberOfPaddingSpaces], self.latency, self.correct, (unsigned long)self.error, self.descriptionSuffix];
}

@end
