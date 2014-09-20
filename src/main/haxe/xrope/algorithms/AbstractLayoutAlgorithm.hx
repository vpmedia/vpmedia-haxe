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
package xrope.algorithms;
import xrope.ILayoutAlgorithm;
import xrope.ILayoutElement;
import xrope.ILayoutGroup;
/**
 * Abstract class for layout Algorithm.
 * @author eidiot
 */
class AbstractLayoutAlgorithm implements ILayoutAlgorithm {
//======================================================================
//  Variables
//======================================================================
/** @private */ var group:ILayoutGroup;
/** @private */ var valueKey:String;
/** @private */ var sizeKey:String;
/** @private */ var startValue:Float;
/** @private */ var gap:Float;
//======================================================================
//  Public methods: IXLayoutAlgorithm
//======================================================================
/** @inheritDoc */

    public function beReady(group:ILayoutGroup, valueKey:String, sizeKey:String, startValue:Float, gap:Float):Void {
//trace(this + "::" + "beReady" + "::" + group + "::" + valueKey + "::" + sizeKey + "::" + startValue + "::" + gap);
        this.group = group;
        this.valueKey = valueKey;
        this.sizeKey = sizeKey;
        this.startValue = startValue;
        this.gap = gap;
    }
/** @inheritDoc */

    public function calculate(currentElement:ILayoutElement, previousElement:ILayoutElement = null):Float {
// To be overridden by subclasses.
        return 0;
    }
//======================================================================
//  Protected methods
//======================================================================
/** @private */

    function sizeOf(target:ILayoutElement):Float {
//trace(this + "::" + "sizeOf" + "::" + target + "::" + sizeKey + "::" + Reflect.getProperty(target, sizeKey)+"::"+ Reflect.hasField(target, sizeKey));
//trace(target.width + "::" + target.height);
/*if (sizeKey == "width")
        {
            return target.width;
        }
        else if (sizeKey == "height")
        {
            return target.height;
        }*/
        return Reflect.getProperty(target, sizeKey);
    }
/** @private */

    function valueOf(target:ILayoutElement):Float {
//trace(this + "::" + "valueOf" + "::" + target + "::" + valueKey + "::" + Reflect.getProperty(target, valueKey)+"::"+ Reflect.hasField(target, valueKey));
//trace(target.x + "::" + target.y);
/*if (valueKey == "x")
        {
            return target.x;
        }
        else if (valueKey == "y")
        {
            return target.y;
        }*/
        return Reflect.getProperty(target, valueKey);
    }

    public function new() {
    }
}