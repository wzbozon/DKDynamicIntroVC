//
//  DynamicIntroViewController.m
//  DynamicIntroSampleProject
//
//  Created by Dennis Kutlubaev on 27.08.15.
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


#import "DKDynamicIntroVC.h"


@interface DKDynamicIntroVC () <UICollisionBehaviorDelegate>
{
    UIDynamicAnimator *_animator;
    UIGravityBehavior *_gravity;
    UICollisionBehavior *_collision;
    BOOL _firstContact;
    UITextView *_textView;
}
@end



@implementation DKDynamicIntroVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 0, 330, 85)];
    [_textView setText:@"SomeText"];
    [_textView setFont:[UIFont boldSystemFontOfSize:70]];
    [_textView setTextColor:[UIColor redColor]];
    _textView.backgroundColor = [UIColor clearColor];
    
    UIView *barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    UIView *blueBall = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    blueBall.layer.cornerRadius = 0;
    blueBall.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueBall];
    
    UIView *greenBall = [[UIView alloc] initWithFrame:CGRectMake(230, 100, 100, 100)];
    greenBall.layer.cornerRadius = 0;
    greenBall.backgroundColor = [UIColor blueColor];
    [self.view addSubview:greenBall];
    
    UIView *yellowBall = [[UIView alloc] initWithFrame:CGRectMake(170, 300, 100, 100)];
    yellowBall.layer.cornerRadius = 0;
    yellowBall.backgroundColor = [UIColor blueColor];
    [self.view addSubview:yellowBall];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[blueBall, greenBall, yellowBall]];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:@[blueBall, greenBall, yellowBall]];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    
    // add a boundary that coincides with the top edge
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
    [_collision addBoundaryWithIdentifier:@"barrier" fromPoint:barrier.frame.origin toPoint:rightEdge];
    
    /*_collision.action =  ^{
        NSLog(@"%@, %@",
              NSStringFromCGAffineTransform(square.transform),
              NSStringFromCGPoint(square.center));
    };*/
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[blueBall, greenBall, yellowBall]];
    itemBehaviour.elasticity = 0.8;
    [_animator addBehavior:itemBehaviour];
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSLog(@"Boundary contact occurred - %@", identifier);
    
    /*UIView *view = (UIView *)item;
    
    if ( ! [view isKindOfClass:[UITextView class]] ) {
        view.backgroundColor = [UIColor yellowColor];
        [UIView animateWithDuration:0.3 animations:^{
        
            view.backgroundColor = [UIColor blueColor];
        
        }];
    }*/
    
    if (!_firstContact)
    {
        _firstContact = YES;
        
        [self.view addSubview:_textView];
        
        [_collision addItem:_textView];
        [_gravity addItem:_textView];
        
        UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[_textView]];
        itemBehaviour.elasticity = 0.5;
        [_animator addBehavior:itemBehaviour];
        
        //UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:view attachedToItem:textView];
        //[_animator addBehavior:attach];
    }
}


- (IBAction)backClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
