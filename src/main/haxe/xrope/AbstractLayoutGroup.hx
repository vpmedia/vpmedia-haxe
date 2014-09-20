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
* Abstract class for layout group.
* @author eidiot
*/
class AbstractLayoutGroup implements ILayoutGroup {
    public var container(get, never):DisplayObjectContainer;
    public var elements(get, never):Array<ILayoutElement>;
    public var x(get, set):Float;
    public var y(get, set):Float;
    public var width(get, set):Float;
    public var height(get, set):Float;
    public var useBounds(get, set):Bool;
    public var align(get, set):String;
    public var horizontalGap(get, set):Float;
    public var verticalGap(get, set):Float;
    public var autoLayoutWhenChange(get, set):Bool;
//======================================================================
//  Constructor
//======================================================================
/**
* Construct a <code>AbstractLayoutGroup</code>.
* @param container             Container of the layout group.
* @param useBounds             If use <code>getBounds()</code> for atom.
* @param autoLayoutWhenAdd     If auto layout when a new element is added.
* @param autoLayoutWhenChange  If auto layout when something has been changed.
*/

    public function new(container:DisplayObjectContainer, useBounds:Bool = false, autoLayoutWhenChange:Bool = true) {
        atomLayoutsByDisplayObject = new Map();
        isLayouted = false;
        _elements = new Array<ILayoutElement>();
        _x = 0;
        _y = 0;
        _width = 0;
        _height = 0;
        _useBounds = false;
        _align = "TL";
        _horizontalGap = 5;
        _verticalGap = 5;
        _autoLayoutWhenChange = false;
        _container = container;
        _useBounds = useBounds;
        _autoLayoutWhenChange = autoLayoutWhenChange;
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */
    var atomLayoutsByDisplayObject:Map<DisplayObject, ILayoutElement>;
/** @private */
    var isLayouted:Bool;
//======================================================================
//  Properties: IXLayoutGroup
//======================================================================
//------------------------------
//  container
//------------------------------
/** @private */
    var _container:DisplayObjectContainer;
/** @inheritDoc */

    public function get_container():DisplayObjectContainer {
        return _container;
    }
//------------------------------
//  elements
//------------------------------
/** @private */
    var _elements:Array<ILayoutElement>;
/** @inheritDoc */

    public function get_elements():Array<ILayoutElement> {
        return _elements.concat([]);
    }
//------------------------------
//  x
//------------------------------
/** @private */
    var _x:Float;
/** @inheritDoc */

    public function get_x():Float {
        return _x;
    }
/** @private */

    public function set_x(value:Float):Float {
        if (value == _x) {
            return _x;
        }
        if (isLayouted && _autoLayoutWhenChange) {
            var change:Float = value - _x;
            for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
                element.x += change;
            }
        }
        _x = value;
        return value;
    }
//------------------------------
//  y
//------------------------------
/** @private */
    var _y:Float;
/** @inheritDoc */

    public function get_y():Float {
        return _y;
    }
/** @private */

    public function set_y(value:Float):Float {
        if (value == _y) {
            return _y;
        }
        if (isLayouted && _autoLayoutWhenChange) {
            var change:Float = value - _y;
            for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
                element.y += change;
            }
        }
        _y = value;
        return value;
    }
//------------------------------
//  width
//------------------------------
/** @private */
    var _width:Float;
/** @inheritDoc */

    public function get_width():Float {
        return _width;
    }
