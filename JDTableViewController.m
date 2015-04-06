//
//  JDTableViewController.m
//
//  Created by Johannes Dörr on 15.10.14.
//  Copyright (c) 2014 Johannes Dörr. All rights reserved.
//

#import "JDTableViewController.h"
#import <JDCategories/NSIndexSet+JDCategories.h>
#import <objc/runtime.h>
#import "JDTableViewControllerHelpers.h"
#import "JDTableViewControllerModule.h"


NSInteger JDSectionBelow(NSInteger section, BOOL hidden)
{
    if (section >= 0) {
        if (hidden) {
            return -section - 2;
        }
        else {
            return section + 1;
        }
    }
    else {
        if (hidden) {
            return section;
        }
        else {
            return -section - 1;
        }
    }
}

NSInteger JDSectionBelowIfVisible(NSInteger section, BOOL hidden)
{
    if (section >= 0) {
        if (hidden) {
            return -section - 2;
        }
        else {
            return section + 1;
        }
    }
    else {
        return section;
    }
}


NSInteger JDSectionHidden(NSInteger section)
{
    if (section >= 0) {
        return -section - 1;
    }
    return section;
}

NSMutableDictionary* JDCollectSections(NSObject *self, Class baseClass)
{
    NSString *suffix = @"Section";
    NSMutableDictionary *currentSections = [NSMutableDictionary dictionary];
    Class myClass = [self class];
    while (myClass != [baseClass superclass]) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList(myClass, &outCount);
        for(int i=0; i<outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if (propName) {
                NSString *propertyName = [NSString stringWithCString:propName
                                                            encoding:[NSString defaultCStringEncoding]];
                if ([propertyName hasSuffix:suffix]) {
                    NSString *key = [propertyName substringToIndex:propertyName.length - suffix.length];
                    currentSections[key] = @(-1);
                }
            }
        }
        myClass = [myClass superclass];
    }
    return currentSections;
}

void JDUpdateSections(NSObject *self, NSMutableDictionary *currentSections)
{
    for (NSString *key in currentSections.allKeys) {
        currentSections[key] = [self valueForKey:[key stringByAppendingString:@"Section"]];
    }
}

NSInteger JDNumberOfSections(NSObject *self, NSMutableDictionary *currentSections)
{
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    for (NSString *key in currentSections.allKeys) {
        NSInteger section = [[self valueForKey:[key stringByAppendingString:@"Section"]] intValue];
        if (section >= 0) {
            [sections addIndex:section];
        }
    }
    return sections.count;
}

NSIndexSet* JDAddedSections(NSObject *self, NSMutableDictionary *currentSections)
{
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    for (NSString *key in currentSections.allKeys) {
        NSInteger section = [[self valueForKey:[key stringByAppendingString:@"Section"]] intValue];
        NSInteger currentSection = [currentSections[key] intValue];
        if (section >= 0 && currentSection < 0) {
            [sections addIndex:section];
        }
    }
    return [sections copy];
}

NSIndexSet* JDRemovedSections(NSObject *self, NSMutableDictionary *currentSections)
{
    NSMutableIndexSet *sections = [NSMutableIndexSet indexSet];
    for (NSString *key in currentSections.allKeys) {
        NSInteger section = [[self valueForKey:[key stringByAppendingString:@"Section"]] intValue];
        NSInteger currentSection = [currentSections[key] intValue];
        if (section < 0 && currentSection >= 0) {
            [sections addIndex:currentSection];
        }
    }
    return [sections copy];
}


@interface JDTableView : UITableView

@end


