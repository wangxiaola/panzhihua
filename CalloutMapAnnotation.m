#import "CalloutMapAnnotation.h"


@implementation CalloutMapAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
                   tag:(int)tag
{
	if (self = [super init])
    {
		self.latitude = latitude;
		self.longitude = longitude;
        self.tag = tag;
	}
	return self;
}

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude data:(Item*)p;
{

    if (self = [super init])
    {
        self.latitude = latitude;
        self.longitude = longitude;
        self.callList  = p;
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

@end
