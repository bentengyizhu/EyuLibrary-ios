//
//  AdGroup.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>
#include "EYAdGroup.h"


@implementation EYAdGroup

@synthesize groupId = _groupId;
@synthesize suiteArray = _suiteArray;
@synthesize isAutoLoad = _isAutoLoad;
@synthesize type = _type;

-(instancetype) initWithId : (NSString*) groupId
{
    self = [self init];
    if(self)
    {
        self.groupId = groupId;
        self.suiteArray = [[NSMutableArray alloc] init];
        self.groupArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addAdSuite:(EYAdSuite *)suite
{
    if(suite){
        [self.suiteArray addObject:suite];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    EYAdGroup *group = [[[self class] allocWithZone:zone] init];
    group.groupId = self.groupId;
    group.isAutoLoad = self.isAutoLoad;
    group.type = self.type;
    group.suiteArray = self.suiteArray;
    group.groupArray = self.groupArray;
    return group;
}
@end
