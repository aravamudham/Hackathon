
#import "ViewController.h"
#import "QuietSpotViewController.h"
#import "SortViewController.h"
#import "SettingsViewController.h"
#import "ViewController2.h"
#import "Airport.h"

@interface ViewController () {
    NSMutableArray *completeListAirports;
}

@end

@implementation ViewController

- (void)loadAirportData {
    
    NSMutableArray *airports = [NSMutableArray new];
    
    NSURL *dataFileURL = [[NSBundle mainBundle] URLForResource:@"airports" withExtension:@"csv"];
    
    NSString *data = [NSString stringWithContentsOfURL:dataFileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSCharacterSet *quotesCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:data];
    BOOL ok = YES;
    BOOL firstLine = YES;
    while (![scanner isAtEnd] && ok) {
        NSString *line = nil;
        ok = [scanner scanUpToString:@"\n" intoString:&line];
        
        if (firstLine) {
            firstLine = NO;
            continue;
        }
        
        if (line && ok) {
            NSArray *components = [line componentsSeparatedByString:@","];
            
            NSString *type = [components[2] stringByTrimmingCharactersInSet:quotesCharacterSet];
            if ([type isEqualToString:@"large_airport"]) {
                Airport *airport = [Airport new];
                airport.name = [components[3] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.city = [components[10] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.code = [components[13] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.location = [[CLLocation alloc] initWithLatitude:[components[4] doubleValue]
                                                              longitude:[components[5] doubleValue]];
                
                [airports addObject:airport];
            }
        }
    }
    
    completeListAirports = airports;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:alertTextField.text forKey:@"name"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 70, 120, 79)];
    imgView.image = [UIImage imageNamed:@"Breeze-Logo.png"];
    imgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imgView];
    
    
    completeListAirports = [[NSMutableArray alloc]init];
    [self loadAirportData];
	// Do any additional setup after loading the view, typically from a nib.
    // Modify buttons' style in circle menu
    for (UIButton * button in [self.menu subviews])
        [button setAlpha:.95f];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"name"] == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your Name?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
        alertView.tag = 2;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView show];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KYCircleMenu Button Action

// Run button action depend on their tags:
//
// TAG:        1       1   2      1   2     1   2     1 2 3     1 2 3
//            \|/       \|/        \|/       \|/       \|/       \|/
// COUNT: 1) --|--  2) --|--   3) --|--  4) --|--  5) --|--  6) --|--
//            /|\       /|\        /|\       /|\       /|\       /|\
// TAG:                             3       3   4     4   5     4 5 6
//
- (void)runButtonActions:(id)sender {
    [super runButtonActions:sender];
    if ([sender tag] == 1) {
        SortViewController *rVC = [[SortViewController alloc]initWithNibName:@"SortViewController" bundle:nil];
        [rVC setTitle:@"Find a Quiet Spot"];
        [self pushViewController:rVC];
    } else if([sender tag] == 2) {
        QuietSpotViewController *rVC = [[QuietSpotViewController alloc]initWithNibName:@"QuietSpotViewController" bundle:nil];
        rVC.listAirports = [[NSMutableArray alloc]init];
        for (int i = 0; i < [completeListAirports count]; i++) {
            [rVC.listAirports addObject:[completeListAirports objectAtIndex:i]];
        }
        [rVC setTitle:@"My Itinerary"];
        [self pushViewController:rVC];
    } else if([sender tag] == 3) {
        SettingsViewController *rVC = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        [rVC setTitle:@"Settings"];
        [self pushViewController:rVC];
    } else  {
        ViewController2 *rVC = [[ViewController2 alloc]initWithNibName:@"ViewController2" bundle:nil];
        [rVC setTitle:@"View"];
        [self pushViewController:rVC];
    }
}

@end
