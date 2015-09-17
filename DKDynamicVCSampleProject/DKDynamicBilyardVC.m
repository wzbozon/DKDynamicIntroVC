//
//  DKDynamicBilyardVC.m
//  DKDynamicVCSampleProject
//
//  Created by Dennis Kutlubaev on 16.09.15.
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2015 Dennis Kutlubaev (kutlubaev.denis@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DKDynamicBilyardVC.h"


static const CGFloat ThrowingThreshold = 10;
static const CGFloat ThrowingvelocityPadding = 140;



@interface DKDynamicBilyardVC () <UICollisionBehaviorDelegate>
{
    UIDynamicAnimator *_animator;
    UICollisionBehavior *_collision;
}

@property (nonatomic) UIView *separateBall;

@end



@implementation DKDynamicBilyardVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect internalViewRect = CGRectInset(self.view.bounds, 20, 100);
    UIView *internalView = [[UIView alloc] initWithFrame:internalViewRect];
    internalView.backgroundColor = [UIColor greenColor];
    internalView.layer.borderWidth = 3.0;
    internalView.layer.borderColor = [UIColor blackColor].CGColor;
    internalView.layer.cornerRadius = 30;
    [self.view addSubview:internalView];
    
    NSMutableArray *ballsArray = [NSMutableArray new];
    
    int ballNumber = 1;
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(120 + 40 * i, 100 + 40 * j, 40, 40)];
            ball.layer.cornerRadius = 20;
            ball.backgroundColor = [UIColor blueColor];
            UILabel *ballLabel = [[UILabel alloc] initWithFrame:ball.bounds];
            ballLabel.backgroundColor = [UIColor clearColor];
            ballLabel.textColor = [UIColor whiteColor];
            ballLabel.font = [UIFont boldSystemFontOfSize:17];
            ballLabel.textAlignment = NSTextAlignmentCenter;
            ballLabel.text = [NSString stringWithFormat:@"%d", ballNumber];
            [ball addSubview:ballLabel];
            [internalView addSubview:ball];
            [ballsArray addObject:ball];
            ballNumber ++;
        }
    }
    
    _separateBall = [[UIView alloc] initWithFrame:CGRectMake(150, 500, 40, 40)];
    _separateBall.layer.cornerRadius = 20;
    _separateBall.backgroundColor = [UIColor blueColor];
    
    UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_separateBall addGestureRecognizer:gr];
    
    UILabel *ballLabel = [[UILabel alloc] initWithFrame:_separateBall.bounds];
    ballLabel.backgroundColor = [UIColor clearColor];
    ballLabel.textColor = [UIColor whiteColor];
    ballLabel.font = [UIFont boldSystemFontOfSize:17];
    ballLabel.textAlignment = NSTextAlignmentCenter;
    ballLabel.text = [NSString stringWithFormat:@"%d", ballNumber];
    [_separateBall addSubview:ballLabel];
    [internalView addSubview:_separateBall];
    [ballsArray addObject:_separateBall];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:internalView];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:ballsArray];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    _collision.collisionMode = UICollisionBehaviorModeEverything;
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:ballsArray];
    itemBehaviour.elasticity = 0.5;
    itemBehaviour.resistance = 0.5;
    itemBehaviour.friction = 0.5;
    [_animator addBehavior:itemBehaviour];
}


- (void) handleGesture:(UIPanGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            break;
            
        }
        case UIGestureRecognizerStateEnded: {
            
            CGPoint velocity = [gesture velocityInView:self.view];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            
            if (magnitude > ThrowingThreshold) {
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                initWithItems:@[self.separateBall]
                                                mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                pushBehavior.magnitude = magnitude / ThrowingvelocityPadding;

                [_animator addBehavior:pushBehavior];
                
            }

            break;
        }
        default:
            
            break;
    }
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //NSLog(@"Boundary contact occurred - %@", identifier);
}


- (IBAction)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
