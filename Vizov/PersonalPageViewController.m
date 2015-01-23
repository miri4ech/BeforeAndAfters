//
//  PersonalPageViewController.m
//  Vizov
//
//  Created by MiriKunisada on 1/22/15.
//  Copyright (c) 2015 Miri Kunisada. All rights reserved.
//

#import "PersonalPageViewController.h"

@interface PersonalPageViewController ()

@end

@implementation PersonalPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *viewtitle = [userDefault objectForKey:@"myTitle"];
    NSString *viewdetail = [userDefault objectForKey:@"myDetail"];
    
    
    self.settedTitle.text = viewtitle;
    NSLog(@"%@",viewdetail);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end