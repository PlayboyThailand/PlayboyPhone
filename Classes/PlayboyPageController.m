//
//  PlayboyPageController.m
//  linphone
//
//  Created by Rataphon Chitnorm on 3/30/2558 BE.
//
//

#import "PlayboyPageController.h"
#import "LinphoneManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import "PlayboyContactTableViewCell.h"
#import "NSString+MD5.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface PlayboyPageController ()

@end

@implementation PlayboyPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getContactList];
  
//    self.tableData= [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"0891116681",@"Tel",@"Tui",@"Name", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"0890257289",@"Tel",@"Kai",@"Name", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"0800088088",@"Tel",@"P'King 08",@"Name", nil],
//        [NSDictionary dictionaryWithObjectsAndKeys:@"0900900099",@"Tel",@"P'King 09",@"Name", nil],
//        [NSDictionary dictionaryWithObjectsAndKeys:@"0839090808",@"Tel",@"พี่โอ",@"Name", nil],
//                      nil];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString *)generateAuthorizationWithURL:(NSURL *)url{
//    return [NSString stringWithFormat:@"Bearer %@:%@",self.index, [[url description] HMACWithSecret: self.token]];
        return [NSString stringWithFormat:@"Bearer %@:%@",@"xxxxxxxxx", [[url description] HMACWithSecret: @"xxxxxxxxxx"]];
}

-(void)getContactList {
    
    NSString* endpoint =[NSString stringWithFormat:@"%@",kIMCONTACT_ENDPOINT];
    NSURL *URL = [NSURL URLWithString:endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[self generateAuthorizationWithURL:[request URL]] forHTTPHeaderField:@"Authorization"];
    [request setValue:[OpenUDID value] forHTTPHeaderField:@"X-Playboy-UDID"];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
   
            [UIAlertView alertViewWithTitle:@"Error" message:@""];
        }else{
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            NSInteger responseStatusCode = [httpResponse statusCode];

            
            if (responseStatusCode==200){
                NSArray* json= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if(json){
                    self.contacts = json;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tblContact reloadData];
                    });
                    //                    self.tableData= sdfasdfsd
                }else{
                    [UIAlertView alertViewWithTitle:@"Error" message:@"json result is invalid"];
                    
                    
                }
            }else{
                 [UIAlertView alertViewWithTitle:@"Error" message:[NSString stringWithFormat:@"error ,%d",responseStatusCode]];;
            }
            
        }
    }];
    [task resume];
}
#pragma tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contacts count];
}

// Update the blur mask within the UI.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    PlayboyContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayboyContactCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlayboyContactCell" bundle:nil] forCellReuseIdentifier:@"PlayboyContactCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PlayboyContactCell"];

    }
    
    cell.name.text =[[self.contacts objectAtIndex:indexPath.row] objectForKey:@"ModelName"];
    cell.status.text = @"Ready";

//    CALayer *imageLayer = cell.imageProfile.layer;
//    [imageLayer setCornerRadius:5];
//    [imageLayer setBorderWidth:1];
//    [imageLayer setMasksToBounds:YES];
    NSString *img = [[self.contacts objectAtIndex:indexPath.row] objectForKey:@"ProfileImage"];
    if (![img  isEqual: @""]) {
        NSURL *imageURL=[NSURL URLWithString:
                         [NSString stringWithFormat:@"%@",img]];
        
        NSURLRequest* request= [NSURLRequest requestWithURL:imageURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5];
        NSURLSessionDownloadTask * getImageTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            UIImage * downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            if (downloadedImage!=nil){
                dispatch_async(dispatch_get_main_queue(), ^ {
                    cell.imageProfile.image = downloadedImage;
                });
            }
        }];
        [getImageTask resume];
    }
    cell.imageProfile.layer.cornerRadius = cell.imageProfile.frame.size.width / 2;
    cell.imageProfile.clipsToBounds = YES;
//    [cell.imageProfile.layer setCornerRadius:(cell.imageProfile.frame.size.width/2) - 3.5f];
//    [cell.imageProfile.layer setMasksToBounds:YES];
//    [cell.imageProfile setClipsToBounds:YES];

    
//    cell.blurFilterOrigin = cell.imageProfile.center;
//    cell.blurFilterDiameter = MIN(CGRectGetWidth(cell.imageProfile.bounds), CGRectGetHeight(cell.imageProfile.bounds));
//    
//    CAShapeLayer *blurFilterMask = [CAShapeLayer layer];
//    blurFilterMask.actions = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"path", nil];
//    blurFilterMask.fillColor = [UIColor blackColor].CGColor;
//    blurFilterMask.fillRule = kCAFillRuleEvenOdd;
//    blurFilterMask.frame = cell.imageProfile.bounds;
//    blurFilterMask.opacity = 0.5f;
//    cell.blurFilterMask = blurFilterMask;
//    
//    [cell refreshBlurMask];
//    [cell.imageProfile.layer addSublayer:blurFilterMask];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     [[LinphoneManager instance] call:[[self.contacts objectAtIndex:indexPath.row] objectForKey:@"Tel"] displayName:[[self.contacts objectAtIndex:indexPath.row] objectForKey:@"ModelName"] transfer:FALSE];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)dealloc {
    [_tblContact release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTblContact:nil];
    [super viewDidUnload];
}
@end
