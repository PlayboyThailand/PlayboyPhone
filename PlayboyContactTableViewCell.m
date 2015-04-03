//
//  PlayboyContactTableViewCell.m
//  linphone
//
//  Created by Rataphon Chitnorm on 3/31/2558 BE.
//
//

#import "PlayboyContactTableViewCell.h"

@implementation PlayboyContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)refreshBlurMask
{
    CGFloat blurFilterRadius = self.blurFilterDiameter * 0.5f;
    
    CGMutablePathRef blurRegionPath = CGPathCreateMutable();
    CGPathAddRect(blurRegionPath, NULL, self.imageView.bounds);
    CGPathAddEllipseInRect(blurRegionPath, NULL, CGRectMake(self.blurFilterOrigin.x - blurFilterRadius, self.blurFilterOrigin.y - blurFilterRadius, self.blurFilterDiameter, self.blurFilterDiameter));
    
    self.blurFilterMask.path = blurRegionPath;
    
    CGPathRelease(blurRegionPath);
}
- (void)dealloc {
    [_imageProfile release];
    [_name release];
    [_status release];
    [super dealloc];
}
@end
