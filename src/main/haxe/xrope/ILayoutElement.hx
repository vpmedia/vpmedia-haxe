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
/**
* Interface for a layout element.
* @author eidiot
*/
interface ILayoutElement {
    var x(get, set):Float;
    var y(get, set):Float;
    var width(get, set):Float;
    var height(get, set):Float;
    var useBounds(get, set):Bool;
//======================================================================
//  Properties
//======================================================================
//------------------------------
//  x
//------------------------------
/**
    * <code>x</code> value of the layout element.
    */
    function get_x():Float;
/** @private */
    function set_x(value:Float):Float;
//------------------------------
//  y
//------------------------------
/**
    * <code>y</code> value of the layout element.
    */
    function get_y():Float;
/** @private */
    function set_y(value:Float):Float;
//------------------------------
//  width
//------------------------------
/**
    * <code>width</code> of the layout element.
    */
    function get_width():Float;
/** @private */
    function set_width(value:Float):Float;
//------------------------------
//  height
//------------------------------
/**
    * <code>height</code> value of the layout element.
    */
    function get_height():Float;
/** @private */
    function set_height(value:Float):Float;
//------------------------------
//  useBounds
//------------------------------
/**
    * If use <code>getBounds()</code> of <code>DisplayObject</code> for layout.
    */
    function get_useBounds():Bool;
/** @private */
    function set_useBounds(value:Bool):Bool;
}