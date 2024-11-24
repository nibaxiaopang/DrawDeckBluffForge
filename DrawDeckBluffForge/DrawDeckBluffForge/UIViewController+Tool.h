//
//  UIViewController+Tool.h
//  DrawDeckBluffForge
//
//  Created by jin fu on 2024/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Tool)
- (BOOL)bluffNeedShowAdsBann;

- (NSString *)bluffMainHostURL;

- (void)bluffShowBannersView:(NSString *)adurl;
@end

NS_ASSUME_NONNULL_END
