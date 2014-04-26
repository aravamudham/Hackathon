
#import "QuietSpotsDataTableViewController.h"
#import "QuietTableViewCell.h"
#import "SpotDetailTableCell.h"
#import "QuietSpot.h"

@interface QuietSpotsDataTableViewController ()

@end

@implementation QuietSpotsDataTableViewController
@synthesize quietSpots;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:
      [UIImage imageNamed:@"Itinerary.png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.quietSpots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SpotDetailTableCell";
    
    SpotDetailTableCell *cell = (SpotDetailTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SpotDetailTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    QuietSpot *q = [self.quietSpots objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = q.name;
    cell.thumbnailImageView.image = [UIImage imageNamed:@"Breeze-Logo.png"];
    cell.powerOutletLabel.text = q.powerOutlet;
    
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuietSpot"];
    QuietSpot *q = [self.quietSpots objectAtIndex:indexPath.row];
    cell.textLabel.text = q.name;
    return cell;
}
*/


@end
