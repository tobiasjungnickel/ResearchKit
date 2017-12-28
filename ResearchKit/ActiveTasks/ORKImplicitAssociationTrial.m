//
//  ORKImplicitAssociationTrial.m
//  ResearchKit
//
//  Created by Tobias Jungnickel on 04.02.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import "ORKImplicitAssociationTrial.h"

@implementation ORKImplicitAssociationTrial

- (ORKTappingButtonIdentifier)buttonIdentifier {
    switch (_correct) {
        case ORKImplicitAssociationCorrectItemLeft:
        case ORKImplicitAssociationCorrectItem1Left:
        case ORKImplicitAssociationCorrectItem2Left:
            return ORKTappingButtonIdentifierLeft;
        case ORKImplicitAssociationCorrectItemRight:
        case ORKImplicitAssociationCorrectItem1Right:
        case ORKImplicitAssociationCorrectItem2Right:
            return ORKTappingButtonIdentifierRight;
    }
    return ORKTappingButtonIdentifierNone;
}

@end
