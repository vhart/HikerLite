//
//  GJEntry.m
//  GoJournal
//
//  Created by Varindra Hart on 10/13/15.
//  Copyright © 2015 Elber Carneiro. All rights reserved.
//

#import "GJEntry.h"

@implementation GJEntry

@dynamic file;
@dynamic mediaType;
@dynamic fileExt;
@dynamic location;
@dynamic textMedia;
@dynamic createdDate;

+ (NSString *) parseClassName{
    
    return @"GJEntry";
}

- (void)fileFromImage:(UIImage *)image{
    
    NSData *data = UIImageJPEGRepresentation(image, .8);

    self.file = [PFFile fileWithData:data];
    
}

- (void)fileFromVideoURL:(NSURL *)url{
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.file = [PFFile fileWithData:data contentType:@"video/mov"];
    
}

- (NSURL *)urlFromMediaFile{
    
    if (![self.mediaType isEqualToString: @"public.video"]) {
        return nil;
    }
    
    NSString *stringUrl = self.file.url;
    NSURL *url = [NSURL URLWithString:stringUrl];
    return url;
    
}
@end
