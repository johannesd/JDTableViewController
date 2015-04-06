//
//  JDTableViewControllerModule.m
//
//  Created by Johannes Dörr on 27.01.15.
//
//

#import "JDTableViewControllerModule.h"
#import "JDTableViewControllerHelpers.h"


@implementation JDTableViewControllerModule
{
    NSMutableDictionary *currentSections;
}

- (id)initWithTableViewController:(JDTableViewController *)tableViewController sectionKey:(NSString *)sectionKey
{
    self = [super init];
    if (self) {
        _tableViewController = tableViewController;
        _sectionKey = sectionKey;
        currentSections = JDCollectSections(self, [JDTableViewControllerModule class]);
    }
    return self;
}

- (UITableView *)tableView
{
    return self.tableViewController.tableView;
}

- (NSInteger)firstSection
{
    return [[self.tableViewController valueForKey:[self.sectionKey stringByAppendingString:@"Section"]] intValue];
}

- (void)tableViewWillReload:(UITableView *)tableView
{
    
}

- (void)tableViewDidReload:(UITableView *)tableView
{
    JDUpdateSections(self, currentSections);
}

- (NSInteger)currentSectionForKey:(NSString *)key
{
    return [currentSections[key] intValue];
}

- (NSInteger)sectionForKey:(NSString *)key
{
    return [[self valueForKey:[key stringByAppendingString:@"Section"]] intValue];
}

- (NSInteger)numberOfSections
{
    return JDNumberOfSections(self, currentSections);
}

- (NSIndexSet *)addedSections
{
    return JDAddedSections(self, currentSections);
}

- (NSIndexSet *)removedSections
{
    return JDRemovedSections(self, currentSections);
}

- (NSInteger)sectionBelow:(NSInteger)section
{
    return JDSectionBelow(section, FALSE);
}

- (NSInteger)sectionBelow:(NSInteger)section hidden:(BOOL)hidden
{
    return JDSectionBelow(section, hidden);
}

- (NSInteger)sectionBelowIfVisible:(NSInteger)section
{
    return JDSectionBelowIfVisible(section, FALSE);
}

- (NSInteger)sectionBelowIfVisible:(NSInteger)section hidden:(BOOL)hidden
{
    return JDSectionBelowIfVisible(section, hidden);
}

- (NSInteger)sectionHidden:(NSInteger)section
{
    return JDSectionHidden(section);
}


#pragma mark - UIUpdates

- (void)activateUIUpdates
{
    
}

- (void)deactivateUIUpdates
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
