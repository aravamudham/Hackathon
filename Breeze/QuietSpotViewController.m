
#import "QuietSpotViewController.h"
#import "Airport.h"
#import "QuietSpot.h"
#import "NSMutableString+AddText.h"

@interface QuietSpotViewController () {
    NSMutableArray *airlines;
    NSString *airlineCode;
    NSMutableArray *_airports;
    NSString *numberToText;
    NSString *airport_code;
    NSString *latitudeGate;
    NSString *longitudeGate;
    
    NSString *selectedYear;
    NSString *selectedMonth;
    NSString *selectedDay;
    NSString *airlineNumberCode;
    NSString *departureGate;
    NSString *departureTerminal;
    NSString *arrivalGate;
    NSString *arrivalTerminal;
    NSString *arrivalBaggageClaim;
    NSString *estimatedGateArrival;
}
@property (weak, nonatomic) IBOutlet UIButton *getTweets;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *airlinePicker;
@property (weak, nonatomic) IBOutlet UITextField *airlineNumber;


@end

@implementation QuietSpotViewController
@synthesize listAirports;

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    //NSLog(@"The results are: %@", json);
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* flightStatus = [json objectForKey:@"flightStatuses"];
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:flightStatus];
}

- (void) plotPositions: (NSArray*) data
{
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* operationalTimes = [[[data objectAtIndex:i] objectForKey:@"operationalTimes"] objectForKey:@"estimatedGateArrival"];
        
        if ([operationalTimes objectForKey:@"dateLocal"] != nil) {
            NSString *someTime = [operationalTimes objectForKey:@"dateLocal"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.000";
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
            [dateFormatter setTimeZone:gmt];
            
            NSString *timeStamp = [dateFormatter stringFromDate:[dateFormatter dateFromString:someTime]];
            estimatedGateArrival = timeStamp;
            NSLog(@"The estimated gate arrival is: %@", estimatedGateArrival);
            
            NSDate *arrivalDate = [dateFormatter dateFromString:someTime];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            
            NSString *startTimeString = [formatter stringFromDate:arrivalDate];
            estimatedGateArrival = startTimeString;
            
            NSLog(@"The arrival hour and arrival minutes are: %@", startTimeString);
        }
        
        NSDictionary* resources = [[data objectAtIndex:i] objectForKey:@"airportResources"];
        
        if ([resources objectForKey:@"departureGate"] != nil) {
            departureGate = [resources objectForKey:@"departureGate"];
            NSLog(@"The departure gate is: %@", departureGate);
        }
        if ([resources objectForKey:@"arrivalGate"] != nil) {
            arrivalGate = [resources objectForKey:@"arrivalGate"];
            NSLog(@"The arrival gate is: %@", arrivalGate);
        }
        if ([resources objectForKey:@"departureTerminal"] != nil) {
            departureTerminal = [resources objectForKey:@"departureTerminal"];
            NSLog(@"The departure terminal is: %@", departureTerminal);
        }
        if ([resources objectForKey:@"arrivalTerminal"] != nil) {
            arrivalTerminal = [resources objectForKey:@"arrivalTerminal"];
            NSLog(@"The arrival terminal is: %@", arrivalTerminal);
        }
        if ([resources objectForKey:@"baggage"] != nil) {
            arrivalBaggageClaim = [resources objectForKey:@"baggage"];
            NSLog(@"The arrival baggage claim is: %@", arrivalBaggageClaim);
        } else {
            arrivalBaggageClaim = @"TBD";
        }
    }
    
    NSLog(@"Sending request.");
    // Common constants
    // need twilio API keys
    NSString *kTwilioSID = @"AC545ee8113d7fc605321091686bbaf74a";
    NSString *kTwilioSecret = @"103b49908b4ccf180ddc91cbd235273d";
    NSString *kFromNumber = @"2242057684";
    NSString *kToNumber = @"";
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberToText"] != nil) {
        kToNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumberToText"];
    } else {
        kToNumber = self.numberTextField.text;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passengerName = [defaults objectForKey:@"name"];
    
    NSString *kMessage = [NSString stringWithFormat:@"%@ is landing at: %@ in terminal: %@ - Gate: %@. Baggage claim is: %@", passengerName, estimatedGateArrival, arrivalTerminal, arrivalGate, arrivalBaggageClaim];
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data1 = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data1];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self performSelectorOnMainThread:@selector(fetchedDataTwilio:) withObject:data waitUntilDone:YES];
                           }];
}

