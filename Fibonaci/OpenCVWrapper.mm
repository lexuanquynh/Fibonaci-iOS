//
//  OpenCVWrapper.m
//  Fibonaci
//
//  Created by Le Xuan Quynh on 11/01/2023.
//

/*
#import "OpenCVWrapper.h"



@interface OpenCVWrapper() <CvVideoCameraDelegate>

@property (strong, nonatomic) CvVideoCamera *videoCamera;

@property (assign, nonatomic) cv::Mat logoSample;

// OpenCVWrapperDelegate
@property (weak, nonatomic) id<OpenCVWrapperDelegate> delegate;

@end

@implementation OpenCVWrapper

- (instancetype)initWithParentView:(UIImageView *)parentView delegate:(id<OpenCVWrapperDelegate>)delegate {
    if (self = [super init]) {

        self.delegate = delegate;



        parentView.contentMode = UIViewContentModeScaleAspectFill;



        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:parentView];

        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;

        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;

        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;

        self.videoCamera.defaultFPS = 30;

        self.videoCamera.grayscaleMode = [NSNumber numberWithInt:0].boolValue;

        self.videoCamera.delegate = self;



        // Convert UIImage to Mat and store greyscale version

        UIImage *templateImage = [UIImage imageNamed:@"sample"];

        cv::Mat templateMat;

        UIImageToMat(templateImage, templateMat);

        cv::Mat grayscaleMat;

        cv::cvtColor(templateMat, grayscaleMat, CV_RGB2GRAY);

        self.logoSample = grayscaleMat;



        [self.videoCamera start];

    }

    return self;

}

- (void)processImage:(cv::Mat&)image {



    cv::Mat gimg;



    // Convert incoming img to greyscale to match template

    cv::cvtColor(image, gimg, CV_BGR2GRAY);



    // Get matching

    cv::Mat res(image.rows-self.logoSample.rows+1, self.logoSample.cols-self.logoSample.cols+1, CV_32FC1);

    cv::matchTemplate(gimg, self.logoSample, res, CV_TM_CCOEFF_NORMED);

    cv::threshold(res, res, 0.5, 1., CV_THRESH_TOZERO);



    double minval, maxval, threshold = 0.9;

    cv::Point minloc, maxloc;

    cv::minMaxLoc(res, &minval, &maxval, &minloc, &maxloc);

    // Call delegate if match is good enough

    if (maxval >= threshold)
    {

        // Draw a rectangle for confirmation

        cv::rectangle(image, maxloc, cv::Point(maxloc.x + self.logoSample.cols, maxloc.y + self.logoSample.rows), CV_RGB(0,255,0), 2);

        cv::floodFill(res, maxloc, cv::Scalar(0), 0, cv::Scalar(.1), cv::Scalar(1.));

        [self.delegate openCVWrapperDidMatchImage:self];
    }
}


@end

*/
