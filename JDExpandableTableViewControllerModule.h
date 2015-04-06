//
//  JDExpandableTableViewControllerModule.h
//
//  Created by Johannes Dörr on 17.02.15.
//
//

#import "JDTableViewControllerModule.h"
@class JDExpandableTableViewControllerModule;


@protocol JDExpandableTableViewControllerModuleDelegate <NSObject>

- (NSSet *)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule alwaysVisibleRowsInSection:(NSInteger)section;
- (NSInteger)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UITableViewCell *)toggleButtonCellForExpandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule forIndexPath:(NSIndexPath *)tableViewIndexPath;
- (void)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)expandableTableViewControllerModule:(JDExpandableTableViewControllerModule *)expandableTableViewControllerModule commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface JDExpandableTableViewControllerModule : JDTableViewControllerModule

- (NSIndexPath *)convertIndexPathToTableView:(NSIndexPath *)indexPath;

@property (nonatomic, weak) id<JDExpandableTableViewControllerModuleDelegate> delegate;
@property (nonatomic, assign) BOOL showAllRows;

@end
