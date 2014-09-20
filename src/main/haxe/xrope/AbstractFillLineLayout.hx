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
class AbstractFillLineLayout extends AbstractLineLayout {
    public var useMargin(get, set):Bool;
//======================================================================
//  Constructor
//======================================================================
/**
* Construct a <code>AbstractFillLineLayout</code>.
* @param sizeKey               Key of the size, "width" or "height".
* @param container             Container of the layout group.
* @param x                     <code>x</code> value of the layout element.
* @param y                     <code>y</code> value of the layout element.
* @param width                 <code>width</code> value of the layout element.
* @param height                <code>height</code> value of the layout element.
* @param align                 Align of the layout group.
* @param useBounds             If use <code>getBounds()</code> for atom.
* @param autoLayoutWhenAdd     If auto layout when a new element is added.
* @param autoLayoutWhenChange  If auto layout when something has been changed.
*/

    public function new(sizeKey:String, container:DisplayObjectContainer, x:Float, y:Float, width:Float, height:Float, align:String, useMargin:Bool, useBounds:Bool, autoLayoutWhenChange:Bool) {
        margin = 0;
        _useMargin = true;
        super(container, useBounds, autoLayoutWhenChange);
        this.sizeKey = sizeKey;
        _useMargin = useMargin;
        _x = x;
        _y = y;
        _width = width;
        _height = height;
        _align = align;
    }
//======================================================================
//  Variables
//======================================================================
/** @private */
    var margin:Float;
/** @private */
    var sizeKey:String;
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  useMargin
//------------------------------
/** @private */
    var _useMargin:Bool;
/**
* If use margin as well as spaces between elements.
*/

    public function get_useMargin():Bool {
        return _useMargin;
    }
/** @private */

    public function set_useMargin(value:Bool):Bool {
        if (value == _useMargin) {
            return _useMargin;
        }
        _useMargin = value;
        checkLayoutAfterChange();
        return value;
    }
//======================================================================
//  Overridden methods
// ======================================================================
/** @private */

    override function layoutElements():Void {
        var ELEMENTS_COUNT:Int = _elements.length;
        if (ELEMENTS_COUNT == 0) {
            return;
        }
        if (ELEMENTS_COUNT == 1) {
            margin = (Reflect.getProperty(this, sizeKey) - Reflect.getProperty(_elements[0], sizeKey)) / 2;
        }
        else {
            var elementsHeight:Float = getElementsSize();
            var SPACE_COUNT:Int = ELEMENTS_COUNT + ((_useMargin) ? 1 : -1);
            var gap:Float = (Reflect.getProperty(this, sizeKey) - elementsHeight) / SPACE_COUNT;
            margin = (_useMargin) ? gap : 0;
            _horizontalGap = _verticalGap = gap;
        }
        super.layoutElements();
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */

    function getElementsSize():Float {
        var result:Float = 0;
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: null*/) {
            result += Reflect.getProperty(element, sizeKey);
        }
        return result;
    }
}