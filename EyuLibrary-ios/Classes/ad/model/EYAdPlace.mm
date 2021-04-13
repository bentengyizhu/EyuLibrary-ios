//
//  AdPlace.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import "EYAdPlace.h"

@implementation EYAdPlace

-(instancetype) initWithId : (NSString*) placeId groups:(NSArray*) groups
{
    self = [super init];
    if(self)
    {
        self.placeId = placeId;
        self.groups = groups;
    }
    return self;
}
@end
