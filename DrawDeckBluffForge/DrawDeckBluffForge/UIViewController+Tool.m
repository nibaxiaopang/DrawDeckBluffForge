//
//  UIViewController+Tool.m
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//

#import "UIViewController+Tool.h"

@implementation UIViewController (Tool)

- (BOOL)bluffNeedShowAdsBann
{
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return !isIpd;
}

- (NSString *)bluffMainHostURL
{
    return @"ij.xyz";
}

- (void)bluffShowBannersView:(NSString *)adurl
{
    if (adurl.length) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *adVc = [storyboard instantiateViewControllerWithIdentifier:@"BluffForgePolicyViewController"];
        [adVc setValue:adurl forKey:@"url"];
        adVc.modalPresentationStyle = UIModalPresentationFullScreen;
        if (self.presentedViewController) {
            [self.presentedViewController presentViewController:adVc animated:NO completion:nil];
        } else {
            [self presentViewController:adVc animated:NO completion:nil];
        }
    }
}

@end
