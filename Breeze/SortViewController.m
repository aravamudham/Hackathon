
#import "SortViewController.h"
#import "QuietSpotsDataTableViewController.h"
#import "SAMultisectorControl.h"
#import "QuietSpot.h"
#import "PowerOutlet.h"
#import "MBProgressHUD.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SortViewController () {
    NSMutableArray *tweets;
    NSMutableArray *allTweets;
    NSMutableArray *allQuietSpots;
    NSMutableArray *listPowerOutlets;
    NSString *geoCode;
    NSString *max_id;
    int maxLoop;
    int quietIndexMin;
    int quietIndexMax;
    int quietRadius;
    NSString *airport_code;
    NSString *latitudeGate;
    NSString *longitudeGate;
}
@property (weak, nonatomic) IBOutlet UISwitch *powerOutlet;

@property (weak, nonatomic) IBOutlet SAMultisectorControl *multisectorControl;
@property (weak, nonatomic) IBOutlet UILabel *quietnessStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *quietnessEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceEndLabel;

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation SortViewController

- (void) loadPowerOutletData {
    listPowerOutlets = [[NSMutableArray alloc]init];
    //data from airpower.pbworks.com
    PowerOutlet *p0 = [[PowerOutlet alloc]init];
    p0.airport_code = @"PHL";
    p0.description = @"Gate B13, outlets on the wall to the far left of the check-in counter";
    p0.imageName = @"";
    [listPowerOutlets addObject:p0];
    
    PowerOutlet *p1 = [[PowerOutlet alloc]init];
    p1.airport_code = @"PHL";
    p1.description = @"Gate F36, power is back behind the check in counter in the F38 seating area. Stack of wheelchairs parked in front of outlet.";
    p1.imageName = @"";
    [listPowerOutlets addObject:p1];
    
    PowerOutlet *p2 = [[PowerOutlet alloc]init];
    p2.airport_code = @"SFO";
    p2.description = @"power outlet on every second post";
    p2.imageName = @"";
    [listPowerOutlets addObject:p2];
    
    PowerOutlet *p3 = [[PowerOutlet alloc]init];
    p3.airport_code = @"ORD";
    p3.description = @"Gate C1: there are outlets on the wall near the phone banks -- but no juice. There are untested outlets right on the podiums and near some of the arrival/departure screens.";
    p3.imageName = @"";
    [listPowerOutlets addObject:p3];
    
    PowerOutlet *p4 = [[PowerOutlet alloc]init];
    p4.airport_code = @"ORD";
    p4.description = @"There is also an outlet on the side of the gate checkin desk";
    p4.imageName = @"";
    [listPowerOutlets addObject:p4];
    
    PowerOutlet *p5 = [[PowerOutlet alloc]init];
    p5.airport_code = @"ORD";
    p5.description = @"Look for the ATM machines near the gates. Usually there's one spare outlet at the back. You'll have to sit with your back to the gate.";
    p5.imageName = @"";
    [listPowerOutlets addObject:p5];
    
    PowerOutlet *p6 = [[PowerOutlet alloc]init];
    p6.airport_code = @"ORD";
    p6.description = @"If your gate has a water fountain, look underneath it. There should be an outlet with 1 open socket. It might not be near your gate, but there's normally a nice seat right next to it.";
    p6.imageName = @"";
    [listPowerOutlets addObject:p6];
    
    PowerOutlet *p7 = [[PowerOutlet alloc]init];
    p7.airport_code = @"ORD";
    p7.description = @"In the food court that sits at the fork between Terminals H & K, there are many pillars, each with a power outlet. The problem is this food court is usually really busy, and other people know about the outlets on the pillars too. Nobody seems to have any qualms about plopping down next to you in order to charge their laptop. Feel free to do the same. There are decent tables and chairs and of course lots of food that you can get while you're keeping an eye on your laptop.";
    p7.imageName = @"";
    [listPowerOutlets addObject:p7];
    
    PowerOutlet *p8 = [[PowerOutlet alloc]init];
    p8.airport_code = @"ORD";
    p8.description = @"E2 there is an outlet under the bank of telephones, but the sockets are very loose. Opt instead for the outlet one pillar to the left of the gate.";
    p6.imageName = @"";
    [listPowerOutlets addObject:p8];
    
    PowerOutlet *p9 = [[PowerOutlet alloc]init];
    p9.airport_code = @"ORD";
    p9.description = @"E6 there is a power strip with 12 outlets.";
    p9.imageName = @"";
    [listPowerOutlets addObject:p9];
    
    PowerOutlet *p10 = [[PowerOutlet alloc]init];
    p10.airport_code = @"ORD";
    p10.description = @"E13 there is an outlet near the water fountain and a starbucks 30 yards away";
    p10.imageName = @"";
    [listPowerOutlets addObject:p10];
    
    PowerOutlet *p11 = [[PowerOutlet alloc]init];
    p11.airport_code = @"ORD";
    p11.description = @"K1 in the back-right corner is a solitary outlet directly in the floor. Its hiding behind a large pillar.";
    p11.imageName = @"";
    [listPowerOutlets addObject:p11];
    
    PowerOutlet *p12 = [[PowerOutlet alloc]init];
    p12.airport_code = @"ORD";
    p12.description = @"A wall that was once probably pay phones is now 5 desk-stations with two to four single receptacles, stationary stools and privacy walls between each station";
    p12.imageName = @"";
    [listPowerOutlets addObject:p12];
    
    PowerOutlet *p13 = [[PowerOutlet alloc]init];
    p13.airport_code = @"ORD";
    p13.description = @"K17-K20 there are power outlets around the perimiter, by the windows. They are a two-plug outlet in a silver metallic case that stands up about 3 inches from the ground. There are also what used to be circular four-plug outlets directly in the floor by K17. These do not work, don't even try. The downside to the outlets by the window is glare on your screen during the day.";
    p13.imageName = @"";
    [listPowerOutlets addObject:p13];
    
    PowerOutlet *p14 = [[PowerOutlet alloc]init];
    p13.airport_code = @"BOS";
    p13.description = @"Gates C12 and C14, plentiful power. Some of the outlets did not function, however.";
    p13.imageName = @"";
    [listPowerOutlets addObject:p14];
    
    PowerOutlet *p15 = [[PowerOutlet alloc]init];
    p15.airport_code = @"JFK";
    p15.description = @"Only one working outlet on the ceiling across from the elevator from most gates";
    p15.imageName = @"";
    [listPowerOutlets addObject:p15];
    
    PowerOutlet *p16 = [[PowerOutlet alloc]init];
    p16.airport_code = @"YUL";
    p16.description = @"Gate 82: On the far side of the concourse, oposite the gate, in the Bell Canada telephone booths, and beside the telephone booths. No power in the seating area itself. All capped.";
    p16.imageName = @"";
    [listPowerOutlets addObject:p16];
    
    PowerOutlet *p17 = [[PowerOutlet alloc]init];
    p17.airport_code = @"YUL";
    p17.description = @"In the AirCanada regional area (far side of the terminal) had uncapped outlets along the dividers.";
    p17.imageName = @"";
    [listPowerOutlets addObject:p17];
    
    PowerOutlet *p18 = [[PowerOutlet alloc]init];
    p18.airport_code = @"YYZ";
    p18.description = @"Power outlets are available along the wall as you walk through to the gates. Across from gates, there are a small number of outlets high in the wall or by the floor.";
    p18.imageName = @"";
    [listPowerOutlets addObject:p18];
    
    PowerOutlet *p19 = [[PowerOutlet alloc]init];
    p19.airport_code = @"YVR";
    p19.description = @"Gates A1 to A4: Power outlets are in some of the concrete columns supporting the roof. It looks like every second column.";
    p19.imageName = @"";
    [listPowerOutlets addObject:p19];
    
    PowerOutlet *p20 = [[PowerOutlet alloc]init];
    p20.airport_code = @"YSJ";
    p20.description = @"Power in the waiting area, as well as along wall of departures. Also in the cafe.";
    p20.imageName = @"";
    [listPowerOutlets addObject:p20];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

-(void)barButtonBackPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self fetchTimelineForUser:@"paravamu"];
}

