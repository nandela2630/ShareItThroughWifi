//
//  ViewController.m
//  FileSharingThroughWifi
//
//  Created by wflogin on 10/29/15.
//  Copyright © 2015 wflogin. All rights reserved.
//

#import "ViewController.h"
#import "GlobalStrings.h"
#import "InstructionsViewController.h"
@interface ViewController ()
{
    GlobalStrings *global;
        int pressCount;
}
@end

@implementation ViewController
@synthesize videoPathString;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    marrFileData = [[NSMutableArray alloc] init];
    marrReceiveData = [[NSMutableArray alloc] init];
global=[[GlobalStrings  alloc]init];
    imagesArray =[[NSMutableArray alloc]init];

   
}
-(void)setUpMultipeer
{
    // Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    // Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    // Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
    self.browserVC.delegate = self;
    // Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}
-(void)showBrowserVC
{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}
-(void)dismissBrowserVC
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}
-(void)stopWifiSharing:(BOOL)isClear
{
    if(isClear && self.mySession != nil){
        [self.mySession disconnect];
        [self.mySession setDelegate:nil];
        self.mySession = nil;
        self.browserVC = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)connectToOtheDeviceButtonClicked:(id)sender {
    
    if (!self.mySession) {
        [self setUpMultipeer];
        pressCount=0;

    }
    [self showBrowserVC];

}
-(void)sendData
{
    pressCount=0;

    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
    picker.delegate=self;
    //  [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
    //[picker setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeMovie]];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    // picker.mediaTypes =  [NSArray arrayWithObject:(NSString *)
    //     kUTTypeMovie];
    [self presentViewController:picker animated:YES completion:nil];

    
  }
-(void)sendVideoData
{
    pressCount=0;
    UIImagePickerController *picker =[[UIImagePickerController alloc]init];
    picker.delegate=self;
   
     picker.mediaTypes =  [NSArray arrayWithObject:(NSString *)    kUTTypeMovie];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    
    if ([mediaType isEqualToString:@"public.image"]){
        
        
        UIImage *anImage = [info valueForKey:UIImagePickerControllerOriginalImage];
      NSData * sendImageData = UIImageJPEGRepresentation(anImage, 1.0);
        
        NSLog(@"length %lu",(unsigned long)[sendImageData length]);
        imageData =YES;
        
        
        [self sendData:sendImageData];
        
        
    }
    
    else if ([mediaType isEqualToString:@"public.movie"]){
        //videoURL =[[NSURL alloc]init];
      // videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
   global.videoPathString = (__bridge NSString *)([[info objectForKey:
                                UIImagePickerControllerMediaURL] path]);
        
      sendVideoData = [NSData dataWithContentsOfFile:global.videoPathString];
        
        videoData=YES;
        
        [self sendData:sendVideoData];
   
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - WSAssetPickerControllerDelegate Methods

- (void)assetPickerControllerDidCancel:(UIImagePickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerControllerDidLimitSelection:(UIImagePickerController *)sender
{
    //        if ([TSMessage isNotificationActive] == NO) {
    //            [TSMessage showNotificationInViewController:sender withTitle:@"Selection limit reached." withMessage:nil withType:TSMessageNotificationTypeWarning withDuration:2.0];
    //       }
}
- (void)assetPickerController:(UIImagePickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    
    // Dismiss the picker controller.
    // [self dismissViewControllerAnimated:YES completion:^{
    
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    int xCount = 0;
    
    for (ALAsset *asset in assets) {
        xCount ++;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
            // asset is a video
        }else
        {
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            // add to imageview/collectionview array
            
            
            [imagesArray addObject:image];
        }
    }
    [self sendData];
    
    //}];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //[self.collectionView reloadData];
    
}
- (IBAction)sendDataToConnecteddDevice:(id)sender {
    
   [self sendData];
    

    
    
}

- (IBAction)sendVideoData:(id)sender {
    [self sendVideoData];
}

#pragma marks MCBrowserViewControllerDelegate
// Notifies the delegate, when the user taps the done button
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
    [marrReceiveData removeAllObjects];
}
// Notifies delegate that the user taps the cancel button.
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}
-(void)appendFileData
{
    NSMutableData *fileData = [NSMutableData data];
    
    for (int i = 0; i < [marrReceiveData count]; i++) {
        [fileData appendData:[marrReceiveData objectAtIndex:i]];
    }
    
//    [fileData writeToFile:[NSString stringWithFormat:@"%@/Image.png", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]] atomically:YES];
    //            [fileData writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] atomically:YES];
    //

    if ( recieveImgData==YES) {
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:fileData], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        imageData=NO;
        recieveImgData=NO;
    }else
    {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/vid1.mp4"];
        
         [fileData writeToFile:tempPath atomically:NO];
        
             if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (tempPath))
            {
                NSString *videoUrlStr =[videoURL path];
                NSLog(@"videoUrlStr %@",videoUrlStr);
                UISaveVideoAtPathToSavedPhotosAlbum(tempPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        videoData=NO;
    
    }
    
    

}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [self invokeAlertMethod:@"Successfully Sent" Body:@"Video shared successfully and saved in Cameraroll." Delegate:nil];
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self invokeAlertMethod:@"Successfully Sent" Body:@"Image shared successfully and saved in Cameraroll." Delegate:nil];
    }
}

