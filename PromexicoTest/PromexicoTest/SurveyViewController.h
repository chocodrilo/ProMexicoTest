//
//  SurveyViewController.h
//  PromexicoTest
//
//  Created by iOS developer on 4/27/15.
//  Copyright (c) 2015 Chocodrilo INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PromexicoSynchronizationManager.h"
#import <MapKit/MapKit.h>

@interface SurveyViewController : UIViewController <PromexicoSynchronizationDelegate,CLLocationManagerDelegate,UITextFieldDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *backButton;
    
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UILabel *selectOfficeLabel;
    IBOutlet UIButton *officeButton;
    
    IBOutlet UILabel *personLabel;
    IBOutlet UITextField *personTextfield;
    
    IBOutlet UILabel *treatmentLabel;
    IBOutlet UISegmentedControl *treatmentSegmentedControl;
    
    IBOutlet UILabel *informationLabel;
    IBOutlet UISegmentedControl *informationSegmentedControl;
    
    IBOutlet UILabel *placeCleanLabel;
    IBOutlet UISegmentedControl *placeCleanSegmentedControl;
    
    IBOutlet UILabel *imageLabel;
    IBOutlet UIImageView *imageView;
    
    IBOutlet UIButton *saveButton;
    
    IBOutlet UIView *officePickerView;
    IBOutlet UIView *officePickerOverlayView;
    IBOutlet UIView *officePickerFormView;
    IBOutlet UIButton *selectPickerButton;
    IBOutlet UIPickerView *pickerView;
    
    IBOutlet UIView *mapView;
    IBOutlet UIView *mapOverlayView;
    IBOutlet UIView *mapContainerView;
    IBOutlet UIButton *closeMapViewButton;
    IBOutlet MKMapView *mapComponent;
    
    MBProgressHUD *hud;
    PromexicoSynchronizationManager *syncManager;
    
    NSMutableArray *offices;
    OfficesDataSource *ds;
    
    NSDictionary *currentOffice;
    
    CLLocationManager *locationManager;
}

-(IBAction)returnToLogin:(id)sender;
-(IBAction)selectOffice:(id)sender;
-(IBAction)selectImage:(id)sender;
-(IBAction)saveSurvey:(id)sender;
-(IBAction)dismissTextfields:(id)sender;
-(IBAction)hidePickerView:(id)sender;
-(IBAction)hideMapView:(id)sender;

@end