- (id) init {
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) calculateQuietSpots
{
    int occurences = 0;
    for (int i = 0; i < [tweets count]; i++) {
        if ([[tweets objectAtIndex:i] rangeOfString:airport_code].location == NSNotFound) {
        } else {
            occurences++;
        }
    }
    int numberSpotsRadius = 0;
    
    if (occurences > 0) {
        numberSpotsRadius = occurences / 10;
        allQuietSpots = [[NSMutableArray alloc]init];
    }
    
    BOOL addedSegment = NO;
    
    if ([self.distanceStartLabel.text intValue] > 0 && [self.distanceEndLabel.text intValue] < 100) {
        addedSegment = YES;
        QuietSpot *qSpot = [[QuietSpot alloc]init];
        qSpot.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 50)];
        qSpot.powerOutlet = @"NO POWER OUTLET";
        qSpot.picFile = @"";
        [allQuietSpots addObject:qSpot];
    } else if ([self.distanceStartLabel.text intValue] > 0 && [self.distanceEndLabel.text intValue] < 200 && addedSegment == NO) {
        addedSegment = YES;
        QuietSpot *qSpot = [[QuietSpot alloc]init];
        qSpot.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 50)];
        qSpot.powerOutlet = @"NO POWER OUTLET";
        qSpot.picFile = @"";
        [allQuietSpots addObject:qSpot];
        
        QuietSpot *qSpot1 = [[QuietSpot alloc]init];
        qSpot1.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 100)];
        qSpot1.powerOutlet = @"NO POWER OUTLET";
        qSpot1.picFile = @"";
        [allQuietSpots addObject:qSpot1];
    } else if ([self.distanceStartLabel.text intValue] > 0 && [self.distanceEndLabel.text intValue] < 300 && addedSegment == NO) {
        addedSegment = YES;
        QuietSpot *qSpot = [[QuietSpot alloc]init];
        qSpot.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 50)];
        qSpot.powerOutlet = @"NO POWER OUTLET";
        qSpot.picFile = @"";
        [allQuietSpots addObject:qSpot];
        
        QuietSpot *qSpot1 = [[QuietSpot alloc]init];
        qSpot1.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 100)];
        qSpot1.powerOutlet = @"NO POWER OUTLET";
        qSpot1.picFile = @"";
        [allQuietSpots addObject:qSpot1];
        
        QuietSpot *qSpot2 = [[QuietSpot alloc]init];
        qSpot2.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 150)];
        qSpot2.powerOutlet = @"NO POWER OUTLET";
        qSpot2.picFile = @"";
        [allQuietSpots addObject:qSpot2];
    } else if ([self.distanceStartLabel.text intValue] > 100 && [self.distanceEndLabel.text intValue] < 200 && addedSegment == NO) {
        addedSegment = YES;
        QuietSpot *qSpot1 = [[QuietSpot alloc]init];
        qSpot1.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 100)];
        qSpot1.powerOutlet = @"NO POWER OUTLET";
        qSpot1.picFile = @"";
        [allQuietSpots addObject:qSpot1];
    } else if ([self.distanceStartLabel.text intValue] > 100 && [self.distanceEndLabel.text intValue] < 300 && addedSegment == NO) {
        addedSegment = YES;
        QuietSpot *qSpot1 = [[QuietSpot alloc]init];
        qSpot1.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 100)];
        qSpot1.powerOutlet = @"NO POWER OUTLET";
        qSpot1.picFile = @"";
        [allQuietSpots addObject:qSpot1];
        
        QuietSpot *qSpot2 = [[QuietSpot alloc]init];
        qSpot2.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 150)];
        qSpot2.powerOutlet = @"NO POWER OUTLET";
        qSpot2.picFile = @"";
        [allQuietSpots addObject:qSpot2];
        
        QuietSpot *qSpot3 = [[QuietSpot alloc]init];
        qSpot3.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 200)];
        qSpot3.powerOutlet = @"NO POWER OUTLET";
        qSpot3.picFile = @"";
        [allQuietSpots addObject:qSpot3];
    } else if ([self.distanceStartLabel.text intValue] > 200 && [self.distanceEndLabel.text intValue] < 300 && addedSegment == NO) {
        addedSegment = YES;
        QuietSpot *qSpot3 = [[QuietSpot alloc]init];
        qSpot3.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 200)];
        qSpot3.powerOutlet = @"NO POWER OUTLET";
        qSpot3.picFile = @"";
        [allQuietSpots addObject:qSpot3];
        
        QuietSpot *qSpot4 = [[QuietSpot alloc]init];
        qSpot4.name = [NSString stringWithFormat:@"%d feet from Gate", (numberSpotsRadius + 250)];
        qSpot4.powerOutlet = @"NO POWER OUTLET";
        qSpot4.picFile = @"";
        [allQuietSpots addObject:qSpot4];
    }
    
    if ([self.powerOutlet isOn]) {
        for (int i = 0; i < [listPowerOutlets count]; i++) {
            PowerOutlet *p = [listPowerOutlets objectAtIndex:i];
            if ([p.airport_code isEqualToString:airport_code]) {
                QuietSpot *qSpot5 = [[QuietSpot alloc]init];
                qSpot5.name = p.description;
                qSpot5.powerOutlet = @"POWER OUTLET FOUND";
                qSpot5.picFile = @"";
                [allQuietSpots addObject:qSpot5];
            }
        }
    }
    
    if ([allQuietSpots count] > 0) {
        for (QuietSpot *q in allQuietSpots) {
            NSLog(@"The spot name is: %@", q.name);
        }
    }
    
    QuietSpotsDataTableViewController *vc = [[QuietSpotsDataTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.quietSpots = [[NSMutableArray alloc]init];
    if ([allQuietSpots count] > 0) {
        for (int i = 0; i < [allQuietSpots count]; i++) {
            [vc.quietSpots addObject:[allQuietSpots objectAtIndex:i]];
        }
    }
    
    [vc setTitle:@"Quiet Spots!"];
    //[vc.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) iterateThroughTweets:(NSString*)username
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        //  Step 1:  Obtain access to the user's Twitter accounts
        NSLog(@"The geocode is: %@", geoCode);
        allTweets = [[NSMutableArray alloc]init];
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error) {
            
            NSLog(@"paravamu");
            //  Step 2:  Create a request
            NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
            NSDictionary *params = @{@"count" : @"500",
                                     @"q" : @"",
                                     @"geocode" : geoCode,
                                     @"max_id" : max_id,
                                     @"rpp" : @"1000"};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
            //  Attach an account to the request
            [request setAccount:[twitterAccounts lastObject]];
            //  Step 3:  Execute the request
            [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse,NSError *error) {
                
                if (responseData) {
                    if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                        NSError *jsonError;
                        NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        allTweets = timelineData[@"statuses"];
                        if (allTweets.count > 0) {
                            maxLoop ++;
                            //NSLog(@"AllTweets array count is: %d", [allTweets count]);
                            for (int i = 0; i < [allTweets count]; i++) {
                                NSDictionary *user_tweet = [allTweets objectAtIndex:i];
                                [tweets addObject:user_tweet[@"text"]];
                                NSString *tweet_id = user_tweet[@"id"];
                                //NSLog(@"The tweet id is: %@", tweet_id);
                                if (i == 0) {
                                    max_id = tweet_id;
                                }
                            }
                            if (allTweets.count == 100) {
                                if (maxLoop < 5) {
                                    [self iterateThroughTweets:@"paravamu"];
                                } else {
                                    [self calculateQuietSpots];
                                }
                            } else {
                                //[self printTweets];
                                [self calculateQuietSpots];
                            }
                        }
                        else {
                            // Our JSON deserialization went awry
                            NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                        }
                        
                    }
                    else {
                        // The server did not respond ... were we rate-limited?
                        NSLog(@"The response status code is %d", urlResponse.statusCode);
                        
                    }
                    
                }
                
            }];
        }];
    }
}

