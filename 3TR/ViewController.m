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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.originalCoordinate = true;

    self.xLabel.textColor =[UIColor whiteColor];
    self.xLabel.backgroundColor=[UIColor blueColor];
    self.playAgainBtn.enabled = FALSE;
    [self.playAgainBtn setTitle:@"" forState:UIControlStateDisabled];
    self.playAgainBtn.titleLabel.text = @"hello";

    self.oLabel.textColor =[UIColor whiteColor];

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
    CGPoint point = [gesture locationInView:self.view];
    UILabel* searchLabel = [self findLabelUsingPoint:point];
    [self checkTurnAndSetLabel:searchLabel];
}

-(void)checkTurnAndSetLabel:(UILabel*) searchLabel{

    if (!self.win && !self.turn && searchLabel)
    {
        [self markLabelBlue:searchLabel];
        [self changeMatrixValueForPlayer:self.playerOne atIndex:self.myLabelsIndex];

        if (!self.win && self.turnCount!=9)
            [self setwhichPlayerLabel:self.turn];

        else if (self.turnCount!=9)
        {
            self.whichPlayerLabel.text = @"X wins";
            [self setAlertXWins];
              self.playAgainBtn.enabled = TRUE;
        }
        else
        {
            self.whichPlayerLabel.text = @"TIE";
            self.whichPlayerLabel.textColor = [UIColor greenColor];
            self.playAgainBtn.enabled = TRUE;

            [self setAlertGameOver];
        }

    }
    else if (!self.win && self.turn && searchLabel)
    {
        [self markLabelRed:searchLabel];
        [self changeMatrixValueForPlayer:self.playerTwo atIndex:self.myLabelsIndex];

        if (!self.win)
            [self setwhichPlayerLabel:self.turn];
        else
        {
            self.whichPlayerLabel.text = @"O wins";
            self.playAgainBtn.enabled = TRUE;

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


//get an idex of corresponding label in the array
-(NSInteger)getMyLabelsIndex: (UILabel*)label
{
    NSInteger j;
    for (NSInteger i = 0; i < self.myLabels.count; i++)
    {
        if ([self.myLabels[i] isEqual:label])
        {
            j = i;
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
        if (threeInRow==3) {
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

- (IBAction)handlePanforX:(UIPanGestureRecognizer *)recognizer
{
    if (self.turn)

        [self handleMyPan:recognizer];

}

- (IBAction)handlePanForO:(UIPanGestureRecognizer *)recognizer
{
    if (!self.turn)

        [self handleMyPan:recognizer];
}

-(void)handleMyPan:(UIPanGestureRecognizer*)recognizer{

    if (self.originalCoordinate)
    {
        self.originalPosition = recognizer.view.center;

        self.originalCoordinate = false;
    }

    CGPoint translation = [recognizer translationInView:self.view];

    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint finalPoint = recognizer.view.center;
        UILabel* searchLabel = [self findLabelUsingPoint:finalPoint];
        [self checkTurnAndSetLabel:searchLabel];
        recognizer.view.center = self.originalPosition;
        self.originalCoordinate = true;
    }
}
@end
