//
//  ORKImplicitAssociationHelper.h
//  ResearchKit
//
//  Created by Tobias Jungnickel on 26.12.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

@import UIKit;

#define kAttributeUIColor [UIColor blueColor]
#define kAttributeHexColor @"#0000FF"

#define kConceptUIColor [UIColor colorWithRed:45.0/255.0 green:145.0/255.0 blue:0.0 alpha:1.0]
#define kConceptHexColor @"#2D9100"

#define kAttentionUIColor [UIColor redColor]
#define kAttentionHexColor @"#FF0000"

//default tint
#define kBoldUIColor [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define kBoldHexColor @"#007AFF"

@interface ORKImplicitAssociationHelper : NSObject

+ (NSAttributedString *)textToHTML:(NSString *)taggedString;
    
@end
