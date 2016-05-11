#import "BasicMapAnnotation.h"



@implementation BasicMapAnnotation


- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude data:(Item*)p;
{
    if (self = [super init])
    {
        self.latitude = latitude;
        self.longitude = longitude;
        self.list =p;
    }
    return self;
    

}
- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self.latitude = newCoordinate.latitude;
	self.longitude = newCoordinate.longitude;
}


@end
