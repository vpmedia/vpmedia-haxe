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
     * Abstract class for multi-line layout (and box layout).
     * @author eidiot
     */
class AbstractMultiLineLayout extends AbstractLayoutGroup implements IMultiLineLayout {
    public var lines(get, never):Array<ILayoutGroup>;
    public var lineAlign(get, set):String;
//======================================================================
//  Constructor
//======================================================================
/**
         * Construct a <code>AbstractMultiLineLayout</code>.
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
         */

    public function new(container:DisplayObjectContainer, width:Float, height:Float, x:Float = 0, y:Float = 0, align:String = "TL", horizontalGap:Float = 5, verticalGap:Float = 5, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
        _lines = new Array<ILayoutGroup>();
        _lineAlign = "TL";
        super(container, useBounds, autoLayoutWhenChange);
        _width = width;
        _height = height;
        _x = x;
        _y = y;
        _align = align;
        _horizontalGap = horizontalGap;
        _verticalGap = verticalGap;
    }
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  lines
//------------------------------
/** @private */
    var _lines:Array<ILayoutGroup>;
/** @inheritDoc */

    public function get_lines():Array<ILayoutGroup> {
        return _lines.concat([]);
    }
//------------------------------
//  lineAlign
//------------------------------
/** @private */
    var _lineAlign:String;
/**
         * align of each line.
         */

    public function get_lineAlign():String {
        return _lineAlign;
    }
/** @private */

    public function set_lineAlign(value:String):String {
        var newAlign:String = fixLineAlign(value);
        if (newAlign == _lineAlign) {
            return _lineAlign;
        }
        _lineAlign = newAlign;
        checkLayoutAfterChange();
        return value;
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */

    function layoutAsLines(valueKey:String, gap:Float):Void {
        var currentValue:Float = 0;
        var oldLines:Array<ILayoutGroup> = _lines;
        var currentLine:ILayoutGroup = createLine(oldLines);
        _lines = cast [currentLine];
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
            var addValue:Float = Reflect.getProperty(element, valueKey);
            if (currentValue != 0) {
                addValue += gap;
            }
            var newValue:Float = currentValue + addValue;
            if (newValue > Reflect.getProperty(this, valueKey)) {
                currentLine = createLine(oldLines);
                _lines.push(currentLine);
                currentValue = Reflect.getProperty(element, valueKey);
            }
            else {
                currentValue += addValue;
            }
            currentLine.add([element]);
        }
        var topLayout:ILayoutGroup = createTopLayout();
        for (line in _lines/* AS3HX WARNING could not determine type for var: line exp: EIdent(_lines) type: Array<ILayoutGroup>*/) {
            line.layout();
            topLayout.add([line]);
        }
        topLayout.layout();
    }
/** @private */

    function createLine(oldLines:Array<ILayoutGroup>):ILayoutGroup {
// Tobe overridden by subclasses.
        return null;
    }
/** @private */

    function createTopLayout():ILayoutGroup {
// Tobe overridden by subclasses.
        return null;
    }
/** @private */

    function fixLineAlign(value:String):String {
        return value;
    }
}