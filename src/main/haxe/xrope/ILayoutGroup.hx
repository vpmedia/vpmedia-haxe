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
* Interface for layout groups.
* @author eidiot
*/
interface ILayoutGroup extends ILayoutElement {
    var container(get, never):DisplayObjectContainer;
    var elements(get, never):Array<ILayoutElement>;
    var align(get, set):String;
    var horizontalGap(get, set):Float;
    var verticalGap(get, set):Float;
    var autoLayoutWhenChange(get, set):Bool;
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  container
//------------------------------
/**
    * Container of the layout group.
    */
    function get_container():DisplayObjectContainer;
//------------------------------
//  elements
//------------------------------
/**
    * All layout elements in this group.
    */
    function get_elements():Array<ILayoutElement>;
//------------------------------
//  align
//------------------------------
/**
    * Align of this layout group.
    */
    function get_align():String;
/** @private */
    function set_align(value:String):String;
//------------------------------
//  horizontalGap
//------------------------------
/**
    * Horizontal gap of this layout group.
    */
    function get_horizontalGap():Float;
/** @private */
    function set_horizontalGap(value:Float):Float;
//------------------------------
//  verticalGap
//------------------------------
/**
    * Vertical gap of this layout group.
    */
    function get_verticalGap():Float;
/** @private */
    function set_verticalGap(value:Float):Float;
//------------------------------
//  autoLayoutWhenChange
//------------------------------
/**
    * If auto layout when changed.
    */
    function get_autoLayoutWhenChange():Bool;
/** @private */
    function set_autoLayoutWhenChange(value:Bool):Bool;
//======================================================================
//  Public methods
//======================================================================
/**
    * Add elements to the group.
    */
    function add(childs:Array<Dynamic>):Void;
/**
    * Remove elements from the group.
    */
    function remove(childs:Array<Dynamic>):Void;
/**
    * Remove all elements.
    */
    function removeAll():Void;
/**
    * Check if an element is in the group.
    */
    function has(element:Dynamic):Bool;
/**
    * Layout all the elements in the group.
    */
    function layout():Void;
/**
    * Layout all children in the container.
    */
    function layoutContainer():Void;
/**
    * Remove all elements and reset all property to default value.
    */
    function reset():Void;
}