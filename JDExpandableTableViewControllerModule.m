//
//  JDExpandableTableViewControllerModule.m
//
//  Created by Johannes Dörr on 17.02.15.
//
//

#import "JDExpandableTableViewControllerModule.h"
#import <BlocksKit/BlocksKit.h>

@implementation JDExpandableTableViewControllerModule

- (NSInteger)firstSection
{
    NSInteger firstSection = [super firstSection];
    if (firstSection <= -1) {
        self.showAllRows = FALSE;
    }
    return firstSection;
}

- (NSIndexPath *)convertIndexPathFromTableView:(NSIndexPath *)indexPath
{
    if (self.showAllRows) {
        return indexPath;
    }
    else {
        NSSet *alwaysVisibleRows = [self.delegate expandableTableViewControllerModule:self alwaysVisibleRowsInSection:indexPath.section];
        NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSArray *sortedRows = [[alwaysVisibleRows allObjects] sortedArrayUsingDescriptors:@[lowestToHighest]];
        return [NSIndexPath indexPathForRow:[sortedRows[indexPath.row] intValue] inSection:indexPath.section];
    }
}

- (NSIndexPath *)convertIndexPathToTableView:(NSIndexPath *)indexPath
{
    if (self.showAllRows) {
        return indexPath;
    }
    else {
        NSSet *alwaysVisibleRows = [self.delegate expandableTableViewControllerModule:self alwaysVisibleRowsInSection:indexPath.section];
        NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        NSArray *sortedRows = [[alwaysVisibleRows allObjects] sortedArrayUsingDescriptors:@[lowestToHighest]];
        return [NSIndexPath indexPathForRow:[sortedRows indexOfObject:@(indexPath.row)] inSection:indexPath.section];
    }
}

- (void)setShowAllRows:(BOOL)showAllRows
{
    [self setShowAllRows:showAllRows animated:FALSE];
}

- (void)setShowAllRows:(BOOL)showAllRows animated:(BOOL)animated
{
    if (_showAllRows == showAllRows) return;
    _showAllRows = showAllRows;
    if ([self firstSection] < 0) return;
    // Improve performance, but only if mappings are expanded. Otherwise, this causes
    // a scrolling bug when precision of outgoing controller is changed
    if (showAllRows) {
        self.tableView.estimatedRowHeight = 44;
    }
    else {
        // Reset with a delay. Otherwise, animation would break
        [self bk_performBlock:^(id obj) {
            self.tableView.estimatedRowHeight = 0;
        } afterDelay:0.3];
    }
    _showAllRows = showAllRows;
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.firstSection] withRowAnimation:UITableViewRowAnimationNone];
//    return;
    
//        NSString *inLsbController = [self.dataObject valueForKeyPath:inControllerLSBKeyPath];
//        int16_t number = [inLsbController isEqualToString:@""] ? 128 : 16384;
//        if (number > 128) {
        [self.tableView reloadData];
//            return;
//        }
#warning TODO: This seems to be broken on iOS8, fix it
//        if (animated && number <= 128) {
//            NSMutableArray *arr = [NSMutableArray array];
//            for (int i=numberOfInitiallyVisibleAssignmentListEntries; i<number; i++) {
//                [arr addObject:[NSIndexPath indexPathForRow:i inSection:3]];
//            }
//            if (showAllAssignmentListEntries) {
//                [self.tableView beginUpdates];
//                [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:numberOfInitiallyVisibleAssignmentListEntries inSection:3]]
//                                      withRowAnimation:UITableViewRowAnimationFade];
//                [self.tableView endUpdates];
//            }
//            else {
//                [self.tableView beginUpdates];
//                [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationTop];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:number inSection:3]]
//                                      withRowAnimation:UITableViewRowAnimationFade];
//                [self.tableView endUpdates];
//            }
//        }
//        else {
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
//        }
}


#pragma mark - Table view data source

- (NSInteger)rowOfToggleButton
{
    NSInteger firstSection = self.firstSection;
    NSInteger numberOfRows = [self.delegate expandableTableViewControllerModule:self numberOfRowsInSection:firstSection];
    NSInteger numberOfAlwaysVisibleRows = [[self.delegate expandableTableViewControllerModule:self alwaysVisibleRowsInSection:firstSection] count];
    if (numberOfRows == numberOfAlwaysVisibleRows) {
        return -1;
    }
    else if (self.showAllRows) {
        return numberOfRows;
    }
    else {
        return numberOfAlwaysVisibleRows;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowOfToggleButton = [self rowOfToggleButton];
    if (rowOfToggleButton < 0) {
        NSInteger numberOfRows = [self.delegate expandableTableViewControllerModule:self numberOfRowsInSection:section];
        return numberOfRows;
    }
    return rowOfToggleButton + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self rowOfToggleButton]) {
        if ([self.delegate respondsToSelector:@selector(toggleButtonCellForExpandableTableViewControllerModule:forIndexPath:)]) {
            return [self.delegate toggleButtonCellForExpandableTableViewControllerModule:self forIndexPath:indexPath];
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = self.showAllRows ? @"Show less" : @"Show all";
        return cell;
    }
    else {
        return [self.delegate expandableTableViewControllerModule:self cellForRowAtIndexPath:[self convertIndexPathFromTableView:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self rowOfToggleButton]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        [self setShowAllRows:!self.showAllRows animated:TRUE];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(expandableTableViewControllerModule:didSelectRowAtIndexPath:)]) {
            return [self.delegate expandableTableViewControllerModule:self didSelectRowAtIndexPath:[self convertIndexPathFromTableView:indexPath]];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self rowOfToggleButton] && [self.delegate respondsToSelector:@selector(expandableTableViewControllerModule:canEditRowAtIndexPath:)]) {
        return [self.delegate expandableTableViewControllerModule:self canEditRowAtIndexPath:[self convertIndexPathFromTableView:indexPath]];
    }
    return FALSE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(expandableTableViewControllerModule:commitEditingStyle:forRowAtIndexPath:)]) {
        return [self.delegate expandableTableViewControllerModule:self commitEditingStyle:editingStyle forRowAtIndexPath:[self convertIndexPathFromTableView:indexPath]];
    }
}

@end
