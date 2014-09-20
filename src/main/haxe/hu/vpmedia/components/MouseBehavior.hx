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

import flash.events.MouseEvent;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class MouseBehavior extends BaseBehavior {
    public var isOver:Bool;
    public var isDown:Bool;
    public var isToggle:Bool;
    public var isSelected:Bool;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new(owner:BaseComponent) {
        super(owner);
    }

//--------------------------------------
//  Private(protected)
//--------------------------------------
/**
     * Abstract
     */

    override function initialize():Void {
        owner.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
        owner.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
        owner.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
    }

    override function dispose():Void {
        owner.removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
        owner.removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
        owner.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
    }

    function mouseHandler(event:MouseEvent):Void {
        switch (event.type)
        {
            case MouseEvent.ROLL_OVER:
                isOver = true;
                owner.setState(ComponentState.OVER);
            case MouseEvent.ROLL_OUT:
                isOver = false;
                if (!isDown) {
                    owner.setState(ComponentState.DEFAULT);
                }
            case MouseEvent.MOUSE_DOWN:
                isDown = true;
                if (isToggle) {
                    isSelected = !isSelected;
                }
                owner.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
                owner.setState(ComponentState.DOWN);
            case MouseEvent.MOUSE_UP:
                isDown = false;
                owner.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
                if (isOver) {
                    owner.setState(ComponentState.OVER);
                }
                else {
                    owner.setState(ComponentState.DEFAULT);
                }
        }
    }

}