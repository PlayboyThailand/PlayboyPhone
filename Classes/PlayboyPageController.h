//
//  PlayboyPageController.h
//  linphone
//
//  Created by Rataphon Chitnorm on 3/30/2558 BE.
//
//

#import <UIKit/UIKit.h>

@interface PlayboyPageController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tblContact;

@property (nonatomic, strong) NSArray *contacts;
@end
