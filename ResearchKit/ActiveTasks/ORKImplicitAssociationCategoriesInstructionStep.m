//
//  ORKImplicitAssociationCategoriesInstructionStep.m
//  ResearchKit
//
//  Created by Tobias Jungnickel on 26.02.17.
//  Copyright © 2017 researchkit.org. All rights reserved.
//

#import "ORKImplicitAssociationCategoriesInstructionStep.h"
#import "ORKFormItemCell.h"
#import "ORKFormStepViewController.h"

#import "ORKHelpers_Internal.h"
#import "ORKImplicitAssociationHelper.h"


ORKDefineStringKey(ORKBasicCellReuseIdentifier2);

@implementation ORKImplicitAssociationCategoriesInstructionStep

- (NSInteger)numberOfSections {
    return 4;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nullable NSString *)titleForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView {
    switch (section) {
        case 0:
            return _attributeACategory;
            break;
        case 1:
            return _attributeBCategory;
            break;
        case 2:
            return _conceptACategory;
            break;
        case 3:
            return _conceptBCategory;
            break;
        default:
            break;
    }
    return nil;
}

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    cell.textLabel.numberOfLines = 0;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text =  [_attributeAItems componentsJoinedByString:@", "];
            cell.textLabel.textColor = kAttributeUIColor;
            break;
        case 1:
            cell.textLabel.text =  [_attributeBItems componentsJoinedByString:@", "];
            cell.textLabel.textColor = kAttributeUIColor;
            break;
        case 2:
            if ([[_conceptAItems objectAtIndex:0] isKindOfClass:NSString.class]) {
                cell.textLabel.text =  [_conceptAItems componentsJoinedByString:@", "];
                cell.textLabel.textColor = kConceptUIColor;
            } else {
                [self cell:cell forCategory:_conceptAItems];
            }
            break;
        case 3:
            if ([[_conceptBItems objectAtIndex:0] isKindOfClass:NSString.class]) {
                cell.textLabel.text =  [_conceptBItems componentsJoinedByString:@", "];
                cell.textLabel.textColor = kConceptUIColor;
            } else {
                [self cell:cell forCategory:_conceptBItems];
            }
            break;
        default:
            break;
    }
}

- (void)cell:(UITableViewCell *)cell forCategory:(NSArray *)category  {
    UIStackView *stackViewVertical = [[UIStackView alloc] init];
    stackViewVertical.backgroundColor = [UIColor magentaColor];
    stackViewVertical.axis = UILayoutConstraintAxisVertical;
    stackViewVertical.distribution = UIStackViewDistributionEqualSpacing;
    stackViewVertical.alignment = UIStackViewAlignmentLeading;
    stackViewVertical.spacing = 10;
    stackViewVertical.translatesAutoresizingMaskIntoConstraints = false;
    [cell addSubview:stackViewVertical];
    [stackViewVertical.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor constant:16].active = true;
    [stackViewVertical.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-16].active = true;
    [stackViewVertical.topAnchor constraintEqualToAnchor:cell.topAnchor constant:8].active = true;
    [stackViewVertical.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor constant:-8].active = true;
    
    for (int column = 0; column < 2; column++) {
        UIStackView *stackViewHorizontalFirstLine = [[UIStackView alloc] init];
        stackViewHorizontalFirstLine.axis = UILayoutConstraintAxisHorizontal;
        stackViewHorizontalFirstLine.distribution = UIStackViewDistributionEqualSpacing;
        stackViewHorizontalFirstLine.alignment = UIStackViewAlignmentCenter;
        stackViewHorizontalFirstLine.spacing = 0;
        for (int i = 0; i < 5; ++i) {
            UIImageView *view1 = [[UIImageView alloc] initWithImage:(UIImage *)[category objectAtIndex:column+i]];
            [view1.heightAnchor constraintEqualToConstant:75].active = true;
            [view1.widthAnchor constraintEqualToConstant:75].active = true;
            [stackViewHorizontalFirstLine addArrangedSubview:view1];
        }
        [stackViewVertical addArrangedSubview:stackViewHorizontalFirstLine];
    }
}

@end
