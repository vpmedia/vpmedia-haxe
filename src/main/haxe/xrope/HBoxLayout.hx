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
     * Horizontal box layout.
     * @author eidiot
     */class HBoxLayout extends AbstractMultiLineLayout {
//======================================================================
//  Constructor
//======================================================================
/**
         * Construct a <code>HBoxLayout</code>.
         * @param container             Container of the layout group.
         * @param width                 <code>width</code> value of the layout element.
         * @param height                <code>height</code> value of the layout element.
         * @param x                     <code>x</code> value of the layout element.
         * @param y                     <code>y</code> value of the layout element.
         * @param align                 Align of the layout group.
         * @param horizontalGap         Horizontal gap value.
         * @param verticalGap           Vertical gap value.
         * @param useBounds             If use <code>getBounds()</code> for atom.
         * @param autoLayoutWhenAdd     If auto layout when a new element is added.
         * @param autoLayoutWhenChange  If auto layout when something has been changed.
         */ public function new(container:DisplayObjectContainer, width:Float, height:Float, x:Float = 0, y:Float = 0, align:String = "TL", horizontalGap:Float = 5, verticalGap:Float = 5, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
    super(container, width, height, x, y, align, horizontalGap, verticalGap, useBounds, autoLayoutWhenChange);
}
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override function layoutElements():Void {
        layoutAsLines("width", _horizontalGap);
    }
/** @private */

    override function createLine(oldLines:Array<ILayoutGroup>):ILayoutGroup {
        var line:HLineLayout = oldLines.length > (0) ? cast((oldLines.pop()), HLineLayout) : new HLineLayout(_container);
        line.reset();
        line.align = _lineAlign;
        line.horizontalGap = _horizontalGap;
        return line;
    }
/** @private */

    override function createTopLayout():ILayoutGroup {
        return new VLineLayout(_container, _x, _y, _width, _height, _align, _verticalGap);
    }
/** @private */

    override function fixLineAlign(value:String):String {
        switch(value) {
            case LayoutAlign.BOTTOM_LEFT, LayoutAlign.BOTTOM_RIGHT:
                return LayoutAlign.BOTTOM;
            case LayoutAlign.LEFT, LayoutAlign.RIGHT:
                return LayoutAlign.CENTER;
            case LayoutAlign.TOP_LEFT, LayoutAlign.TOP_RIGHT:
                return LayoutAlign.TOP;
            default:
                return value;
        }
        return value;
    }
}