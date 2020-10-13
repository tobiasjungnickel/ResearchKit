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
    ORK_ENCODE_OBJ(aCoder, correct);
    ORK_ENCODE_OBJ(aCoder, pairing);
    ORK_ENCODE_INTEGER(aCoder, error);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        ORK_DECODE_DOUBLE(aDecoder, latency);
        ORK_DECODE_OBJ_CLASS(aDecoder, correct, NSString);
        ORK_DECODE_OBJ_CLASS(aDecoder, pairing, NSString);
        ORK_DECODE_INTEGER(aDecoder, error);
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
            (self.latency == castObject.latency) &&
            (self.correct == castObject.correct) &&
            (self.error == castObject.error)) ;
}

- (NSUInteger)hash {
    return super.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ORKImplicitAssociationResult *result = [super copyWithZone:zone];
    result.latency = self.latency;
    result.correct = self.correct;
    result.pairing = self.pairing;
    result.error = self.error;
    return result;
}

- (NSString *)descriptionWithNumberOfPaddingSpaces:(NSUInteger)numberOfPaddingSpaces {
    return [NSString stringWithFormat:@"%@; latency: %f; correct: %@; pairing: %@; error: %lu%@", [self descriptionPrefixWithNumberOfPaddingSpaces:numberOfPaddingSpaces], self.latency, self.correct, self.pairing, (unsigned long)self.error, self.descriptionSuffix];
}

@end