- (void)invokeAlertMethod:(NSString *)strTitle Body:(NSString *)strBody Delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strBody
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
//    
//    UIAlertController * alert=   [UIAlertController
//                                  alertControllerWithTitle:strBody
//                                  message:delegate
//                                  preferredStyle:UIAlertControllerStyleAlert];
//    
//    [self presentViewController:alert animated:YES completion:nil];
    alert = nil;
}
-(NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}
#pragma marks MCSessionDelegate
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSLog(@"data receiveddddd : %lu",(unsigned long)data.length);

    pressCount++;
    NSString * str =[self contentTypeForImageData:data];
    if (str!=nil && pressCount>0) {
      recieveImgData=YES;
        pressCount=0;
    }
    NSLog(@"contentTypeForImageData %@",str);

     self.noOfVidDataSend.text= [NSString stringWithFormat:@" %lu",(unsigned long)data.length] ;
    
    if (data.length > 0) {
        if (data.length < 2) {
            noOfDataSend++;
            NSLog(@"noofdatasend : %d",noOfDataSend);
            
         
            
            NSLog(@"array count : %lu",(unsigned long)marrFileData.count);
            if (noOfDataSend < ([marrFileData count])) {
                [self.mySession sendData:[marrFileData objectAtIndex:noOfDataSend] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
            }else {
                [self.mySession sendData:[@"File Transfer Done" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
            }
        } else {
            if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"File Transfer Done"]) {
                [self appendFileData];
            }else {
                [self.mySession sendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
                [marrReceiveData addObject:data];
            }
        }
    }
}


-(void)sendData :(NSData*)sendData
{
    [marrFileData removeAllObjects];
    
    NSUInteger length = [sendData length];
    NSUInteger chunkSize = 100 * 1024;
    NSUInteger offset = 0;
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[sendData bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        NSLog(@"chunk length : %lu",(unsigned long)chunk.length);
        [marrFileData addObject:[NSData dataWithData:chunk]];
        offset += thisChunkSize;
        // do something with chunk
    } while (offset < length);
    noOfdata = [marrFileData count];
    noOfDataSend = 0;
    if ([marrFileData count] > 0) {
        [self.mySession sendData:[marrFileData objectAtIndex:noOfDataSend] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:nil];
    }
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"did receive stream");
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"start receiving");
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"finish receiving resource");
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"change state : %ld",(long)state);
    
    self.noOfDataSend.text=[NSString stringWithFormat:@"change state : %ld",(long)state];
    
//    if ([self.noOfDataSend.text isEqualToString:@"1" ]||[self.noOfDataSend.text isEqualToString:@"2" ]) {
//        self.noOfDataSend.text=@"Connected";
//    }else
//    {
//    
//        self.noOfDataSend.text=@"Not Connected";
//
//    }
    
}
- (IBAction)instructions:(id)sender {
    
    InstructionsViewController *inst=[[InstructionsViewController alloc]initWithNibName:@"Instructions" bundle:nil];
    [self presentViewController:inst animated:YES completion:nil];
   
    
}
@end
