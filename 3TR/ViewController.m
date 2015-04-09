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
@property NSMutableArray *remainingLabelsInGame;
@property BOOL turn;
@property NSInteger myLabelsIndex;
@property NSMutableArray *gameMatrix;
@property NSInteger turnCount;
@property Player *playerOne;
@property Player *playerTwo;

@property NSMutableArray *winningSets;


//@property NSString *matrixStrings[3][3];

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    load 8 winning combinations into winningSets array with arrays, each array corespond to a a winning row/colum/diagonal line
    self.winningSets = @[
                                            @[ @0, @1, @2],
                                            @[ @3, @4, @5],
                                            @[ @6, @7, @8],

                                            @[ @0, @3, @6],
                                            @[ @1, @4, @7],
                                            @[ @2, @5, @8],

                                            @[ @0, @4, @8],
                                            @[ @2, @4, @6],

                                            ];


//    self.matrix = @[
//                    @[ @"", @"", @""],
//                    @[ @"", @"", @""],
//                    @[ @"", @"", @""],
//                    ];

//    self.myLabelsIndex = 0;
    self.myLabels = @[self.Label1, self.Label2, self.Label3, self.Label4, self.Label5, self.Label6,self.Label7, self.Label8, self.Label9];
    self.remainingLabelsInGame = [NSMutableArray arrayWithArray:self.myLabels];

    self.turnCount=0;
    self.turn = TRUE;

    [self setwhichPlayerLabel:self.turn];

    [self setLabelsNewGame];


//init original matrix with bool NO values
    self.gameMatrix = [NSMutableArray new];
    [self matrixWithBoolNo:self.gameMatrix];

#pragma Player
    //created two players and inited array property with bool faulse values
    self.playerOne = [Player new];
    self.playerOne.name =@"playerOne";
//    need to figure out how to init with bool in Player Class
    self.playerOne.matrix = [NSMutableArray arrayWithArray: self.gameMatrix];

    self.playerTwo = [Player new];
    self.playerTwo.name =@"playerTwo";
    self.playerTwo.matrix = [NSMutableArray arrayWithArray: self.gameMatrix];
}

//init the gameMatrix
-(NSMutableArray*)matrixWithBoolNo:(NSMutableArray*)array{
    for (int i=0; i<9; i++) {
//      [self.tempMatrix addObject:[NSNumber numberWithBool:NO]];
        [array addObject:@NO];
    }
    NSLog(@"matrixwithboolNO %@", array);
    return array;
}