- (void)fetchTimelineForUser:(NSString *)username
{
    maxLoop = 1;
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        //  Step 1:  Obtain access to the user's Twitter accounts
        NSLog(@"The geocode is: %@", geoCode);
        allTweets = [[NSMutableArray alloc]init];
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL
                completion:^(BOOL granted, NSError *error) {
                    NSLog(@"paravamu");
                    tweets = [[NSMutableArray alloc] init];
                    //  Step 2:  Create a request
                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                    NSDictionary *params = @{@"count" : @"500",
                                             @"q" : @"",
                                             @"geocode" : geoCode,
                                             @"rpp" : @"1000"};
                                                    
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                    //  Attach an account to the request
                    [request setAccount:[twitterAccounts lastObject]];
                    //  Step 3:  Execute the request
                    [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                                        
                    if (responseData) {
                        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                            NSError *jsonError;
                                                                
                            NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];

                                allTweets = timelineData[@"statuses"];
                                if (allTweets.count > 0) {
                                    for (int i = 0; i < [allTweets count]; i++) {
                                        NSDictionary *user_tweet = [allTweets objectAtIndex:i];
                                        [tweets addObject:user_tweet[@"text"]];
                                        NSString *tweet_id = user_tweet[@"id"];
                                        if (i == 0) {
                                            max_id = tweet_id;
                                        }
                                    }
                                if (allTweets.count == 100) {
                                    [self iterateThroughTweets:@"paravamu"];
                                } else {
                                    [self calculateQuietSpots];
                                }
                            }
                            else {
                                // Our JSON deserialization went awry
                                NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            }
                        }
                        else {
                            // The server did not respond ... were we rate-limited?
                            NSLog(@"The response status code is %d", urlResponse.statusCode);
                        }
                                                            
                    }
                                                        
                }];
            }];
    }
    
}

