//
//  SurveyViewController.m
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import "SurveyViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AnimationHelper.h"
#import "OfficeAnnotation.h"

@implementation SurveyViewController

#pragma mark
#pragma mark  Initialization override methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        syncManager = [[PromexicoSynchronizationManager alloc] initWithDelegate:self];
        ds = [[OfficesDataSource alloc] init];
        offices = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark
#pragma mark  UIViewController override methods

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self setupLabels];
    [self initializeForm];
}

#pragma mark
#pragma mark  User Interaction methods

-(IBAction)returnToLogin:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)selectOffice:(id)sender
{
    if(![self connected])
    {
        [self showPickerView];
    }
    else
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"HUD_TITLE_LOADING", nil);
        [hud show:YES];
        [syncManager loadOffices];
    }
}

-(IBAction)selectImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

-(IBAction)hidePickerView:(id)sender
{
    [self changeSelectedOffice:[offices objectAtIndex:[pickerView selectedRowInComponent:0]]];
    [AnimationHelper transitionView:officePickerFormView toRect:CGRectMake(officePickerFormView.frame.origin.x, officePickerFormView.frame.origin.y+1000, officePickerFormView.frame.size.width, officePickerFormView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.4 andWaitTime:0.0];
    [AnimationHelper fadeOut:officePickerOverlayView withDuration:.4 andWait:.2];
    [AnimationHelper fadeOut:officePickerView withDuration:0 andWait:.6];
}

-(IBAction)hideMapView:(id)sender
{
    [AnimationHelper transitionView:mapContainerView toRect:CGRectMake(mapContainerView.frame.origin.x+1000, mapContainerView.frame.origin.y, mapContainerView.frame.size.width, mapContainerView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.4 andWaitTime:0.0];
    [AnimationHelper fadeOut:mapOverlayView withDuration:.4 andWait:.2];
    [AnimationHelper fadeOut:mapComponent withDuration:.4 andWait:.2];
    [AnimationHelper fadeOut:mapView withDuration:0 andWait:.6];
}

-(IBAction)saveSurvey:(id)sender
{
    if(currentOffice == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:NSLocalizedString(@"ALERT_MESSAGE_NO_OFFICE_SELECTED", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else if([personTextfield.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:NSLocalizedString(@"ALERT_MESSAGE_NO_PERSON", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else if(imageView.image == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:NSLocalizedString(@"ALERT_MESSAGE_NO_IMAGE", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self saveSurveyOnDB];
    }
}

-(IBAction)dismissTextfields:(id)sender
{
    [personTextfield resignFirstResponder];
}

#pragma mark
#pragma mark Private methods

-(void)setupView
{
    officePickerView.alpha = 0.0;
    officePickerOverlayView.alpha = 0.0;
    officePickerFormView.alpha = 0.0;
    [self.view addSubview:officePickerView];
    
    mapView.alpha = 0.0;
    mapOverlayView.alpha = 0.0;
    mapContainerView.alpha = 0.0;
    mapComponent.alpha = 0.0;
    [self.view addSubview:mapView];
}

-(void)initializeForm
{
    personTextfield.text = @"";
    [treatmentSegmentedControl setSelectedSegmentIndex:0];
    [informationSegmentedControl setSelectedSegmentIndex:0];
    [placeCleanSegmentedControl setSelectedSegmentIndex:0];
    [self changeSelectedOffice:nil];
    imageView.image = nil;
}

-(void)setupLabels
{
    titleLabel.text = NSLocalizedString(@"LABEL_SURVEY_TITLE", nil);
    selectOfficeLabel.text = NSLocalizedString(@"LABEL_SURVEY_SELECT_OFFICE", nil);
    personLabel.text = NSLocalizedString(@"LABEL_SURVEY_PERSON", nil);
    treatmentLabel.text = NSLocalizedString(@"LABEL_SURVEY_TREATMENT", nil);
    informationLabel.text = NSLocalizedString(@"LABEL_SURVEY_INFORMATION", nil);
    placeCleanLabel.text = NSLocalizedString(@"LABEL_SURVEY_PLACE_CLEAN", nil);
    
    personTextfield.placeholder = NSLocalizedString(@"TEXTFIELD_PLACEHOLDER_PERSON", nil);
    
    [backButton setTitle:NSLocalizedString(@"BUTTON_TITLE_RETURN_TO_LOGIN", nil) forState:UIControlStateNormal];
    [saveButton setTitle:NSLocalizedString(@"BUTTON_TITLE_SAVE", nil) forState:UIControlStateNormal];
    [selectPickerButton setTitle:NSLocalizedString(@"BUTTON_TITLE_SELECT_PICKER", nil) forState:UIControlStateNormal];
    [closeMapViewButton setTitle:NSLocalizedString(@"BUTTON_TITLE_CLOSE_MAP", nil) forState:UIControlStateNormal];
    
}

-(void)changeSelectedOffice:(NSDictionary *)officeData
{
    currentOffice = officeData;
    if(officeData == nil)
    {
        [officeButton setTitle:NSLocalizedString(@"BUTTON_TITLE_SELECT_OFFICE", nil) forState:UIControlStateNormal];
        [officeButton setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [officeButton setTitle:[currentOffice objectForKey:DB_FIELD_OFFICE_KEY] forState:UIControlStateNormal];
        [officeButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:106.0/255.0 blue:0.0/255.0 alpha:1.0]];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(void)showPickerView
{
    [self updateOffices];
    [pickerView reloadAllComponents];
    officePickerView.alpha = 1.0;
    [AnimationHelper fadeInTransparent:officePickerOverlayView withAlpha:.6 withDuration:.4 andWait:0.0];
    if(officePickerFormView.frame.origin.y < 1000)
    {
        officePickerFormView.frame = CGRectMake(officePickerFormView.frame.origin.x, officePickerFormView.frame.origin.y+1000, officePickerFormView.frame.size.width, officePickerFormView.frame.size.height);
    }
    [AnimationHelper transitionView:officePickerFormView toRect:CGRectMake(officePickerFormView.frame.origin.x, officePickerFormView.frame.origin.y-1000, officePickerFormView.frame.size.width, officePickerFormView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.6 andWaitTime:0.0];
}

-(void)showMapView
{
    [self updateOffices];
    [self getLocation];
    [self setupAnnotations];
    mapView.alpha = 1.0;
    [AnimationHelper fadeInTransparent:mapOverlayView withAlpha:.6 withDuration:.4 andWait:0.0];
    if(mapContainerView.frame.origin.x < 1000)
    {
        mapContainerView.frame = CGRectMake(mapContainerView.frame.origin.x+1000, mapContainerView.frame.origin.y, mapContainerView.frame.size.width, mapContainerView.frame.size.height);
    }
    [AnimationHelper transitionView:mapContainerView toRect:CGRectMake(mapContainerView.frame.origin.x-1000, mapContainerView.frame.origin.y, mapContainerView.frame.size.width, mapContainerView.frame.size.height) WithSpringWithDamping:.3 andVelocity:0.0 andTransitionTime:.6 andWaitTime:0.0];
    [AnimationHelper fadeIn:mapComponent withDuration:.4 andWait:.4];
}

-(void)updateOffices
{
    [offices removeAllObjects];
    [offices addObjectsFromArray:[ds getOffices]];
}

-(void)saveSurveyOnDB
{
    NSNumber *treatment = (treatmentSegmentedControl.selectedSegmentIndex == 0) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    NSNumber *info = (informationSegmentedControl.selectedSegmentIndex == 0) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    NSNumber *placeClean = (placeCleanSegmentedControl.selectedSegmentIndex == 0) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];
    [ds insertSurveyForOffice:[currentOffice objectForKey:DB_FIELD_OFFICE_KEY] andPerson:personTextfield.text andTreatment:treatment andInformation:info andPlaceClean:placeClean andImageData:UIImageJPEGRepresentation(imageView.image, 0.5)];
    [syncManager backupDatabase];
    [self initializeForm];
}

#pragma mark
#pragma mark Location methods

-(void)getLocation{
    locationManager = [[CLLocationManager alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

-(void)updateUserLocation
{
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [mapComponent setShowsUserLocation:YES];
    [mapComponent setRegion:region animated:NO];
}

-(void)setupAnnotations
{
    for (id<MKAnnotation> annotation in mapComponent.annotations) {
        [mapComponent removeAnnotation:annotation];
    }
    
    for (NSDictionary *dicc in offices) {
        NSNumber *latitude = [dicc objectForKey:DB_FIELD_OFFICE_LATITUDE];
        NSNumber *longitude = [dicc objectForKey:DB_FIELD_OFFICE_LONGITUDE];
        CLLocationCoordinate2D officeCoordinate;
        officeCoordinate.latitude = [latitude floatValue];
        officeCoordinate.longitude = [longitude floatValue];
        OfficeAnnotation *annotation = [[OfficeAnnotation alloc] initWithOfficeData:dicc andCoordinate:officeCoordinate] ;
        [mapComponent addAnnotation:annotation];
    }
}


#pragma mark
#pragma mark  UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark
#pragma mark  UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return offices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[offices objectAtIndex:row] objectForKey:DB_FIELD_OFFICE_KEY];
}


#pragma mark
#pragma mark  UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.4)];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark  PromexicoSynchronizationDelegate methods

-(void)finishedLoadingOffices
{
    [hud hide:YES];
    [self showMapView];
}

-(void)failedLoadingOfficesWithError:(NSError *)error
{
    [hud hide:YES];
    if(error.code == -1003)
    {
        [self showPickerView];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", nil) message:error.localizedDescription delegate:self cancelButtonTitle:NSLocalizedString(@"ALERT_BUTTON_OK", nil) otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"PARA UNA CORRECTA VISUALIZACIÓN DE ESTA SECCIÓN FAVOR DE HABILITAR LA LOCALIZACIÓN PARA ESTA APLICACIÓN (AJUSTES->PRIVACIDAD->UBICACIÓN)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self updateUserLocation];
    }
}

#pragma mark -
#pragma mark MKMapView delegate methods

-(MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString* AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = NO;
    return customPinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if([view.annotation isKindOfClass:[OfficeAnnotation class]])
    {
        OfficeAnnotation * annotation = (OfficeAnnotation *) view.annotation;
        int pos = [offices indexOfObject:annotation.officeData];
        [self changeSelectedOffice:[offices objectAtIndex:pos]];
        [self hideMapView:nil];
    }
}

@end