/** @private */

    public function set_width(value:Float):Float {
        if (value == _width) {
            return _width;
        }
        _width = value;
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  height
//------------------------------
/** @private */
    var _height:Float;
/** @inheritDoc */

    public function get_height():Float {
        return _height;
    }
/** @private */

    public function set_height(value:Float):Float {
        if (value == _height) {
            return _height;
        }
        _height = value;
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  useBounds
//------------------------------
/** @private */
    var _useBounds:Bool;
/** @inheritDoc */

    public function get_useBounds():Bool {
        return _useBounds;
    }
/** @private */

    public function set_useBounds(value:Bool):Bool {
        if (value == _useBounds) {
            return _useBounds;
        }
        _useBounds = value;
        for (element in _elements/* AS3HX WARNING could not determine type for var: element exp: EIdent(_elements) type: Array<ILayoutElement>*/) {
            element.useBounds = _useBounds;
        }
        return value;
    }
//------------------------------
//  align
//------------------------------
/** @private */
    var _align:String;
/** @inheritDoc */

    public function get_align():String {
        return _align;
    }
/** @private */

    public function set_align(value:String):String {
        if (value == _align) {
            return _align;
        }
        _align = value;
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  horizontalGap
//------------------------------
/** @private */
    var _horizontalGap:Float;
/** @inheritDoc */

    public function get_horizontalGap():Float {
        return _horizontalGap;
    }
/** @private */

    public function set_horizontalGap(value:Float):Float {
        if (value == _horizontalGap) {
            return _horizontalGap;
        }
        _horizontalGap = value;
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  verticalGap
//------------------------------
/** @private */
    var _verticalGap:Float;
/** @inheritDoc */

    public function get_verticalGap():Float {
        return _verticalGap;
    }
/** @private */

    public function set_verticalGap(value:Float):Float {
        if (value == _verticalGap) {
            return _verticalGap;
        }
        _verticalGap = value;
        checkLayoutAfterChange();
        return value;
    }
//------------------------------
//  autoLayoutWhenChange
//------------------------------
/** @private */
    var _autoLayoutWhenChange:Bool;
/** @inheritDoc */

    public function get_autoLayoutWhenChange():Bool {
        return _autoLayoutWhenChange;
    }
/** @private */

    public function set_autoLayoutWhenChange(value:Bool):Bool {
        _autoLayoutWhenChange = value;
        return value;
    }
//======================================================================
//  Public methods: IXLayoutGroup
//======================================================================
/** @inheritDoc */

    public function add(targets:Array<Dynamic>):Void {
/*while(targets.length == 1 && Std.is(targets[0], Array)) {
targets = targets[0];
}*/
        if (targets.length == 0) {
            return;
        }
        for (target in targets/* AS3HX WARNING could not determine type for var: target exp: EIdent(targets) type: null*/) {
            addOne(target);
        }
        checkLayoutAfterChange();
    }
/** @inheritDoc */

    public function remove(targets:Array<Dynamic>):Void {
/*while(targets.length == 1 && Std.is(targets[0], Array)) {
targets = targets[0];
}*/
        for (target in targets/* AS3HX WARNING could not determine type for var: target exp: EIdent(targets) type: null*/) {
            removeOne(target);
        }
        checkLayoutAfterChange();
    }
/** @inheritDoc */

    public function removeAll():Void {
        for (displayObject in atomLayoutsByDisplayObject.keys()) {
            removeDisplayObject(displayObject);
        }
        atomLayoutsByDisplayObject = new Map();
        _elements = new Array<ILayoutElement>();
        isLayouted = false;
    }
/** @inheritDoc */

    public function has(element:Dynamic):Bool {
        if (_elements.length == 0) {
            return false;
        }
        if (Std.is(element, ILayoutElement)) {
            return Lambda.indexOf(_elements, element) != -1;
        }
        if (Std.is(element, DisplayObject)) {
            return atomLayoutsByDisplayObject.exists(element);
        }
        return false;
    }
/** @inheritDoc */

    public function layout():Void {
        if (_elements.length > 0) {
            layoutElements();
        }
        isLayouted = true;
    }
/** @inheritDoc */

    public function layoutContainer():Void {
        removeAll();
        var N:Int = _container.numChildren;
        if (N == 0) {
            return;
        }
        var i:Int = 0;
        for (i in 0...N) {
            addAtom(_container.getChildAt(i));
        }
        layoutElements();
        isLayouted = true;
    }
/** @inheritDoc */

    public function reset():Void {
        removeAll();
        _x = 0;
        _y = 0;
        _width = 0;
        _height = 0;
        _align = "TL";
        _useBounds = false;
        _horizontalGap = 5;
        _verticalGap = 5;
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */

    function addOne(target:Dynamic):Void {
//trace(this + "::" + "addOne" + "::" + target);

        if (has(target)) {
            return;
        }
        if (Std.is(target, ILayoutElement)) {
            _elements.push(target);
        }
        else if (Std.is(target, DisplayObject)) {
            addAtom(target);
        }
    }
/** @private */

    function addAtom(target:DisplayObject):Void {
//trace(this + "::" + "addAtom" + "::" + target.name);
        if (target.parent != _container) {
            _container.addChild(target);
        }
        if (atomLayoutsByDisplayObject.exists(target)) {
            return;
        }
        var atom:ILayoutElement = createAtom(target);
        atomLayoutsByDisplayObject.set(target, atom);
        _elements.push(atom);
    }
/** @private */

    function createAtom(target:DisplayObject):ILayoutElement {
        return new AtomLayout(target, _useBounds);
    }
/** @private */

    function removeOne(target:Dynamic):Void {
        if (Std.is(target, ILayoutElement)) {
            var index:Int = Lambda.indexOf(_elements, target);
            if (index != -1) {
                _elements.splice(index, 1);
            }
            return;
        }
        if (Std.is(target, DisplayObject)) {
            removeDisplayObject(target);
            if (atomLayoutsByDisplayObject.exists(target)) {
                removeOne(atomLayoutsByDisplayObject.get(target));
//This is an intentional compilation error. See the README for handling the delete keyword
                atomLayoutsByDisplayObject.remove(target);
            }
        }
    }
/** @private */

    function removeDisplayObject(target:DisplayObject):Void {
        if (target.parent == _container) {
            _container.removeChild(target);
        }
    }
/** @private */

    function checkLayoutAfterChange():Void {
        if (isLayouted && _autoLayoutWhenChange) {
            layout();
        }
    }
/** @private */

    function layoutElements():Void {
    }
}