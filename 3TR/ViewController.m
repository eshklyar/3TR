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
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *oLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAgainBtn;
@property NSArray *myLabels;
@property NSMutableArray *remainingLabelsInGame;
@property BOOL turn;
@property BOOL win;

@property NSInteger myLabelsIndex;
@property NSMutableArray *gameMatrix;
@property NSInteger turnCount;
@property Player *playerOne;
@property Player *playerTwo;

@property NSArray *winningSets;

@property BOOL originalCoordinate;
@property CGPoint originalPosition;


//@property NSString *matrixStrings[3][3];

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.originalCoordinate = true;

    self.xLabel.textColor =[UIColor whiteColor];
    self.xLabel.backgroundColor=[UIColor blueColor];
    self.playAgainBtn.enabled = false;
//    self.xLabel.text =@"X";
//
    self.oLabel.textColor =[UIColor whiteColor];
//    self.oLabel.text =@"O";
     self.oLabel.backgroundColor=[UIColor redColor];

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

    self.myLabels = @[self.Label1, self.Label2, self.Label3, self.Label4, self.Label5, self.Label6,self.Label7, self.Label8, self.Label9];


#pragma Player
    //created two players and inited array property with bool faulse values
    self.playerOne = [Player new];
    self.playerOne.name =@"Player One";

    self.playerTwo = [Player new];
    self.playerTwo.name =@"Player Two";

    [self startTheGame];
}

-(void)startTheGame{

//    self.winLabel.enabled = FALSE;
//    self.winLabel.text =@"";

    self.remainingLabelsInGame = [NSMutableArray arrayWithArray:self.myLabels];

    self.turnCount=0;
    self.turn = TRUE;
    self.win = FALSE;
    [self setwhichPlayerLabel:self.turn];
    [self setLabelsNewGame];

    //init original matrix with bool NO values
    self.gameMatrix = [NSMutableArray new];
    [self matrixWithBoolNo:self.gameMatrix];
    [self setupPlayer:self.playerOne];
    [self setupPlayer:self.playerTwo];
}

-(void)setupPlayer:(Player*)player{
    player.matrix= [NSMutableArray arrayWithArray: self.gameMatrix];
}

//init the gameMatrix
-(NSMutableArray*)matrixWithBoolNo:(NSMutableArray*)array{
    for (int i=0; i<9; i++) {
        [array addObject:@NO];
    }
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
- (IBAction)onLabelTapped:(UITapGestureRecognizer *)gesture
{
//    get the point of tap from gesture recognizer
    CGPoint point = [gesture locationInView:self.view];
//    find label using findLabelUsingPoint method passing point as argument
    UILabel* searchLabel = [self findLabelUsingPoint:point];
//    self.turnCount++;
//    self.winLabel.enabled =TRUE;
//    self.winLabel.text =[NSString stringWithFormat:@"%ld", (long)self.turnCount];

//    check player turn and set label accordingly
    if (!self.win && !self.turn && searchLabel)
    {
        [self markLabelBlue:searchLabel];
        [self changeMatrixValueForPlayer:self.playerOne atIndex:self.myLabelsIndex];


        if (!self.win && self.turnCount!=9)
             [self setwhichPlayerLabel:self.turn];

        else if (self.turnCount!=9)
        {
//            NSLog(@"game over");
//            self.whichPlayerLabel.text = [self.playerOne.name stringByAppendingString:@" WINS"];
                self.whichPlayerLabel.text = @"X wins";
                [self setAlertXWins];
        }
        else
        {
            self.whichPlayerLabel.text = @"TIE";
            self.whichPlayerLabel.textColor = [UIColor greenColor];
            [self setAlertGameOver];
        }

    }
    else if (!self.win && self.turn && searchLabel)
    {
        [self markLabelRed:searchLabel];
        [self changeMatrixValueForPlayer:self.playerTwo atIndex:self.myLabelsIndex];

        if (!self.win) {
            [self setwhichPlayerLabel:self.turn];
        } else {
//            NSLog(@"game over");
//            self.whichPlayerLabel.text = [self.playerTwo.name stringByAppendingString:@" WINS"];
                      self.whichPlayerLabel.text = @"O wins";
            [self setAlertOWins];
        }
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
            self.myLabelsIndex = [self getMyLabelsIndex:tempLabel];
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


-(void)markLabelBlue:(UILabel*)label{
    label.textColor =[UIColor blueColor];
    label.text =@"X";
}

-(void)markLabelRed:(UILabel*)label{
    label.textColor =[UIColor redColor];
    label.text =@"O";
}
//-(void)SetTheGameEnd: (NSInteger)count{
//    [self.gameMatrix replaceObjectAtIndex:count withObject:@YES];
//    if (count > 9) {
////    if ([self.gameMatrix containsObject:@NO]) {
//        NSLog(@"game over");
//    }
//}

//get an idex of corresponding label in the array
-(NSInteger)getMyLabelsIndex: (UILabel*)label
{
    NSInteger j;
    for (NSInteger i = 0; i < self.myLabels.count; i++)
    {
        if ([self.myLabels[i] isEqual:label])
        {
            j = i;
//            return i;
            break;
        }
    }
 return j;
}


-(void)changeMatrixValueForPlayer:(Player*) player atIndex:(NSInteger) index{
    [player.matrix replaceObjectAtIndex:index withObject:@YES];
    [self comparePlayerMatrix:self.winningSets with: player];
}

-(void)comparePlayerMatrix: (NSArray*)winingArray with: (Player*) player
{
    //go thru each array in the array with array of winningSet
    for (int j=0; j<8; j++)
    {
        NSMutableArray* jArray = [NSMutableArray arrayWithArray:winingArray[j]];
        int threeInRow=0;

        for (int i=0; i<3; i++)
        {
            NSNumber *num = [jArray objectAtIndex:i];
            int position = [num intValue];

            if ([player.matrix[position] isEqualToNumber:[NSNumber numberWithBool:@YES]])
            {
                threeInRow++;
            }

        }
//        NSLog(@"three in row count %d", threeInRow);
        if (threeInRow==3) {
            NSLog(@"win!!!!!!!");
//            self.winLabel.enabled = TRUE;
//            self.winLabel.text = @"win!";
            self.win = TRUE;
            break;
        }
    }
}

- (IBAction)onPlayAgainBtnPressed:(id)sender {
    [self startTheGame];
}

-(void)setAlertGameOver{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"IT'S A TIE"
                                                                   message:@"play again?"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self startTheGame];
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                             }];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)setAlertXWins{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"X WINS!"
                                                                   message:@"play again?"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self startTheGame];
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                             }];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)setAlertOWins{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"O WINS"
                                                                   message:@"play again?"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self startTheGame];
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                             }];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
    {
    CGPoint translation = [recognizer translationInView:self.view];
    if (self.originalCoordinate)
    {
        if (CGRectContainsPoint(self.xLabel.frame, recognizer.view.center)) {
            self.originalPosition = recognizer.view.center;
            self.originalCoordinate = false;
        }
        else if (CGRectContainsPoint(self.oLabel.frame, recognizer.view.center)){
            self.originalPosition = recognizer.view.center;
            self.originalCoordinate = false;
        }
    }
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        recognizer.view.center = self.originalPosition;
        self.originalCoordinate = true;
    }

    
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return true;
//
//}

