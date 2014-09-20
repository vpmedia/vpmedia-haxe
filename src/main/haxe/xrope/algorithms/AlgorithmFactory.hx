////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012-2013, Original author & contributors
// Original author : eidiot <http://eidiot.github.com/xrope/>
// Contributors: Andras Csizmadia -  http://www.vpmedia.eu (HaXe port)
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  
//=END LICENSE MIT
////////////////////////////////////////////////////////////////////////////////
package xrope.algorithms;
import xrope.ILayoutAlgorithm;
import xrope.LayoutAlign;
class AlgorithmFactory {
    static public function getXAlgorithmForHLayout(align:String):ILayoutAlgorithm {
//trace("getXAlgorithmForHLayout"+"::"+align);
        switch(align) {
            case LayoutAlign.RIGHT, LayoutAlign.TOP_RIGHT, LayoutAlign.BOTTOM_RIGHT:
                return new BackwardAlgorithm();
        }
        return new ForwardAlgorithm();
    }

    static public function getYAlgorithmForHLayout(align:String):ILayoutAlgorithm {
//trace("getYAlgorithmForHLayout"+"::"+align);
        switch(align) {
            case LayoutAlign.TOP, LayoutAlign.TOP_LEFT, LayoutAlign.TOP_RIGHT:
                return new MinAlgorithm();
            case LayoutAlign.BOTTOM, LayoutAlign.BOTTOM_LEFT, LayoutAlign.BOTTOM_RIGHT:
                return new MaxAlgorithm();
        }
        return new CenterAlgorithm();
    }

    static public function getXAlgorithmForVLayout(align:String):ILayoutAlgorithm {
//trace("getXAlgorithmForVLayout"+"::"+align);
        switch(align) {
            case LayoutAlign.LEFT, LayoutAlign.TOP_LEFT, LayoutAlign.BOTTOM_LEFT:
                return new MinAlgorithm();
            case LayoutAlign.RIGHT, LayoutAlign.TOP_RIGHT, LayoutAlign.BOTTOM_RIGHT:
                return new MaxAlgorithm();
        }
        return new CenterAlgorithm();
    }

    static public function getYAlgorithmForVLayout(align:String):ILayoutAlgorithm {
//trace("getYAlgorithmForVLayout"+"::"+align);
        switch(align) {
            case LayoutAlign.BOTTOM, LayoutAlign.BOTTOM_LEFT, LayoutAlign.BOTTOM_RIGHT:
                return new BackwardAlgorithm();
        }
        return new ForwardAlgorithm();
    }

    function new() {
    }
}