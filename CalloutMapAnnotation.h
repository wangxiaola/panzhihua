#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Item.h"

@interface CalloutMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,assign) int tag;


@property (nonatomic,retain)Item *callList;

@property (nonatomic,strong)NSString *annonType;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude data:(Item*)p;

- (CLLocationCoordinate2D)coordinate;
@end
