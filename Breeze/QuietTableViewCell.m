
#import "QuietTableViewCell.h"

@implementation QuietTableViewCell
@synthesize title, imageView, power;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
