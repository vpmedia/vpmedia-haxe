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
/**
     * Abstract class for single line layout.
     * @author eidiot
     */class AbstractLineLayout extends AbstractLayoutGroup {
//======================================================================
//  Constructor
//======================================================================
/**
         * Construct a <code>XLineLayout</code>.
         * @param container             Container of the layout group.
         * @param useBounds             If use <code>getBounds()</code> for atom.
         * @param autoLayoutWhenAdd     If auto layout when a new element is added.
         * @param autoLayoutWhenChange  If auto layout when something has been changed.
         */ public function new(container:DisplayObjectContainer, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
    super(container, useBounds, autoLayoutWhenChange);
}
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override function layoutElements():Void {
        fixSize();
        var xAlgorithm:ILayoutAlgorithm = getXAlgorithm();
        xAlgorithm.beReady(this, "x", "width", getStartX(), _horizontalGap);
        var yAlgorithm:ILayoutAlgorithm = getYAlgorithm();
        yAlgorithm.beReady(this, "y", "height", getStartY(), _verticalGap);
        var previousElement:ILayoutElement = null;
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
            element.x = xAlgorithm.calculate(element, previousElement);
            element.y = yAlgorithm.calculate(element, previousElement);
            previousElement = element;
        }
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */

    function fixSize():Void {
        if (_width <= 0) {
            fixWidth();
        }
        if (_height <= 0) {
            fixHeight();
        }
    }
/** @private */

    function fixWidth():Void {
    }
/** @private */

    function fixHeight():Void {
    }
/** @private */

    function getStartX():Float {
        return _x;
    }
/** @private */

    function getStartY():Float {
        return _y;
    }
/** @private */

    function getXAlgorithm():ILayoutAlgorithm {
        return null;
    }
/** @private */

    function getYAlgorithm():ILayoutAlgorithm {
        return null;
    }
}