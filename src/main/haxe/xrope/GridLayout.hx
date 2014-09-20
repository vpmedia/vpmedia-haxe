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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
/**
* Grid layout.
* @author eidiot
*/
class GridLayout extends AbstractMultiLineLayout {
    public var tileAlign(get, set):String;
    public var tileWidth(get, set):Float;
    public var tileHeight(get, set):Float;
//======================================================================
//  Constructor
//======================================================================
/**
* Construct a <code>GridLayout</code>.
* @param container             Container of the layout group.
* @param width                 <code>width</code> value of the layout element.
* @param height                <code>height</code> value of the layout element.
* @param tileWidth             <code>width</code> value of each tile.
* @param tileHeight            <code>height</code> value of each tile.
* @param x                     <code>x</code> value of the layout element.
* @param y                     <code>y</code> value of the layout element.
* @param tileAlign             Align of each tile.
* @param align                 Align of the layout group.
* @param horizontalGap         Horizontal gap value.
* @param verticalGap           Vertical gap value.
* @param useBounds             If use <code>getBounds()</code> for atom.
* @param autoLayoutWhenAdd     If auto layout when a new element is added.
* @param autoLayoutWhenChange  If auto layout when something has been changed.
*/

    public function new(container:DisplayObjectContainer, width:Float, height:Float, tileWidth:Float, tileHeight:Float, x:Float = 0, y:Float = 0, tileAlign:String = "TL", align:String = "TL", horizontalGap:Float = 5, verticalGap:Float = 5, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
        super(container, width, height, x, y, align, horizontalGap, verticalGap, useBounds, autoLayoutWhenChange);
        _tileWidth = tileWidth;
        _tileHeight = tileHeight;
        _tileAlign = tileAlign;
    }
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  tileAlign
//------------------------------
    var _tileAlign:String;
/**
* Align of ecah tile.
*/

    public function get_tileAlign():String {
        return _tileAlign;
    }
/** @private */

    public function set_tileAlign(value:String):String {
        if (value == _tileAlign) {
            return _tileAlign;
        }
        _tileAlign = value;
        for (atom in atomLayoutsByDisplayObject/* AS3HX WARNING could not determine type for var: atom exp: EIdent(atomLayoutsByDisplayObject) type: Dictionary*/) {
            cast(atom, TileLayout).align = _tileAlign;
        }
        return value;
    }
//------------------------------
//  tileWidth
//------------------------------
    var _tileWidth:Float;
/**
* Width of each tile.
*/

    public function get_tileWidth():Float {
        return _tileWidth;
    }
/** @private */

    public function set_tileWidth(value:Float):Float {
        if (value == _tileWidth) {
            return _tileWidth;
        }
        _tileWidth = value;
        for (atom in atomLayoutsByDisplayObject/* AS3HX WARNING could not determine type for var: atom exp: EIdent(atomLayoutsByDisplayObject) type: Dictionary*/) {
            atom.width = _tileWidth;
        }
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  tileHeight
//------------------------------
    var _tileHeight:Float;
/**
* Height of ecch tile.
*/

    public function get_tileHeight():Float {
        return _tileHeight;
    }
/** @private */

    public function set_tileHeight(value:Float):Float {
        if (value == _tileHeight) {
            return _tileHeight;
        }
        _tileHeight = value;
        for (atom in atomLayoutsByDisplayObject/* AS3HX WARNING could not determine type for var: atom exp: EIdent(atomLayoutsByDisplayObject) type: Dictionary*/) {
            atom.height = _tileHeight;
        }
        checkLayoutAfterChange();
        return value;
    }
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override function createAtom(element:DisplayObject):ILayoutElement {
        return new TileLayout(element, _tileWidth, _tileHeight, _tileAlign, _useBounds);
    }
/** @private */

    override function layoutElements():Void {
        layoutAsLines("width", _horizontalGap);
    }
/** @private */

    override function createLine(oldLines:Array<ILayoutGroup>):ILayoutGroup {
        var line:HLineLayout = oldLines.length > (0) ? cast((oldLines.pop()), HLineLayout) : new HLineLayout(_container);
        line.reset();
        line.horizontalGap = _horizontalGap;
        return line;
    }
/** @private */

    override function createTopLayout():ILayoutGroup {
        return new VLineLayout(_container, _x, _y, _width, _height, _align, _verticalGap);
    }
}