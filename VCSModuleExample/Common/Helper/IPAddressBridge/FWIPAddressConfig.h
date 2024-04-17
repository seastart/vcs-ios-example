//
//  FWIPAddressConfig.h
//  VCSModuleExample
//
//  Created by SailorGa on 2024/4/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <net/ethernet.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

NS_ASSUME_NONNULL_BEGIN

#define BUFFERSIZE  4000
#define MAXADDRS    32
#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

@interface FWIPAddressConfig : NSObject

/// extern
extern char * _Nonnull if_names[MAXADDRS];
extern char * _Nonnull ip_names[MAXADDRS];
extern char * _Nonnull hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

/// Function prototypes
void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

@end

NS_ASSUME_NONNULL_END
