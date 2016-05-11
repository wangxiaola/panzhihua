




#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZKAppDelegate.h"
#import "Item.h"

@protocol MapViewDelegate;
@interface MapView : UIView

@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,assign)double span;//default 40000
@property (nonatomic,strong)NSMutableArray *anntionArray;

@property (nonatomic,strong)NSMutableArray *searchArray;

/**
 *  是否显示annotationView
 */
@property (nonatomic,assign) BOOL isAnnotationView;


- (id)initWithDelegate:(id<MapViewDelegate>)delegate;
- (void)beginLoad;


@end


@protocol MapViewDelegate <NSObject>

@optional;

- (NSInteger)numbersWithCalloutViewForMapView;
- (UIView *)mapViewCalloutContentViewWithIndex:(Item*)plist;
- (void )mapViewViewWithIndex:(Item*)plist;
- (UIImage *)baseMKAnnotationViewImageWithIndex:(NSString*)p;

-(Item*)listDataIndex:(NSInteger)index;

@optional
- (void)calloutViewDidSelectedWithIndex:(Item*)list;

@end