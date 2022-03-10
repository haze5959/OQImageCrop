# OQImageCrop
* Simple image crop 
* scrolling, rotation, adjust image ratio and cut the image.

# Image
![sample](/sampleImage/img01.png)
![sample](/sampleImage/img02.png)
![sample](/sampleImage/img03.png)

# Usage
* adjust crop ratio
```objective-c
self.cropAspectRatio = 3.0f / 2.0f;   //3 : 2 ratio
```

* block-coding completion
```objective-c
OQCropViewController *controller = [OQCropViewController viewControllerWithImage:image cropAspectRatio:self.cropAspectRatio yesBlock:^(UIImage *resultImage) {
            //Image Crop Done!
} noBlock:^{
            //Image Crop Cancel
}];
```

# License
This content is released under the [MIT](http://opensource.org/licenses/MIT) License.
