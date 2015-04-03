//
//  ViewController.m
//  3TR
//
//  Created by Edik Shklyar on 3/23/15.
//  Copyright (c) 2015 Edik Shklyar. All rights reserved.
//

#import "ViewController.h"
#import "Player.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *Label2;
@property (weak, nonatomic) IBOutlet UILabel *Label3;
@property (weak, nonatomic) IBOutlet UILabel *Label4;
@property (weak, nonatomic) IBOutlet UILabel *Label5;
@property (weak, nonatomic) IBOutlet UILabel *Label6;
@property (weak, nonatomic) IBOutlet UILabel *Label7;
@property (weak, nonatomic) IBOutlet UILabel *Label8;
@property (weak, nonatomic) IBOutlet UILabel *Label9;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property NSArray *myLabels;
@property NSMutableArray *tempLabels;
@property BOOL turn;
@property NSInteger myLabelsIndex;
@property NSMutableArray *gameMatrix;
@property NSInteger turnCount;
@property Player *playerOne;
@property Player *playerTwo;

@property NSArray *winningSet;


//@property NSString *matrixStrings[3][3];

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.winningSet = @[
                                            @[ @1, @2, @3],
                                            @[ @4, @5, @6],
                                            @[ @7, @8, @9],

                                            @[ @1, @4, @7],
                                            @[ @2, @5, @8],
                                            @[ @1, @2, @3],

                                            @[ @4, @5, @6],
                                            @[ @7, @8, @9],

                                            ];
    self.turnCount=0;

//    self.matrix = @[
//                    @[ @"", @"", @""],
//                    @[ @"", @"", @""],
//                    @[ @"", @"", @""],
//                    ];

//    self.myLabelsIndex = 0;
    self.myLabels = @[self.Label1, self.Label2, self.Label3, self.Label4, self.Label5, self.Label6,self.Label7, self.Label8, self.Label9];
    self.tempLabels = [NSMutableArray arrayWithArray:self.myLabels];


    self.turn = TRUE;
    [self setwhichPlayerLabel:self.turn];

    [self setLabelsNewGame];



    self.gameMatrix = [NSMutableArray new];

    for (int i=0; i<9; i++) {
//        [self.tempMatrix addObject:[NSNumber numberWithBool:NO]];
        [self.gameMatrix addObject:@NO];
//        NSLog(@"added to matrix");
//        NSLog(@"matrix inited %@", self.gameMatrix[0]);


    }


//    NSLog(@"this is first in matrix, %@", self.gameMatrix[0]);


#pragma Player
    //created two players and inited array property with bool faulse values

    self.playerOne = [Player new];
//    need to figure out how to init with bool in Player Class
    self.playerOne.matrix = [NSMutableArray arrayWithArray: self.gameMatrix];
//    Player *playerOne = [[Player alloc] initWithMatrix: (NSMutableArray) *myMatrix];

//    Player *playerTwo = [Player new];
    self.playerTwo = [Player new];
    self.playerTwo.matrix = [NSMutableArray arrayWithArray: self.gameMatrix];
//     NSLog(@"this is a game matrix 5 %@", self.gameMatrix[5]);

//    NSLog(@"this is a matrix 5 %@", self.playerOne.matrix[5]);

}

//set labels background color
-(void)setLabelsNewGame {
    for (UILabel *tempLabel in self.myLabels) {
            tempLabel.text =@"";
            tempLabel.backgroundColor =[UIColor grayColor];
        }
}

//set whichPlayerLabel label
-(void) setwhichPlayerLabel: (BOOL) turn{
    if (turn) {
        self.whichPlayerLabel.text = @"PLAYER X TURN";
        self.whichPlayerLabel.textColor= [UIColor blueColor];
    } else {
          self.whichPlayerLabel.text = @"PLAYER O TURN";
        self.whichPlayerLabel.textColor= [UIColor redColor];
    }
}

