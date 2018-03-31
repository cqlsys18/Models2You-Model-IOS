//
//  PhotoCell.m
//  Models2You-Model
//
//  Created by user on 11/5/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (IBAction)actionRemove:(id)sender {
    
    [self.delegate actionRemove:self];
}

- (IBAction)actionCheckUncheck:(id)sender {
    
    [self.delegate actionCheckUncheck:self];
}

@end
