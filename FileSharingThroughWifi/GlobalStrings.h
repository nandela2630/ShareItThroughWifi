//
//  GlobalStrings.h
//  FileSharingThroughWifi
//
//  Created by wflogin on 11/2/15.
//  Copyright © 2015 wflogin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalStrings : NSObject
{
NSString *videoPathString;
    BOOL recieveImgData;
}


@property (nonatomic, retain) NSString *videoPathString;
@property(nonatomic, assign)BOOL recieveImgData;
@end