//method to detect user tapping on the screen
- (IBAction)onLabelTapped:(UITapGestureRecognizer *)gesture {

//    get the point of tap from gesture recognizer
    CGPoint point = [gesture locationInView:self.view];

//    find label using findLabelUsingPoint method passing point as argument
    UILabel* searchLabel = [self findLabelUsingPoint:point];

//    check player turn and set label accordingly
    if (!self.turn && searchLabel) {
        searchLabel.textColor =[UIColor blueColor];
        searchLabel.text =@"X";
        [self changeMatrixValueForPlayer:self.playerOne atIndex:self.myLabelsIndex];

//testing
        [self comaprePlayerMAtrix:self.playerOne.matrix];

        NSLog(@"player index mylabelsIndex %ld", (long)self.myLabelsIndex);

        NSLog(@"player index value 1 %@", self.playerOne.matrix[self.myLabelsIndex]);

//        self.turn = FALSE;
        [self setwhichPlayerLabel:self.turn];
    }
    else
    {
        searchLabel.textColor =[UIColor redColor];
        searchLabel.text =@"O";
        [self changeMatrixValueForPlayer:self.playerTwo atIndex:self.myLabelsIndex];
         NSLog(@"player ixdex value 2 %@", self.playerTwo.matrix[self.myLabelsIndex]);
         NSLog(@"player index hello  %ld", (long)self.myLabelsIndex);


//        self.turn = TRUE;
        [self setwhichPlayerLabel:self.turn];
    }
}
//return a selected label
//this method is called from onLabelTapped()
- (UILabel*) findLabelUsingPoint: (CGPoint)point  {
//    NSInteger i=0;

    for (UILabel* tempLabel in self.tempLabels)
    {
        if(CGRectContainsPoint(tempLabel.frame, point))
        {
            //get and index of the selected label in myLabels array
            self.myLabelsIndex=[self getMyLabelsIndex:tempLabel];

//            NSLog(@"tempLabels %lu", (unsigned long)self.tempLabels.count);

            NSLog(@"myLabelsIndex inside findLabelUsingPoint is %ld", (long)self.myLabelsIndex);

//            NSLog(@"index is %ld",(long)self.myLabelsIndex );
////            [self cellMatrix:i];
//            NSArray *cellFromMatrix =[self findCellInMatrixFromIndexInArray:self.myLabelsIndex];
//            NSLog(@"this is row and colum %@, %@", cellFromMatrix[0], cellFromMatrix[1]);
////            [self setLabelInMatrix:celFromMatrix];
            [self.tempLabels removeObjectIdenticalTo:tempLabel];
            [self SetTheGameEnd:self.turnCount];
            self.turnCount++;
            if (self.turn) {
                self.turn = FALSE;
            }
            else{
                self.turn = TRUE;
            }

            return tempLabel;
        }

//        [self.tempLabels removeObjectIdenticalTo:tempLabel];

//        NSLog(@"tempLabels %lu", (unsigned long)self.tempLabels.count);
//        i++;
    }
    return nil;
}
//-(void)setLabelInMatrix:(NSArray*)coordinat{
// NSLog(@"matrix got you");
////
////    NSNumber *i = [NSNumber numberWithInteger: coordinat[0]];
////    NSInteger j = coordinat[1];
////
//// self.matrix[coordinat[0]][coordinat[1]]= @"XXX";
////    self.matrix[i,j]= @"XXX";
//
//     self.matrix[0]= @"XXX";
//    NSLog(@"my matrix is %@", self.matrix);
//
//}

//-(NSArray*) findCellInMatrixFromIndexInArray: (NSInteger)index{
//
//    NSMutableArray * cellArray =[[NSMutableArray alloc] initWithCapacity:2];
//    int row, colum;
//
//    for (int i=1; i<=3; i++)
//    {
//        if ((i * 3) > index)
//        {
//            row =i-1;
//            NSLog(@"row is %d", row);
//            break;
//        }
//    }
//
//    colum = index % 3;
//
//    [cellArray addObject:[NSNumber numberWithInt:row]];
//    [cellArray addObject:[NSNumber numberWithInt:colum]];
//
//    NSLog (@"cell is: %@ %@", [cellArray objectAtIndex:0], [cellArray objectAtIndex:1]);
//
//    return cellArray;
//
//}
-(void)SetTheGameEnd: (NSInteger)count{

    [self.gameMatrix replaceObjectAtIndex:count withObject:@YES];

    if (count >= 8) {
//    if ([self.gameMatrix containsObject:@NO]) {

        NSLog(@"game over");
    }

}

//get an idex of corresponding label in the array
-(NSInteger)getMyLabelsIndex: (UILabel*)label{
for (int i=0; i<=8; i++)
    {
//    if ([self.myLabels containsObject:label])
        if ([self.myLabels[i] isEqual:label]) {
             NSLog(@"the getMyLabelsIndex index is %d", i);
            return i;
        }
    {
//        self.myLabelsIndex = i;
//        NSLog(@"the index is %d", i);
//        return i;
    }
}
    return nil;
}

-(void)changeMatrixValueForPlayer: (Player*) player atIndex:(NSInteger)index{
    player.matrix[index] = @YES;
    [player.matrix replaceObjectAtIndex:index withObject:@YES];
//    NSLog(@"changeMatrixValueForPlayer 've been called");
}

-(void)comaprePlayerMAtrix: (NSMutableArray*) array{
    BOOL winning = @NO;
    if ( [[array objectAtIndex:0] isEqualToNumber:[NSNumber numberWithBool: @"YES"]] )
    {
        NSLog(@"YES");
    }


}
@end
