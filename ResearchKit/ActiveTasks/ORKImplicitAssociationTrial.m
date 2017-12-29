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
        case ORKImplicitAssociationCorrectATTRleft:
        case ORKImplicitAssociationCorrectTARG1left:
        case ORKImplicitAssociationCorrectTARG2left:
            return ORKTappingButtonIdentifierLeft;
        case ORKImplicitAssociationCorrectATTRright:
        case ORKImplicitAssociationCorrectTARG1right:
        case ORKImplicitAssociationCorrectTARG2right:
            return ORKTappingButtonIdentifierRight;
    }
    return ORKTappingButtonIdentifierNone;
}

@end
