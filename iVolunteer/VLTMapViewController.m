//
//  VLTMapViewController.m
//  iVolunteer
//
//  Created by Marcus Vinicius Kuquert on 3/6/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "VLTMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "LocalAnnotation.h"
#import "VLTDetailViewController.h"

@interface VLTMapViewController ()
@property NSString *titleAuxiliar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation VLTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    NSLog(@"\n\nCOMECEI");
    
    //    PFObject *local = [PFObject objectWithClassName:@"Local"];
    //    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:-30.058897 longitude:-51.191650];
    //    NSString *name = @"Abrigo de Médio Porte 36 - NAR Zona Oeste";
    //    local[@"location"] = point;
    //    local[@"name"] = name;
    //    [local saveInBackground];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        
        NSLog(@"\n\nSOU O ERRO:%@", error);
        PFQuery *query = [PFQuery queryWithClassName:@"Local"];
        query = [query whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:100.0];
        
        CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoord, 6000, 6000);
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *local in objects) {
                NSLog(@"\n\nNUMERO IGUAL A \n %li", objects.count);
               
                PFGeoPoint *geoPoint= local[@"location"];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
                
                LocalAnnotation *localAnnotation = [[LocalAnnotation alloc]initWithTitle:local[@"name"] Location:coord];

//                MKAnnotationView *localPoint= [[MKAnnotationView alloc]initWithAnnotation:localAnnotation reuseIdentifier:nil];
   
                
                [self.mapView addAnnotation:localAnnotation];
            }
        }];
        
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
         
- (MKAnnotationView *)mapView:(MKMapView *)mapView
                              viewForAnnotation:(id <MKAnnotation>)annotation
        {
            // If the annotation is the user location, just return nil.
            if ([annotation isKindOfClass:[MKUserLocation class]])
                return nil;
            
            // Handle any custom annotations.
            if ([annotation isKindOfClass:[LocalAnnotation class]])
            {
                // Try to dequeue an existing pin view first.
                MKAnnotationView*    pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
                
                if (!pinView)
                {
                    // If an existing pin view was not available, create one.
                    pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
                    
                    UIImage *pinImage =[UIImage imageNamed:@"customPin.png"];
                    pinView.image = pinImage;
                    pinView.centerOffset = CGPointMake(0, -(pinImage.size.height)/2);
                    pinView.canShowCallout = YES;
                    
                    // If appropriate, customize the callout by adding accessory views (code not shown).
                    
                    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
                    pinView.rightCalloutAccessoryView = rightButton;
                    
                    UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customPin.png"]];
                    
                    pinView.leftCalloutAccessoryView = myCustomImage;
                }
                else
                    pinView.annotation = annotation;
                
                return pinView;
            }
            
            return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    _titleAuxiliar = view.annotation.title;
    
    [self performSegueWithIdentifier:@"gotoDetail" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoDetail"]){
        VLTDetailViewController *vc = (VLTDetailViewController *)segue.destinationViewController;
        vc.annotationTitle = _titleAuxiliar;
    }
}
         
@end