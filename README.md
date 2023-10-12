# Image Comparator
The **Image Comparator** is a powerful Flutter package designed for creating interactive image comparison views with ease. This package allows you to effortlessly compare two images by providing a draggable control point that can be customized to suit your application's design. You can use it for various use cases, such as showcasing before-and-after images, highlighting differences, or demonstrating the impact of changes.

<img src="https://github.com/waihanko/image_comparator/assets/37291373/8e7dd54d-f64e-4df3-98b4-69ff5412aed3" width="300" height="580">

## Usage

```
ImageComparator(
                  width: 300,
                  height: 300,
                  image1: Image.asset("assets/images/before.jpg", fit: BoxFit.cover,),
                  image2: Image.asset("assets/images/after.jpg", fit: BoxFit.cover,),
                  controlLineWidth: 2,
                  controlLineColor: Colors.white,
                  controlThumb: const Icon(Icons.circle, color: Colors.white,),
                  controlHorizontalOffset: 0.8,
                  controlVerticalOffset: 0.5,
                )
      
```


## Parameters

| Parameter                | Type    | Description                                                                         |
|--------------------------|---------|-------------------------------------------------------------------------------------|
| `image1`                 | Widget  | The first image for comparison.                                                    |
| `image2`                 | Widget  | The second image for comparison.                                                   |
| `controlThumb`             | Widget  | The style for the control point. Customize the appearance of the control point using a widget. |
| `controlLineWidth`       | double  | The width of the control line.                                                     |
| `controlLineColor`       | Color   | The color of the control line.                                                    |
| `controlHorizontalOffset` | double  | The initial position of the control point. It should be between `0.0`   and `1.0` |
| `controlVerticalOffset`    | double  | The position offset for the control point. It should be between `0.0` and `1.0`  |

**Note:** If you don't provide `width` and `height`, you should wrap the widget with `Expanded`. Keep in mind that the `width` and `height` parameters only allow specific dimensions.

