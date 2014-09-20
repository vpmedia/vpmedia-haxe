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
package xrope;
import xrope.algorithms.AlgorithmFactory;
import xrope.algorithms.ForwardAlgorithm;
import flash.display.DisplayObjectContainer;
class HFillLineLayout extends AbstractFillLineLayout {
//======================================================================
//  Constructor
//======================================================================
/**
         * Construct a <code>HFillLineLayout</code>.
         * @param container             Container of the layout group.
         * @param x                     <code>x</code> value of the layout element.
         * @param y                     <code>y</code> value of the layout element.
         * @param width                 <code>width</code> value of the layout element.
         * @param height                <code>height</code> value of the layout element.
         * @param align                 Align of the layout group.
         * @param useBounds             If use <code>getBounds()</code> for atom.
         * @param autoLayoutWhenAdd     If auto layout when a new element is added.
         * @param autoLayoutWhenChange  If auto layout when something has been changed.
         */ public function new(container:DisplayObjectContainer, width:Float, height:Float, x:Float = 0, y:Float = 0, align:String = "C", useMargin:Bool = true, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
    super("width", container, x, y, width, height, align, useMargin, useBounds, autoLayoutWhenChange);
}
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override function getStartX():Float {
        return _x + margin;
    }
/** @private */

    override function getXAlgorithm():ILayoutAlgorithm {
        return new ForwardAlgorithm();
    }
/** @private */

    override function getYAlgorithm():ILayoutAlgorithm {
        return AlgorithmFactory.getYAlgorithmForHLayout(_align);
    }
}