- (void) viewDidAppear:(BOOL)animated
{
    self.navigationItem.title=@"Find a Quiet Spot";
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    maxLoop = 1;
    [self loadPowerOutletData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
        style:UIBarButtonSystemItemDone target:self action:@selector(barButtonBackPressed:)];
    
    [self setupDesign];
    [self setupMultisectorControl];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    latitudeGate = [defaults objectForKey:@"latitudeGate"];
    longitudeGate = [defaults objectForKey:@"longitudeGate"];
    airport_code = [defaults objectForKey:@"airportCode"];
    
    if (latitudeGate != nil && longitudeGate != nil && airport_code != nil) {
        geoCode = [[NSString alloc] initWithFormat:@"%@,%@,1mi", latitudeGate, longitudeGate];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please choose the airport you are flying from first!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)setupDesign {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setupMultisectorControl{
    [self.multisectorControl addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:0.0 blue:255.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    SAMultisectorSector *sector2 = [SAMultisectorSector sectorWithColor:greenColor minValue:1.0 maxValue:8.0];
    SAMultisectorSector *sector3 = [SAMultisectorSector sectorWithColor:blueColor minValue:1.0 maxValue:300.0];
    
    sector2.tag = 1;
    sector3.tag = 2;
    
    sector2.endValue = 4.0;
    sector3.startValue = 50.0;
    sector3.endValue = 300.0;
    
    [self.multisectorControl addSector:sector2];
    [self.multisectorControl addSector:sector3];
    
    [self updateDataView];
}

- (void)multisectorValueChanged:(id)sender{
    [self updateDataView];
}

- (void)updateDataView{
    for(SAMultisectorSector *sector in self.multisectorControl.sectors){
        NSString *startValue = [NSString stringWithFormat:@"%.0f", sector.startValue];
        NSString *endValue = [NSString stringWithFormat:@"%.0f", sector.endValue];
        if(sector.tag == 1){
            self.quietnessStartLabel.text = startValue;
            self.quietnessEndLabel.text = endValue;
        }
        if(sector.tag == 2){
            self.distanceStartLabel.text = startValue;
            self.distanceEndLabel.text = endValue;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
