





#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Item.h"

@interface BasicMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,assign) int tag;
@property (nonatomic,retain) Item *list;

@property (nonatomic,copy) NSString *type;


- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude data:(Item*)p;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (CLLocationCoordinate2D)coordinate;
@end
