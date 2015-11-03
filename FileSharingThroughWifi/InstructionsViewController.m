//
//  InstructionsViewController.m
//  FileSharingThroughWifi
//
//  Created by wflogin on 11/3/15.
//  Copyright © 2015 wflogin. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"zbar"
                                                                  ofType:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:soundFilePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    
    
    UITextView * textView =[[UITextView alloc]initWithFrame:CGRectMake(0,100, self.vieww.frame.size.width, self.vieww.frame.size.height)];
    
    textView.userInteractionEnabled=NO;
    textView.text=content;
    
   
    [self.vieww  addSubview:textView];
   
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