//- (IBAction)labelDragWithPanGesture:(UIPanGestureRecognizer *)panGesture {
//
//    CGPoint original = panGesture.view.center;
//    CGPoint originalX = self.xLabel.center;
//      NSLog(@"stateBegun %f %f", original.x , original.y);
//    NSLog(@"bla %f %f", originalX.x , originalX.y);
//
//
////     image1.center = [pan locationInView:image1.superview];
////    [self.view addGestureRecognizer:panGesture];
////    [self.xLabel addGestureRecognizer:panGesture];
//
////    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
//    [panGesture setMinimumNumberOfTouches:1];
//    [panGesture setMaximumNumberOfTouches:1];
////    [self.view addGestureRecognizer:panGesture];
//
////    [panRecognizer release];
//
//    CGPoint translatedPoint = [panGesture translationInView:self.view];
//
////    if (CGRectContainsPoint(self.xLabel.frame, translatedPoint ) {
////        cga
////    }
////    NSLog(@"translatedPoint %@", NSStringFromCGPoint (translatedPoint));
//
////    CGPoint original =panGesture.view.center;
//
//    panGesture.view.center = CGPointMake(panGesture.view.center.x + translatedPoint.x,
//                                         panGesture.view.center.y + translatedPoint.y);
//
//    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
//    if ([panGesture state] == UIGestureRecognizerStateEnded) {
//
//        panGesture.view.center = CGPointMake(panGesture.view.center.x - translatedPoint.x,
//                                             panGesture.view.center.y - translatedPoint.y);
//        NSLog(@"stateEnded %f %f", original.x , original.y);
//    }

//testing
//    CGFloat firstX;
//    CGFloat firstY;
//
//    if ([panGesture state] == UIGestureRecognizerStateBegan) {
//        firstX = [[panGesture view] center].x;
//        firstY = [[panGesture view] center].y;
//    }
//
//    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
//    NSLog(@"translatedPoint 2 %@", NSStringFromCGPoint (translatedPoint));

//    [[panGesture view] setCenter:translatedPoint];

//    if ([panGesture state] == UIGestureRecognizerStateEnded) {
//
//
//
//        CGPoint velocity = [panGesture velocityInView:self.view];
//        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//        CGFloat slideMult = magnitude / 200;
//        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//
//        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
//        CGPoint finalPoint = CGPointMake(panGesture.view.center.x + (velocity.x * slideFactor),
//                                         panGesture.view.center.y + (velocity.y * slideFactor));
//        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
//        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
//
//        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            panGesture.view.center = finalPoint;
//        } completion:nil];
//


//
//        CGFloat velocityX = (0.2*[panGesture velocityInView:self.view].x);
//        NSLog(@"velocityX  %f", velocityX);
//
//
//
//        CGFloat finalX = translatedPoint.x + velocityX;
//        CGFloat finalY = firstY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
//        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
//
//        NSLog(@"the duration is: %f", animationDuration);
//
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
////        [UIView setAnimationDelegate:self];
////        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//        [[panGesture view] setCenter:CGPointMake(finalX, finalY)];
//        [UIView commitAnimations];

//    }
//}
@end
