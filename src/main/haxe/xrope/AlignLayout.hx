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
* Composite layout use align positions.
* @author eidiot
*/
class AlignLayout extends AbstractLayoutGroup {
    public var defaultAlign(get, set):String;
//======================================================================
//  Constructor
//======================================================================
/**
* Construct a <code>AlignLayout</code>.
* @param container             Container of the layout group.
* @param width                 <code>width</code> value of the layout element.
* @param height                <code>height</code> value of the layout element.
* @param x                     <code>x</code> value of the layout element.
* @param y                     <code>y</code> value of the layout element.
* @param useBounds             If use <code>getBounds()</code> for atom.
* @param autoLayoutWhenAdd     If auto layout when a new element is added.
* @param autoLayoutWhenChange  If auto layout when something has been changed.
*/

    public function new(container:DisplayObjectContainer, width:Float, height:Float, ?x:Float = 0, ?y:Float = 0, ?useBounds:Bool = false, ?autoLayoutWhenChange:Bool = true) {
        alignMap = new Map();
        _defaultAlign = "TL";
        super(container, useBounds, autoLayoutWhenChange);
        _x = x;
        _y = y;
        _width = width;
        _height = height;
    }
//======================================================================
//  Variables
//======================================================================
    var alignMap:Map<String, ILayoutGroup>;
//======================================================================
//  Overridden properties
//======================================================================

    override public function set_width(value:Float):Float {
        if (value == _width) {
            return _width;
        }
        _width = value;
        for (element in alignMap/* AS3HX WARNING could not determine type for var: element exp: EIdent(alignMap) type: Dictionary*/) {
            element.width = _width;
        }
        return value;
    }

    override public function set_height(value:Float):Float {
        if (value == _height) {
            return _height;
        }
        _height = value;
        for (element in alignMap/* AS3HX WARNING could not determine type for var: element exp: EIdent(alignMap) type: Dictionary*/) {
            element.height = _height;
        }
        return value;
    }
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  defaultAlign
//------------------------------
    var _defaultAlign:String;
/**
* Default align group when call add().
*/

    public function get_defaultAlign():String {
        return _defaultAlign;
    }
/** @private */

    public function set_defaultAlign(value:String):String {
        _defaultAlign = value;
        return value;
    }
//======================================================================
//  Overridden methods
//======================================================================
/** @private */

    override public function add(targets:Array<Dynamic>):Void {
        for (target in targets/* AS3HX WARNING could not determine type for var: target exp: EIdent(targets) type: null*/) {

            addTo(target, _defaultAlign);
        }
    }
/** @private */

    override public function layout():Void {
        for (alignGroup in alignMap/* AS3HX WARNING could not determine type for var: alignGroup exp: EIdent(alignMap) type: Dictionary*/) {
            alignGroup.layout();
        }
    }
/** @private */

    override public function layoutContainer():Void {
        reset();
        var N:Int = _container.numChildren;
        if (N == 0) {
            return;
        }
//for (var i:int = 0;i < N;i++)
        for (i in 0...N) {
            add([_container.getChildAt(i)]);
        }
        layout();
    }
//======================================================================
//  Public methods
//======================================================================
/**
* Add an element to an align position.
* @param element   Element to be added.
* @param align     Align position to be added to.
*/

    public function addTo(element:Dynamic, align:String):Void {
//trace(this + "::" + "addTo" + "::" + element + "::" + align);
        getAlignGroup(align).add([element]);
    }
/**
* Set layout for a align position.
* @param align     Align position.
* @param layout    Layout group for the align postion.
*/

    public function setAlignLayout(align:String, layout:ILayoutGroup):Void {
        if (!alignMap.exists(align)) {
            alignMap.set(align, layout);
            _elements.push(layout);
        }
    }
//======================================================================
//  Private methods
//======================================================================

    function getAlignGroup(align:String):ILayoutGroup {
        if (!alignMap.exists(align)) {
            alignMap.set(align, new HLineLayout(_container, _x, _y, _width, _height, align, _horizontalGap, _useBounds, _autoLayoutWhenChange));
        }
        return alignMap.get(align);
    }
}