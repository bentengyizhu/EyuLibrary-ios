//
//  AdGroup.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#ifndef AdGroup_h
#define AdGroup_h
#import "EYAdKey.h"
#import "EYAdSuite.h"

@interface EYAdGroup : NSObject{

}

@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,copy)NSString *placeId;
@property(nonatomic,assign)bool isAutoLoad;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSMutableArray *suiteArray;

-(instancetype) initWithId : (NSString*) groupId;

-(void) addAdSuite:(EYAdSuite *)suite;
@end

#endif /* AdCache_h */
