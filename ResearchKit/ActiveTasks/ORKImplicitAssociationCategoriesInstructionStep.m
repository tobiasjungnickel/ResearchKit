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


ORKDefineStringKey(ORKBasicCellReuseIdentifier2);

@implementation ORKImplicitAssociationCategoriesInstructionStep

- (NSInteger)numberOfSections {
    return 4;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
            break;
        case 1:
            cell.textLabel.text =  [_attributeBItems componentsJoinedByString:@", "];
            break;
        case 2:
            cell.textLabel.text =  [_conceptAItems componentsJoinedByString:@", "];
            break;
        case 3:
            cell.textLabel.text =  [_conceptBItems componentsJoinedByString:@", "];
            break;
        default:
            break;
    }
}

@end
