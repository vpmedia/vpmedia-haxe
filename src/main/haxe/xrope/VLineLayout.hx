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
import flash.display.DisplayObjectContainer;
import xrope.algorithms.AlgorithmFactory;
/**
     * Vertical single line layout.
     * @author eidiot
     */class VLineLayout extends AbstractLineLayout {
//======================================================================
//  Constructor
//======================================================================
/**
         * Construct a <code>XLineLayout</code>.
         * @param container             Container of the layout group.
         * @param x                     <code>x</code> value of the layout element.
         * @param y                     <code>y</code> value of the layout element.
         * @param width                 <code>width</code> value of the layout element.
         * @param height                <code>height</code> value of the layout element.
         * @param align                 Align of the layout group.
         * @param gap                   Gap value of the line layout.
         * @param useBounds             If use <code>getBounds()</code> for atom.
         * @param autoLayoutWhenAdd     If auto layout when a new element is added.
         * @param autoLayoutWhenChange  If auto layout when something has been changed.
         */ public function new(container:DisplayObjectContainer, x:Float = 0, y:Float = 0, width:Float = -1, height:Float = -1, align:String = "TL", gap:Float = 5, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
    super(container, useBounds, autoLayoutWhenChange);
    _x = x;
    _y = y;
    _width = width;
    _height = height;
    _align = align;
    _verticalGap = gap;
}
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override function fixWidth():Void {
        _width = getMaxWidth();
    }
/** @private */

    override function fixHeight():Void {
        _height = getElementsAndGapsHeight();
    }
/** @private */

    override function getStartY():Float {
        switch (_align)
        {
            case LayoutAlign.BOTTOM, LayoutAlign.BOTTOM_LEFT, LayoutAlign.BOTTOM_RIGHT:
                return _y + _height;
            case LayoutAlign.CENTER, LayoutAlign.LEFT, LayoutAlign.RIGHT:
                return _y + (_height - getElementsAndGapsHeight()) / 2;
        }
        return _y;
    }
/** @private */

    override function getXAlgorithm():ILayoutAlgorithm {
        return AlgorithmFactory.getXAlgorithmForVLayout(_align);
    }
/** @private */

    override function getYAlgorithm():ILayoutAlgorithm {
        return AlgorithmFactory.getYAlgorithmForVLayout(_align);
    }
//======================================================================
//  Private methods
//======================================================================

    function getElementsHeight():Float {
        var result:Float = 0;
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
            result += element.height;
        }
        return result;
    }

    function getGapsHeight():Float {
        return _verticalGap * (_elements.length - 1);
    }

    function getElementsAndGapsHeight():Float {
        return getElementsHeight() + getGapsHeight();
    }

    function getMaxWidth():Float {
        var result:Float = 0;
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
            if (element.width > result) {
                result = element.width;
            }
        }
        return result;
    }
}