//
//  LZAuthorityManager.m
//  MusicTest
//
//  Created by LZZ on 2021/2/3.
//  Copyright © 2021 CF. All rights reserved.
//

#import "LZAuthorityManager.h"
#import <Photos/Photos.h>

@implementation LZAuthorityManager


+ (void)cameraAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock{
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        deniedBlock();
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        handleBlock();
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted)
            {
                handleBlock();
                
            }
        }];
    }
}
+ (void)albumAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock{
   PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus==PHAuthorizationStatusRestricted || photoAuthorStatus==PHAuthorizationStatusDenied) {
        deniedBlock();
    }else if(photoAuthorStatus==PHAuthorizationStatusAuthorized){
        handleBlock();
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                handleBlock();
            }
        }];
    }
}
+ (void)microPhoneAuthority:(void (^)(void))handleBlock denied:(void (^)(void))deniedBlock{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        deniedBlock();
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        handleBlock();
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
            if (granted)
            {
                handleBlock();
                
            }
        }];
    }

}

@end
