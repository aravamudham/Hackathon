
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@end
