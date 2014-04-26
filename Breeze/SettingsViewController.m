
#import "SettingsViewController.h"

@interface SettingsViewController () {
    NSMutableArray *frequencies;
    NSString *selectedFrequency;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewFrequency;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    return [frequencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [frequencies objectAtIndex:row];
    
}
#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    selectedFrequency = [frequencies objectAtIndex:row];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedFrequency forKey:@"frequency"];
        
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
        
    // Set determinate mode
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
        
    HUD.delegate = self;
    HUD.labelText = @"Saving";
        
    // myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:nil animated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add"
            style:UIBarButtonSystemItemAdd target:self action:@selector(barButtonBackPressed:)];
    
    frequencies = [[NSMutableArray alloc]init];
    [frequencies addObject:@"15 mins"];
    [frequencies addObject:@"30 mins"];
    [frequencies addObject:@"45 mins"];
    [frequencies addObject:@"Every hour"];
    [frequencies addObject:@"Takeoff time"];
    [frequencies addObject:@"Landing time"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
