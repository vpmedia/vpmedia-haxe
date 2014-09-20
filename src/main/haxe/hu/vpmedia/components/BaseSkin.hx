/*
 * =BEGIN MIT LICENSE
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2012-2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * =END MIT LICENSE
 */
package hu.vpmedia.components;

import xrope.ILayoutGroup;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseSkin {
    public var owner:BaseComponent;
    public var layout:ILayoutGroup;
    public var componentPartList:Array<BaseComponent>;

//----------------------------------
//  Constructor
//----------------------------------

    function new(owner:BaseComponent) {
//super();
        this.owner = owner;
    }

//----------------------------------
//  Core
//----------------------------------

    public function initialize():Void {
        componentPartList = new Array();
        createChildren();
    }

    function createChildren():Void {
// abstracat
    }

    public function dispose():Void {
/*var n:Int = componentPartList.length;
        for (i in 0...n)
        {
            componentPartList[i].dispose();
        }  */
    }

//----------------------------------
//  Draw
//----------------------------------

    public function draw():Void {
        if (owner.isDisposed) {
            return;
        }

/*#if debug
        L.info("draw"+"::"+owner.isInvalid(ComponentChange.ALL));
        #end */

// self

        if (owner.isInvalid(ComponentChange.DATA)) {
            updateData();
            owner.validate(ComponentChange.DATA);
        }

        if (owner.isInvalid(ComponentChange.STATE)) {
            updateState();
            owner.validate(ComponentChange.STATE);
        }

        if (owner.isInvalid(ComponentChange.STYLE)) {
            updateStyle();
            owner.validate(ComponentChange.STYLE);
        }

        if (owner.isInvalid(ComponentChange.SIZE)) {
            updateSize();
            owner.validate(ComponentChange.SIZE);
        }

        if (owner.isInvalid(ComponentChange.ALL)) {
            owner.validate(ComponentChange.ALL);
        }
    }

    public function setCurrentStateToChilds():Void {
// sub comps
        var n:Int = componentPartList.length;
        for (i in 0...n) {
/*#if debug
            L.debug("Setting "+ Std.string(owner.getState())+ " state to sub component:"+componentPartList[i]);
            #end */
            componentPartList[i].setState(owner.getState());
//componentPartList[i].draw();
        }
    }

    public function updateState():Void {
/*#if debug
        L.debug("updateState");
        #end  */
    }

    public function updateStyle():Void {
/*#if debug
        L.debug("updateStyle");
        #end*/
    }

    public function updateData():Void {
/*#if debug
        L.debug("updateData");
        #end  */
    }

    public function updateSize():Void {
/*#if debug
        L.debug("updateSize");
        #end */
    }

}