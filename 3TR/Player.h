//
//  Player.h
//  3TR
//
//  Created by Edik Shklyar on 3/29/15.
//  Copyright (c) 2015 Edik Shklyar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Player : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSMutableArray *matrix;
@property UIColor *color;

//- (id)initWithName:(NSString*)newName;
//- (id)initWithMatrix;



@end
