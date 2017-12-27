//
//  ORKImplicitAssociationHelper.m
//  ResearchKit
//
//  Created by Tobias Jungnickel on 26.12.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import "ORKImplicitAssociationHelper.h"

@implementation ORKImplicitAssociationHelper

+ (NSAttributedString *)textToHTML:(NSString *)taggedString {
    NSMutableArray *tagsToConvert = [NSMutableArray arrayWithObjects:
                                     //attention
                                     [NSArray arrayWithObjects:@"<attention>",[NSString stringWithFormat:@"<font color='%@'>", kAttentionHexColor],nil],
                                     [NSArray arrayWithObjects:@"</attention>",@"</font>",nil],
                                     //attribute
                                     [NSArray arrayWithObjects:@"<attribute>",[NSString stringWithFormat:@"<font color='%@'>", kAttributeHexColor],nil],
                                     [NSArray arrayWithObjects:@"</attribute>",@"</font>",nil],
                                     //concept
                                     [NSArray arrayWithObjects:@"<concept>",[NSString stringWithFormat:@"<font color='%@'>", kConceptHexColor],nil],
                                     [NSArray arrayWithObjects:@"</concept>",@"</font>",nil],
                                     //bold
                                     [NSArray arrayWithObjects:@"<bold>",[NSString stringWithFormat:@"<font color='%@'>", kBoldHexColor],nil],
                                     [NSArray arrayWithObjects:@"</bold>",@"</font>",nil],
                                     //underline
                                     [NSArray arrayWithObjects:@"<underline>",@"<u>",nil],
                                     [NSArray arrayWithObjects:@"</underline>",@"</u>",nil],
                                     //new line
                                     [NSArray arrayWithObjects:@"\n",@"<br/>",nil],
                                     nil];
    
    while ([tagsToConvert count] > 0) {
        taggedString = [taggedString stringByReplacingOccurrencesOfString:[[tagsToConvert objectAtIndex:0] objectAtIndex:0]
                                                                     withString:[[tagsToConvert objectAtIndex:0] objectAtIndex:1]];
        [tagsToConvert removeObjectAtIndex:0];
    }
    
    UILabel *label = [UILabel new];
    taggedString = [taggedString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>", label.font.fontName, label.font.pointSize]];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[taggedString dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
    return attributedString;
}
@end
