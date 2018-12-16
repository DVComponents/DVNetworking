//
//  DVNetworkingDefines.h
//  DVNetworking
//
//  Created by David on 2018/11/30.
//  Copyright © 2018年 351723770@qq.com. All rights reserved.
//

#ifndef DVNetworkingDefines_h
#define DVNetworkingDefines_h

#import <UIKit/UIKit.h>


typedef NS_ENUM (NSUInteger, DVServiceAPIEnvironment){
    DVServiceAPIEnvironmentDevelop,
    DVServiceAPIEnvironmentReleaseCandidate,
    DVServiceAPIEnvironmentRelease
};


typedef NS_ENUM(NSUInteger,DVAPIManagerRequestType){
    DVAPIManagerRequestTypePost,
    DVAPIManagerRequestTypePostByForm,
    DVAPIManagerRequestTypeGet,
};

typedef NS_ENUM(NSUInteger,DVValidatorType){   /// <  Type of request
    DVAPIManagerErrorTypeNeedAccessToken,      /// < needAccess
    DVAPIManagerErrorTypeNeedLogin,            /// < no login
    DVAPIManagerErrorTypeDefault,              /// < default
    DVAPIManagerErrorTypeLoginCanceled,        /// < login but cancel
    DVAPIManagerErrorTypeSuccess,              /// < success
    DVAPIManagerErrorTypeNoContent,            /// < no content
    DVAPIManagerErrorTypeParamsError,          /// < params error,no request
    DVAPIManagerErrorTypeTimeout,              /// < time out
    DVAPIManagerErrorTypeNoNetWork,            /// < no network,no request
    DVAPIManagerErrorTypeCanceled,             /// < user cancel
    DVAPIManagerErrorTypeNoError,              /// < no error
    DVAPIManagerErrorTypeDownGrade,            /// < api downGrade
    DVAPIManagerErrorTypeUnexpectedResponse,   /// < unexpected
};

typedef NS_ENUM(NSUInteger,DVAPIManagerDomainType){
    DVAPIManagerDomainTypeValue1,
    DVAPIManagerDomainTypeValue2,
    DVAPIManagerDomainTypeValue3,
};

#endif /* DVNetworkingDefines_h */
