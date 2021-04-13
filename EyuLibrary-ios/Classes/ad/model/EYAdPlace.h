//
//  AdPlace.h
//  ballzcpp-mobile
//
//  Created by apple on 2018/5/2.
//

#import <Foundation/Foundation.h>

@interface EYAdPlace : NSObject{

}

@property(nonatomic,copy)NSString *placeId;
@property(nonatomic,strong)NSArray *groups;

-(instancetype) initWithId : (NSString*) placeId groups:(NSArray*) groups;
@end