- (void)fetchedDataTwilio:(NSData *)responseData {
    NSString *receivedString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Request sent. %@", receivedString);
}

- (void) loadFlightStatsData
{
    NSString* flightStatusAPIString = @"8a0e01afb081fdedb2a552f9a1526972";
    NSString *urlString = [NSString stringWithFormat:@"https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/%@/%@/dep/%@/%@/%@?appId=5a804092&appKey=%@&utc=false", airlineCode, airlineNumberCode, selectedYear, selectedMonth, selectedDay, flightStatusAPIString];
    
    NSLog(@"The url is: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: url];
        //NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"the string is: %@", string);
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
    
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView tag] == 1)
        return [listAirports count];
    else
        return [airlines count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if ([pickerView tag] == 1) {
        Airport *airport = [[Airport alloc] init];
        airport = listAirports[row];
        return airport.name;
    } else {
        return [airlines objectAtIndex:row];
    }
}
#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if ([pickerView tag] == 1) {
        Airport *airport = [[Airport alloc] init];
        airport = listAirports[row];
        airport_code = airport.code;
        latitudeGate = [NSString stringWithFormat:@"%f", airport.location.coordinate.latitude];
        longitudeGate = [NSString stringWithFormat:@"%f", airport.location.coordinate.longitude];
        
    } else {
        switch(row)
        {
            case 0:
                NSLog(@"Air Sunshine");
                airlineCode = @"YI";
                break;
            case 1:
                NSLog(@"AirTran");
                airlineCode = @"FL";
                break;
            case 2:
                NSLog(@"Alaska Airlines");
                airlineCode = @"AS";
                break;
            case 3:
                NSLog(@"Alpine Air Express");
                airlineCode = @"5A";
                break;
            case 4:
                NSLog(@"American");
                airlineCode = @"AA";
                break;
            case 5:
                NSLog(@"American Eagle");
                airlineCode = @"MQ";
                break;
            case 6:
                NSLog(@"Atlas Air");
                airlineCode = @"5Y";
                break;
            case 7:
                NSLog(@"Cape Air");
                airlineCode = @"9K";
                break;
            case 8:
                NSLog(@"Chautauqua Airlines");
                airlineCode = @"RP";
                break;
            case 9:
                NSLog(@"Delta");
                airlineCode = @"DL";
                break;
            case 10:
                NSLog(@"Empire Airlines");
                airlineCode = @"EM";
                break;
            case 11:
                NSLog(@"Florida West");
                airlineCode = @"RF";
                break;
            case 12:
                NSLog(@"Fontier");
                airlineCode = @"F9";
                break;
            case 13:
                NSLog(@"Hawaiian Airlines");
                airlineCode = @"HA";
                break;
            case 14:
                NSLog(@"Horizon Air");
                airlineCode = @"QX";
                break;
            case 15:
                NSLog(@"JetBlue");
                airlineCode = @"B6";
                break;
            case 16:
                NSLog(@"New Mexico Airlines");
                airlineCode = @"LW";
                break;
            case 17:
                NSLog(@"North American Airlines");
                airlineCode = @"NA";
                break;
            case 18:
                NSLog(@"Republic Airlines");
                airlineCode = @"XY";
                break;
            case 19:
                NSLog(@"Shuttle America");
                airlineCode = @"S5";
                break;
            case 20:
                NSLog(@"Silver Airways");
                airlineCode = @"3M";
                break;
            case 21:
                NSLog(@"SkyWest Airlines");
                airlineCode = @"OO";
                break;
            case 22:
                NSLog(@"Southern Air");
                airlineCode = @"9S";
                break;
            case 23:
                NSLog(@"Southwest Airlines");
                airlineCode = @"WN";
                break;
            case 24:
                NSLog(@"Spirit Airlines");
                airlineCode = @"NK";
                break;
            case 25:
                NSLog(@"Sun Country Airlines");
                airlineCode = @"SY";
                break;
            case 26:
                NSLog(@"United Airlines");
                airlineCode = @"UA";
                break;
            case 27:
                NSLog(@"US Airways");
                airlineCode = @"US";
                break;
            case 28:
                NSLog(@"Virgin America");
                airlineCode = @"VX";
                break;
            case 29:
                NSLog(@"Wings of Alaska");
                airlineCode = @"K5";
                break;
        }
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)myProgressTask {
	// This just increases the progress indicator in a loop
	float progress = 0.0f;
	while (progress < 1.0f) {
		progress += 0.01f;
		HUD.progress = progress;
		usleep(50000);
	}
}

