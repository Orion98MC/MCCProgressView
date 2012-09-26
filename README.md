## Description

A Simple Customizable ProgressView UI Element with Animation (iOS)

![Examples](https://www.evernote.com/shard/s6/sh/e03cf6dd-9b01-45e3-b2b4-b29cd72c7c54/6534fd4eb162c99c39713a2a27405dbb/res/5f39423c-d665-4079-ae55-e053d7504718/skitch.png)


## Usage

Default

```objective-c
CGRect progressFrame = CGRectMake(0, 0, self.view.bounds.size.width, 20);

MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:progressFrame]autorelease];
  
[self.view addSubview:pv];
```
  
Stroke shadow

```objective-c
MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:progressFrame]autorelease];

[pv setStrokeShadow:CGSizeMake(0, 1) withColor:[UIColor blackColor] blur:0.8];

[self.view addSubview:pv];
```

Changing the colors

```objective-c
MCCProgressView *pv = [[[MCCProgressView alloc]initWithStrokeWidth:2.0 frame:progressFrame]autorelease];

pv.strokeColor = [UIColor redColor];
pv.progressColor = [UIColor greenColor];
pv.trackColor = [UIColor blackColor];
  
[self.view addSubview:pv];
```
  
Animating progress changes

```objective-c
pv.progress = 0.0; // Not animated
[pv setProgress:0.2 animated:YES];
```


## License terms

Copyright (c), 2012 Thierry Passeron

The MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.