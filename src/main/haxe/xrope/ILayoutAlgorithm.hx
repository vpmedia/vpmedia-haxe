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
* Interface for the layout algorithms.
* @author eidiot
*/
interface ILayoutAlgorithm {
/**
    * Be ready  for the layout value calculation.
    * @param group         Layout group target.
    * @param valueKey      "x" or "y".
    * @param sizeKey       "width" or "height".
    * @param startValue    Value of the first element.
    * @param gap           Gap between the elements in the group.
    */
    function beReady(group:ILayoutGroup, valueKey:String, sizeKey:String, startValue:Float, gap:Float):Void;
/**
    * Calculate the layout value.
    * @param currentElement    Current element in the calculation.
    * @param previousElement   Previous element in the group.
    */
    function calculate(currentElement:ILayoutElement, previousElement:ILayoutElement = null):Float;
}