//
//  JDTableViewControllerModule.h
//
//  Created by Johannes Dörr on 27.01.15.
//
//

#import <Foundation/Foundation.h>
#import "JDTableViewController.h"

@interface JDTableViewControllerModule : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak, readonly) JDTableViewController *tableViewController;
@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) NSString *sectionKey;
@property (nonatomic, assign, readonly) NSInteger firstSection;

- (id)initWithTableViewController:(JDTableViewController *)tableViewController sectionKey:(NSString *)sectionKey;
- (void)activateUIUpdates;
- (void)deactivateUIUpdates;

- (NSInteger)currentSectionForKey:(NSString *)key;
- (NSInteger)sectionForKey:(NSString *)key;
- (NSInteger)numberOfSections;
- (NSIndexSet *)addedSections;
- (NSIndexSet *)removedSections;
- (NSInteger)sectionBelow:(NSInteger)section;
- (NSInteger)sectionBelow:(NSInteger)section hidden:(BOOL)hidden;
- (NSInteger)sectionBelowIfVisible:(NSInteger)section;
- (NSInteger)sectionBelowIfVisible:(NSInteger)section hidden:(BOOL)hidden;
- (NSInteger)sectionHidden:(NSInteger)section;

@end


@interface JDTableViewControllerModule ()

- (void)tableViewWillReload:(UITableView *)tableView;
- (void)tableViewDidReload:(UITableView *)tableView;

@end