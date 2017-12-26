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
                                     [NSArray arrayWithObjects:@"<red>",@"<font color='red'>",nil],
                                     [NSArray arrayWithObjects:@"</red>",@"</font>",nil],
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
