//
//  ViewController.h
//  FileSharingThroughWifi
//
//  Created by wflogin on 10/29/15.
//  Copyright © 2015 wflogin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController<MCBrowserViewControllerDelegate,MCSessionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    __block BOOL _isSendData;
    NSMutableArray *marrFileData, *marrReceiveData;
    int noOfdata, noOfDataSend;
    BOOL videoData;
    BOOL imageData;
    
    NSString* videoPathString;
     NSMutableArray *imagesArray;
    NSURL *videoURL ;
    
    
    NSData *sendVideoData;
    
    BOOL recieveImgData;


}
@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, copy) NSArray *chosenImages;

@property (nonatomic, retain) NSString *videoPathString;
@property (strong, nonatomic) IBOutlet UILabel *noOfDataSend;
@property (strong, nonatomic) IBOutlet UILabel *noOfVidDataSend;

- (IBAction)instructions:(id)sender;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

- (IBAction)connectToOtheDeviceButtonClicked:(id)sender;
- (IBAction)sendDataToConnecteddDevice:(id)sender;
- (IBAction)sendVideoData:(id)sender;


@end

