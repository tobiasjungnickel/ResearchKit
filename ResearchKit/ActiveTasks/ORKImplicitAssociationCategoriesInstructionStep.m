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
            return _attributeBCategory;
            break;
        case 1:
            return _attributeACategory;
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
            cell.textLabel.text =  [_attributeBItems componentsJoinedByString:@", "];
            cell.textLabel.textColor = kAttributeUIColor;
            break;
        case 1:
            cell.textLabel.text =  [_attributeAItems componentsJoinedByString:@", "];
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
    UIStackView *stackViewVertical = [UIStackView new];
    stackViewVertical.axis = UILayoutConstraintAxisVertical;
    stackViewVertical.distribution = UIStackViewDistributionEqualSpacing;
    stackViewVertical.alignment = UIStackViewAlignmentLeading;
    stackViewVertical.spacing = 0;
    stackViewVertical.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:stackViewVertical];
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[stackViewVertical]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{ @"stackViewVertical" : stackViewVertical}];
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[stackViewVertical]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{ @"stackViewVertical" : stackViewVertical}];
    [cell.contentView addConstraints:constraint_H];
    [cell.contentView addConstraints:constraint_V];
    
    for (int column = 0; column < 2; column++) {
        UIStackView *stackViewHorizontal = [UIStackView new];
        stackViewHorizontal.translatesAutoresizingMaskIntoConstraints = NO;
        stackViewHorizontal.axis = UILayoutConstraintAxisHorizontal;
        stackViewHorizontal.distribution = UIStackViewDistributionEqualSpacing;
        stackViewHorizontal.alignment = UIStackViewAlignmentTop;
        stackViewHorizontal.spacing = 0;
        for (int i = 0; i < 5; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:(UIImage *)[category objectAtIndex:column*5+i]];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView.heightAnchor constraintEqualToConstant:70].active = true;
            [imageView.widthAnchor constraintEqualToConstant:70].active = true;
            [stackViewHorizontal addArrangedSubview:imageView];
        }
        [stackViewVertical addArrangedSubview:stackViewHorizontal];
    }
}

@end
