//
//  AdKey.m
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import "EYAdKey.h"

@implementation EYAdKey
@synthesize keyId = _keyId;
@synthesize network = _network;
@synthesize key = _key;
@synthesize placementid = _placementid;

-(instancetype) initWithId : (NSString*) keyId network:(NSString*) network key:(NSString*) key placementid:(NSString *)placementid
{
    self = [super init];
    if(self)
    {
        if(keyId!=NULL){
            self.keyId = keyId;
        }
        if(network!=NULL){
            self.network = network;
        }
        if(key!=NULL){
            self.key = key;
        }
        if (placementid!=NULL) {
            self.placementid = placementid;
        }
    }
    return self;
}
@end
