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



@interface DKDynamicBilyardVC () <UICollisionBehaviorDelegate>
{
    UIDynamicAnimator *_animator;
    UICollisionBehavior *_collision;
}
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
    
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 4; j ++) {
            UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(50 + 40 * i, 50 + 40 * j, 40, 40)];
            ball.layer.cornerRadius = 20;
            ball.backgroundColor = [UIColor blueColor];
            [internalView addSubview:ball];
            [ballsArray addObject:ball];
        }
    }
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:internalView];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:ballsArray];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:ballsArray];
    itemBehaviour.elasticity = 0.95;
    itemBehaviour.resistance = 0.0;
    [_animator addBehavior:itemBehaviour];
    
    for (UIView *ball in ballsArray) {
        [itemBehaviour addLinearVelocity:CGPointMake(300, 300) forItem:ball];
    }
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSLog(@"Boundary contact occurred - %@", identifier);
}


- (IBAction)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
