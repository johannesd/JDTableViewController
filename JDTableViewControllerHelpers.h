//
//  JDTableViewControllerHelpers.h
//
//  Created by Johannes Dörr on 27.01.15.
//
//

#ifndef Pods_Header_h
#define Pods_Header_h

NSMutableDictionary* JDCollectSections(NSObject *self, Class baseClass);
void JDUpdateSections(NSObject *self, NSMutableDictionary *currentSections);
NSInteger JDNumberOfSections(NSObject *self, NSMutableDictionary *currentSections);
NSIndexSet* JDAddedSections(NSObject *self, NSMutableDictionary *currentSections);
NSIndexSet* JDRemovedSections(NSObject *self, NSMutableDictionary *currentSections);
NSInteger JDSectionBelow(NSInteger section, BOOL hidden);
NSInteger JDSectionBelowIfVisible(NSInteger section, BOOL hidden);
NSInteger JDSectionHidden(NSInteger section);

#endif