-(void)barButtonBackPressed:(id)sender {
    if (latitudeGate != nil && longitudeGate != nil && ![self.airlineNumber.text isEqualToString:@""] && ![self.numberTextField.text isEqualToString:@""]) {
        NSLog(@"The airline # field is: %@", self.airlineNumber.text);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:latitudeGate forKey:@"latitudeGate"];
        [defaults setObject:longitudeGate forKey:@"longitudeGate"];
        [defaults setObject:airport_code forKey:@"airportCode"];
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy"];
        
        NSDateFormatter *outputFormatterMonth = [[NSDateFormatter alloc] init];
        [outputFormatterMonth setDateFormat:@"MM"];
        
        NSDateFormatter *outputFormatterDay = [[NSDateFormatter alloc] init];
        [outputFormatterDay setDateFormat:@"dd"];
        
        NSLog(@"The selected year is: %@", [outputFormatter stringFromDate:self.datePicker.date]);
        selectedYear = [outputFormatter stringFromDate:self.datePicker.date];
        
        NSLog(@"The selected month is: %@", [outputFormatterMonth stringFromDate:self.datePicker.date]);
        selectedMonth = [outputFormatterMonth stringFromDate:self.datePicker.date];
        
        NSLog(@"The selected day is: %@", [outputFormatterDay stringFromDate:self.datePicker.date]);
        selectedDay = [outputFormatterDay stringFromDate:self.datePicker.date];
        
        NSLog(@"The selected text is: %@", self.airlineNumber.text);
        airlineNumberCode = self.airlineNumber.text;
        
        NSLog(@"saved data");
        
        [self loadFlightStatsData];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        // Set determinate mode
        HUD.mode = MBProgressHUDModeAnnularDeterminate;
        
        HUD.delegate = self;
        HUD.labelText = @"Saving";
        
        // myProgressTask uses the HUD instance to update progress
        [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please choose the airport you are flying from, airline # and phone # to text" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.numberTextField.inputAccessoryView = numberToolbar;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                style:UIBarButtonSystemItemAdd target:self action:@selector(barButtonBackPressed:)];
    
    
    
    airlines = [[NSMutableArray alloc] initWithCapacity:35];
    [airlines addObject:@"Air Sunshine"];
    [airlines addObject:@"AirTran"];
    [airlines addObject:@"Alaska Airlines"];
    [airlines addObject:@"Alpine Air Express"];
    [airlines addObject:@"American"];
    [airlines addObject:@"American Eagle"];
    [airlines addObject:@"Atlas Air"];
    [airlines addObject:@"Cape Air"];
    [airlines addObject:@"Chautauqua Airlines"];
    [airlines addObject:@"Delta"];
    [airlines addObject:@"Empire Airlines"];
    [airlines addObject:@"Florida West"];
    [airlines addObject:@"Frontier"];
    [airlines addObject:@"Hawaiian Airlines"];
    [airlines addObject:@"Horizon Air"];
    [airlines addObject:@"JetBlue"];
    [airlines addObject:@"New Mexico Airlines"];
    [airlines addObject:@"North American Airlines"];
    [airlines addObject:@"Republic Airlines"];
    [airlines addObject:@"Shuttle America"];
    [airlines addObject:@"Silver Airways"];
    [airlines addObject:@"SkyWest Airlines"];
    [airlines addObject:@"Southern Air"];
    [airlines addObject:@"Southwest Airlines"];
    [airlines addObject:@"Spirit Airlines"];
    [airlines addObject:@"Sun Country Airlines"];
    [airlines addObject:@"United Airlines"];
    [airlines addObject:@"US Airways"];
    [airlines addObject:@"Virgin America"];
    [airlines addObject:@"Wings of Alaska"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
