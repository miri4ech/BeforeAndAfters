//
//  AppDelegate.m
//  Vizov
//
//  Created by MiriKunisada on 1/16/15.
//  Copyright (c) 2015 Miri Kunisada. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()<FUIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //イベントの全データを取得
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSMutableArray *ary = [[usr objectForKey:@"challenges"]mutableCopy];
    
    //プッシュ許可の確認を表示
    UIUserNotificationType types =  UIUserNotificationTypeBadge|
    UIUserNotificationTypeSound|
    UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [application registerUserNotificationSettings:mySettings];

    
        //--------UserDefaultのデータを消したい時に使う------------------------
    
//        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//        [userDef removeObjectForKey:@"challenges"];
//        [userDef removeObjectForKey:@"maxId"];
//        [userDef removeObjectForKey:@"selectedPic"];
//        [userDef removeObjectForKey:@"selectedDic"];
//        [userDef removeObjectForKey:@"dailyPictures"];
//        //イベントごとに紐づく日付たち
//        [userDef removeObjectForKey:@"daysArray"];
    

    //-------終了日のものはsuccessに変わる処理---------

    //初期化
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    //日付のフォーマット指定
    df.dateFormat = @"yyyy/MM/dd";
    NSDate *today = [NSDate date];

    // 日付(NSDate) => 文字列(NSString)に変換
    NSString *strToday = [df stringFromDate:today];

    //todayの日付と一致するイベントを抽出
    for (NSDictionary *dict in [ary reverseObjectEnumerator]) {
        NSMutableDictionary *mDict = [dict mutableCopy];
        if ([[dict valueForKey:@"finDate"] isEqualToString:strToday] && ![[dict valueForKey:@"type"]isEqualToString:@"success"]) {
            
            //mutableCopyのdicのtypeを書き換え
            [mDict setObject:@"success" forKey:@"type"];
            
            //元のデータを削除
            [ary removeObject:dict];
            
            //書き換えたデータを保存
            [ary addObject:mDict];
            [usr setObject:ary forKey:@"challenges"];
            [usr synchronize];
        }
    }


    return YES;
    
    

    
}

// 通常、アプリケーションが起動中の場合はローカル通知は通知されないが、通知されるようにする
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if(notification) {
        FUIAlertView *alert = [[FUIAlertView alloc]
                              initWithTitle:@""
                              message:@"KEEP CHALLENGING!!"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        //デザイン
        alert.titleLabel.textColor = [UIColor cloudsColor];
        alert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        alert.messageLabel.textColor = [UIColor cloudsColor];
        alert.messageLabel.font = [UIFont flatFontOfSize:14];
        alert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        alert.defaultButtonColor = [UIColor cloudsColor];
        alert.defaultButtonShadowColor = [UIColor asbestosColor];
        alert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        alert.defaultButtonTitleColor = [UIColor asbestosColor];
        [alert show];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mirikunisada.Vizov" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vizov" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vizov.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
