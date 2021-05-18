//
//  EYAdSuite.m
//  EyuLibrary-ios
//
//  Created by eric on 2021/4/1.
//

#import "EYAdSuite.h"

@implementation EYAdSuite
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.priority = 1;
        self.keys = [NSMutableArray new];
    }
    return self;
}
@end