//set labels background color
-(void)setLabelsNewGame {
    for (UILabel *label in self.myLabels) {
            label.text =@"";
            label.backgroundColor =[UIColor grayColor];
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
        NSLog(@"my myLabelsIndex is %ld", self.myLabelsIndex);
        
        [self changeMatrixValueForPlayer:self.playerOne atIndex:self.myLabelsIndex];

        NSLog(@"player index mylabelsIndex %ld", (long)self.myLabelsIndex);

        NSLog(@"player index value 1 %@", self.playerOne.matrix[self.myLabelsIndex]);

//        self.turn = FALSE;
        [self setwhichPlayerLabel:self.turn];
    }
    else if (self.turn && searchLabel)
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

//this method is called from onLabelTapped()
//return a selected label
//sets myLabelsIndex - index of a selected label
//removes selected label from the list
//increments turn count and changes turn

- (UILabel*) findLabelUsingPoint: (CGPoint)point  {
    for (UILabel* tempLabel in self.remainingLabelsInGame)
    {
        if(CGRectContainsPoint(tempLabel.frame, point))
        {
//get and index of the selected label in myLabels array
            self.myLabelsIndex =[self getMyLabelsIndex:tempLabel];
            NSLog(@"myLabelsIndex inside findLabelUsingPoint is %ld", (long)self.myLabelsIndex);

//remove marked label from the array
            [self.remainingLabelsInGame removeObjectIdenticalTo:tempLabel];
//            [self SetTheGameEnd:self.turnCount];
            self.turnCount++;
            if (self.turn) {
                self.turn = FALSE;
            }
            else{
                self.turn = TRUE;
            }
        return tempLabel;
        }
    }
    return nil;
}
-(void)SetTheGameEnd: (NSInteger)count{

    [self.gameMatrix replaceObjectAtIndex:count withObject:@YES];

    if (count >= 8) {
//    if ([self.gameMatrix containsObject:@NO]) {

        NSLog(@"game over");
    }

}

//get an idex of corresponding label in the array
-(NSInteger)getMyLabelsIndex: (UILabel*)label{
for (int i=0; i<9; i++)
    {
//    if ([self.myLabels containsObject:label])
        if ([self.myLabels[i] isEqual:label]) {
             NSLog(@"the getMyLabelsIndex index is %d", i);
            return i;
            NSLog(@"getMyLabelsIndex is %d",i);
        }
    {
//        self.myLabelsIndex = i;
//        NSLog(@"the index is %d", i);
//        return i;
    }
}
    return nil;
}





-(void)changeMatrixValueForPlayer:(Player*) player atIndex:(NSInteger) index{
//    player.matrix[index] = @YES;
    NSLog(@"changeMatrixValueForPlayer 've been called");
    [player.matrix replaceObjectAtIndex:index withObject:@YES];
    [self comparePlayerMatrix:self.winningSets with: player];

}

-(void)comparePlayerMatrix: (NSMutableArray*)winingArray with: (Player*) player
{
    NSLog(@"my player %@", player);

    //go thru each array in the array with array of winningSet
    for (int j=0; j<8; j++)
    {
        NSMutableArray* jArray = [NSMutableArray arrayWithArray:winingArray[j]];

        int threeInRow=0;

        for (int i=0; i<3; i++)
        {
            NSNumber *num = [jArray objectAtIndex:i];
            int position = [num intValue];

            NSLog(@"[player.matrix[position] %@", player.matrix[position]);


            //            NSLog(@"i is %d", i);
            //            int position = [NSNumber numberWithInteger: [jArray objectAtIndex:i] ];
            //            NSLog(@"bla %@", [jArray objectAtIndex:i] );

            //            NSLog(@"position again is %d", position);
            //            NSLog(@"jarray at i is %@", [jArray objectAtIndex:i]);
            //            NSLog(@"position is %d", position);
            //            NSLog(@"testing testing bool %s", [player.matrix objectAtIndex:i] ? "true" : "false");
            //            NSLog(@"testing testing bool %@ %d", [player.matrix objectAtIndex:i], i);

            //            NSLog(@"player at 2 %@", player.matrix[2]);

            //            NSLog(@"position is %d", position);
            //            NSLog(@"[player.matrix objectAtIndex:position] %@",[player.matrix objectAtIndex:position] );
            if ([player.matrix[position] isEqualToNumber:[NSNumber numberWithBool:@YES]])

                //            if ([[player.matrix objectAtIndex: [jArray objectAtIndex:i]] isEqualToNumber:[NSNumber numberWithBool:@YES]])
            {
                //                NSLog(@"win!!!!!!!%@ %ld", [player.matrix objectAtIndex:position],(long)position);
                threeInRow++;
                NSLog(@"incrementing 3inRow, %d", threeInRow);
                
            }
            else{
                NSLog(@"no match");
                 NSLog(@"3inRow, %d", threeInRow);
            }
        }
        if (threeInRow==3) {
            NSLog(@"win!!!!!!!");
//            self.whichPlayerLabel.text =
        }
    }
}

//-(void)comaprePlayerMAtrix: (NSMutableArray*) array{
//    BOOL winning = @NO;
//    if ( [[array objectAtIndex:0] isEqualToNumber:[NSNumber numberWithBool: @"YES"]] )
//    {
//        NSLog(@"YES");
//    }


//}
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

@end
