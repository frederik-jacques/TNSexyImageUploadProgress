TNSexyImageUploadProgress
=========================
An image upload progress component for Objective-C
----------------------------------------------------

![TNSexyImageUploadProgress](http://cl.ly/VCxa/TNSexyImageUploadProgress.PNG)

Installation
============

## Manual
* Just drag the files in the src folder to your project.
* Import the class

## CocoaPods
* Add ``` pod 'TNSexyImageUploadProgress' ``` to your Podfile
* Done

How to use?
===========

* Import the ```TNSexyImageUploadProgress.h``` file.
* Create an instance of the class
* Call the ``` show ``` method
* Update the progress by setting the ``` progress ``` property (when you are working with different threads, you should do this on the main thread!)

For example:

    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageUploadProgress.progress = progress.fractionCompleted;
    });
        

* Done!

For example

    self.imageUploadProgress = [[TNSexyImageUploadProgress alloc] init];
    [self.imageUploadProgress show];
       

Customise the component
=======================
If you want you can customise how the component looks.
You can set the following properties:

Property  | What does it do
 ------------- | ------------- 
 progress    | Set how far the circle has to be drawn (value between 0.0 and 1.0)
 radius    | Set the radius for the circular image mask
 progressBorderThickness    | Set the thickness of the border
 trackColor    | Set the color for the track
 progressColor    | Set the color for the progress
 showOverlay    | Set if you want the component to show an overlay
 
For example
  
    self.imageUploadProgress = [[TNSexyImageUploadProgress alloc] init];
    self.imageUploadProgress.radius = 100;
    self.imageUploadProgress.progressBorderThickness = -10;
    self.imageUploadProgress.trackColor = [UIColor blackColor];
    self.imageUploadProgress.progressColor = [UIColor whiteColor];
    self.imageUploadProgress.imageToUpload = selectedImage;
    [self.imageUploadProgress show];

Video
=====
<iframe title="TNSexyImageUploadProgress video" width="320" height="568" src="http://cl.ly/VE1F/TNSexyImageUpload.mov" frameborder="0" allowfullscreen>< /iframe>

Demo
=====
There is a demo project added to this repository, so you can see how it works.
In the folder 'webservice', you can find a PHP script to upload pictures.  Just put it in your document directory and set the correct path in MainViewController.

License
=======
TNRadioButtonGroup published under the MIT license:

Copyright (C) 2014, Frederik Jacques

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 