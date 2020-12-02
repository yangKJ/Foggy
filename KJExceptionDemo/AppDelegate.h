//
//  AppDelegate.h
//  KJExceptionDemo
//
//  Created by 杨科军 on 2020/12/2.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