@implementation JDTableViewController
{
    NSMutableDictionary *currentSections;
    NSMutableArray *modules;
    NSMutableDictionary *moduleForSections;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        currentSections = JDCollectSections(self, [JDTableViewController class]);
        modules = [NSMutableArray array];
        moduleForSections = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView
{
    UITableView *tableView = [[JDTableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
}

- (void)jd_TableViewController_tableViewWillReload:(UITableView *)tableView
{
    for (JDTableViewControllerModule *module in modules) {
        [module tableViewWillReload:tableView];
    }
}

- (void)jd_TableViewController_tableViewDidReload:(UITableView *)tableView
{
    JDUpdateSections(self, currentSections);
    [moduleForSections removeAllObjects];
    for (JDTableViewControllerModule *module in modules) {
        [module tableViewDidReload:tableView];
    }
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
    NSInteger number = JDNumberOfSections(self, currentSections);
    for (JDTableViewControllerModule *module in modules) {
        if (module.firstSection < 0) {
            continue;
        }
        number += [module numberOfSections] - 1;
    }
    return number;
}

- (NSIndexSet *)addedSections
{
    NSIndexSet *sections = JDAddedSections(self, currentSections);
    for (JDTableViewControllerModule *module in modules) {
        sections = [sections indexSetByAddingIndicesFromSet:[module addedSections]];
    }
    return sections;
}

- (NSIndexSet *)removedSections
{
    NSIndexSet *sections = JDRemovedSections(self, currentSections);
    for (JDTableViewControllerModule *module in modules) {
        sections = [sections indexSetByAddingIndicesFromSet:[module removedSections]];
    }
    return sections;
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

- (NSInteger)sectionBelowModule:(JDTableViewControllerModule *)module
{
    return [self sectionBelowModule:module hidden:FALSE];
}

- (NSInteger)sectionBelowModule:(JDTableViewControllerModule *)module hidden:(BOOL)hidden
{
    if (module.firstSection >= 0) {
        return [self sectionBelow:module.firstSection + module.numberOfSections - 1 hidden:hidden];
    }
    else {
        return module.firstSection;
    }
}

- (NSInteger)sectionHidden:(NSInteger)section
{
    return JDSectionHidden(section);
}

- (void)registerModule:(JDTableViewControllerModule *)module
{
    [modules addObject:module];
}

- (void)animateInsertsAndRemovals
{
    NSIndexSet *addedSections = [self addedSections];
    NSIndexSet *removedSections = [self removedSections];
    [self.tableView beginUpdates];
    [self.tableView insertSections:addedSections withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteSections:removedSections withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)animateHorizontallyOrderedSections:(NSArray *)sectionKeys
{
    NSInteger currentIndex = -1;
    NSInteger index = -1;
    NSInteger section = -1;
    for (NSInteger i=0; i<sectionKeys.count; i++) {
        if ([self currentSectionForKey:sectionKeys[i]] > -1) {
            currentIndex = i;
        }
        NSInteger s = [self sectionForKey:sectionKeys[i]];
        if (s > -1) {
            index = i;
            section = s;
        }
    }
    if (currentIndex == index) return;
    UITableViewRowAnimation insertAnimation = currentIndex > index ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    UITableViewRowAnimation deleteAnimation = currentIndex > index ? UITableViewRowAnimationRight : UITableViewRowAnimationLeft;
    NSMutableIndexSet *addedSections = [[self addedSections] mutableCopy];
    NSMutableIndexSet *removedSections = [[self removedSections] mutableCopy];
    [addedSections removeIndex:section];
    [removedSections removeIndex:section];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:deleteAnimation];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:insertAnimation];
    [self.tableView insertSections:addedSections withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteSections:removedSections withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (JDTableViewControllerModule *)moduleAtSection:(NSInteger)section
{
    JDTableViewControllerModule *module = moduleForSections[@(section)];
    if (module == nil) {
        for (JDTableViewControllerModule *module in modules) {
            NSInteger firstSection = module.firstSection;
            if (section >= firstSection && section < firstSection + module.numberOfSections) {
                moduleForSections[@(section)] = module;
                return module;
            }
        }
    }
    return module;
}


#pragma mark - JDUIUpdates

- (void)activateUIUpdates
{
    for (JDTableViewControllerModule *module in modules) {
        [module activateUIUpdates];
    }
}

- (void)deactivateUIUpdates
{
    for (JDTableViewControllerModule *module in modules) {
        [module deactivateUIUpdates];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JDTableViewControllerModule *module = [self moduleAtSection:section];
    if (module != nil) {
        return [module tableView:tableView titleForHeaderInSection:section];
    }
    return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JDTableViewControllerModule *module = [self moduleAtSection:section];
    if (module != nil) {
        return [module tableView:tableView numberOfRowsInSection:section];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDTableViewControllerModule *module = [self moduleAtSection:indexPath.section];
    if (module != nil) {
        return [module tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    JDTableViewControllerModule *module = [self moduleAtSection:section];
    if (module != nil) {
        return [module tableView:tableView titleForFooterInSection:section];
    }
    return [super tableView:tableView titleForFooterInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDTableViewControllerModule *module = [self moduleAtSection:indexPath.section];
    if (module != nil) {
        return [module tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDTableViewControllerModule *module = [self moduleAtSection:indexPath.section];
    if (module != nil) {
        [module tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDTableViewControllerModule *module = [self moduleAtSection:indexPath.section];
    if (module != nil) {
        return [module tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return FALSE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDTableViewControllerModule *module = [self moduleAtSection:indexPath.section];
    if (module != nil) {
        return [module tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
    return [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}

@end


@implementation JDTableView

- (void)reloadData
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super reloadData];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super insertSections:sections withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super deleteSections:sections withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super reloadSections:sections withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewWillReload:self];
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [((JDTableViewController *)self.delegate) jd_TableViewController_tableViewDidReload:self];
}

@end
