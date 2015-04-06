//
//  JDTableViewController.h
//
//  Created by Johannes Dörr on 15.10.14.
//  Copyright (c) 2014 Johannes Dörr. All rights reserved.
//

#import <JDUIUpdates/UITableViewController+JDUIUpdates.h>
@class JDTableViewControllerModule;

@interface JDTableViewController : UITableViewController <JDUIUpdates>

- (NSInteger)currentSectionForKey:(NSString *)key;
- (NSInteger)sectionForKey:(NSString *)key;
- (NSInteger)numberOfSections;
- (NSIndexSet *)addedSections;
- (NSIndexSet *)removedSections;
- (NSInteger)sectionBelow:(NSInteger)section;
- (NSInteger)sectionBelow:(NSInteger)section hidden:(BOOL)hidden;
- (NSInteger)sectionBelowIfVisible:(NSInteger)section;
- (NSInteger)sectionBelowIfVisible:(NSInteger)section hidden:(BOOL)hidden;
- (NSInteger)sectionBelowModule:(JDTableViewControllerModule *)module;
- (NSInteger)sectionBelowModule:(JDTableViewControllerModule *)module hidden:(BOOL)hidden;
- (NSInteger)sectionHidden:(NSInteger)section;

- (void)registerModule:(JDTableViewControllerModule *)module;

- (void)animateInsertsAndRemovals;
- (void)animateHorizontallyOrderedSections:(NSArray *)sectionKeys;

- (void)jd_TableViewController_tableViewWillReload:(UITableView *)tableView;
- (void)jd_TableViewController_tableViewDidReload:(UITableView *)tableView;

@end
