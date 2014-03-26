//
//  PCTContactoDetalleViewController.m
//  iOSPruebaCoreTelephony
//
//  Created by jorgeSV on 07/03/14.
//  Copyright (c) 2014 menus.es. All rights reserved.
//

#import "PCTContactoDetalleViewController.h"
#import "PCTContacto.h"

@interface PCTContactoDetalleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@property (nonatomic,strong) NSURL *requestURL;
@property (nonatomic,strong) NSMutableURLRequest *updateRequest;
@property (nonatomic,strong) NSURLConnection *updateCon;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic,strong) NSMutableString *currentElementValue;
@property (nonatomic,strong) NSData *receivedDataEnc;

- (IBAction)goCall:(id)sender;

@end

@implementation PCTContactoDetalleViewController




#pragma mark - Carga Pantalla

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _contactoSeleccionado.fullName;
    [_lblPhoneNumber setText:_contactoSeleccionado.phone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

















#pragma mark - Outlets

- (IBAction)goCall:(id)sender
{
    DLog(@"GO CALL");
}

@end
