# RBDrumz
By Rodrigo Sieiro - [@rsieiro](http://twitter.com/rsieiro)  
[http://rodrigo.sharpcube.com](http://rodrigo.sharpcube.com)

## About

**RBDrumz** is a simple project that allows you to use a XBOX 360 Rock Band Drumkit as a MIDI instrument. I wrote this a couple years ago when I was learning Objective-C (expect bad code) and never actually finished it (it works, but there's no user interface).

You'll need a [XBOX 360 Wireless Gaming Receiver](http://www.amazon.com/Wireless-Gaming-Receiver-Xbox-360/dp/B003WFYZCY/ref=sr_1_3?ie=UTF8&qid=1339455622&sr=8-3) and a Rock Band Drumkit (cymbals are optional, but highly recommended). You can also use a second pedal to open/close the hihat.

## Usage

1. Install the [XBox 360 Controller OSX Driver](http://tattiebogle.net/index.php/ProjectRoot/Xbox360Controller/OsxDriver).
2. Plug the receiver to your Mac.
3. Connect the drumkit and make sure it was detected by the driver.
4. Open RBDrumz, it should detect your drumkit automatically and create a new MIDI instrument for you.
5. Open your favorite DAW and use the drumkit as any other MIDI instrument.

## Demo

I made two YouTube videos showing how it works. Here's a [long version](http://www.youtube.com/watch?v=NdtkSd5nHmk) and here's a [short version](http://www.youtube.com/watch?v=LeYYpPRETrg). Unfortunately the videos are in portuguese (I'm Brazilian) but you should be able to understand it anyway.

## License

**RBDrumz** is licensed under the MIT License. Please give me some kind of attribution if you use any part of it in another project, such as a "thanks" note somewhere. I'd also love to know if you use my code, please drop me a line if you do!

Full license text follows:

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

## Acknowledgments

**RSOAuthEngine** uses [DDHidLib](http://www.dribin.org/dave/software/) by Dave Dribin and [VVMIDI](http://code.google.com/p/vvopensource/) by VIDVOX. Both are included as precompiled Frameworks.