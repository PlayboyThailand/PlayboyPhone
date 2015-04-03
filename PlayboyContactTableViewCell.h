//
//  PlayboyContactTableViewCell.h
//  linphone
//
//  Created by Rataphon Chitnorm on 3/31/2558 BE.
//
//

#import <UIKit/UIKit.h>

@interface PlayboyContactTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imageProfile;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *status;

@property (strong) CAShapeLayer *blurFilterMask;
@property (assign) CGPoint blurFilterOrigin;
@property (assign) CGFloat blurFilterDiameter;

- (void)refreshBlurMask;
@end
