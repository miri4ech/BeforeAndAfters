//
//  MyEventsTableViewCell.h
//  Vizov
//
//  Created by MiriKunisada on 2/8/15.
//  Copyright (c) 2015 Miri Kunisada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyEventsTableViewCell : UITableViewCell

- (void)setData:(NSMutableArray *)eventDaysArySet;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end