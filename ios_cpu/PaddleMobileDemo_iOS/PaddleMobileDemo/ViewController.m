/* Copyright (c) 2018 PaddlePaddle Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */

#import "PaddleMobileCPU.h"
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) PaddleMobileCPU *paddleMobile;

@property (strong, nonatomic) UIImage *testImage;

@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) BOOL loaded;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.imageView.image = [UIImage imageNamed:@"apple.jpg"];
}

- (IBAction)loadAct:(id)sender {
    PaddleMobileCPUConfig *config = [[PaddleMobileCPUConfig alloc] init];
    config.threadNum = 1;
    config.loddable = YES;
    config.optimize = YES;

    self.paddleMobile = [[PaddleMobileCPU alloc] initWithConfig:config];
    
    NSString *mobilenetModel = [[NSBundle mainBundle] pathForResource:@"ssd_model" ofType:nil];
    
    NSString *mobilenetParams = [[NSBundle mainBundle] pathForResource:@"ssd_params" ofType:nil];
    
    self.loaded = [self.paddleMobile loadModel:mobilenetModel andWeightsPath:mobilenetParams];
}

- (IBAction)clearAct:(id)sender {
    [self.paddleMobile clear];
}

- (IBAction)predictAct:(id)sender {
    if (!self.loaded) {
        self.resultTextView.text = @" 还没有load, 需要 load ";
        return;
    }
    
    if (!self.imageView.image) {
        self.resultTextView.text = @" 图片为空 ";
        return;
    }
    
    int max = 1;
    NSDate *startDate = [NSDate date];
    for (int i = 0; i < max; ++i) {
        PaddleMobileCPUResult *res = [self.paddleMobile predict:self.imageView.image.CGImage dim:@[@(1), @(3), @(300), @(300)]];
        [res releaseOutput];
    }
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@" time - %f", t/max);
}

@end
