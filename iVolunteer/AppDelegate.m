//
//  AppDelegate.m
//  iVolunteer
//
//  Created by Marcus Vinicius Kuquert on 3/6/15.
//  Copyright (c) 2015 Marcus Vinicius Kuquert. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize Parse.
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"F0YDrtF7rSHBX0joO258KKKH6FLnB1jQkYzAUwNb"
                  clientKey:@"l23Yylcn1t6v43kYfBhch8bLVCQGK3GMK0hZ1ZoU"];
    [PFFacebookUtils initializeFacebook];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:103.0f/255.0f green:194.0f/255.0f blue:154.0f/255.0f alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:103.0f/255.0f green:194.0f/255.0f blue:154.0f/255.0f alpha:1]}];
    
    return YES;
}


// App switching methods to support Facebook Single Sign-On.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [[PFFacebookUtils session] close];
}
#warning TO-DO
/*
 -rever bug do teclado na tela de registro
 -bug do facebook
 -tela de description
 -alinhamento do botao do pin no mapa
 -rever logout
 -tableView com instituicoes
*/

@end
