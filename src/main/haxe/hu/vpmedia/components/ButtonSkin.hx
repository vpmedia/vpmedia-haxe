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

import flash.display.Sprite;

/**
 * Label class(textfield wrapper)
 */
class ButtonSkin extends BaseSkin {
    public var background:Panel;
    public var icon:Icon;
    public var label:Label;

//--------------------------------------
//  Constructor
//--------------------------------------
/**
     * Constructor
     */

    public function new(owner:BaseComponent) {
        super(owner);
    }

    override function createChildren():Void {
        super.createChildren();

        owner.canvas.buttonMode = true;
        owner.canvas.mouseChildren = false;

// Background
        background = new Panel(owner, owner.width, owner.height);
        background.addStatesFrom(owner);
///*
// Label
        label = new Label(owner);
        label.addStatesFrom(owner);

// Icon
        icon = new Icon(owner);
//*/
//icon.addStatesFrom(owner);
//icon = new Icon(content);
//icon.setParent(owner);
    }

    override function updateData():Void {
        super.updateData();
///*
        label.text = cast(owner, IBaseTextField).text;
        label.invalidate(ComponentChange.DATA, true, false);
//*/
    }

    override function updateStyle():Void {
        super.updateStyle();

//background.draw();
/* background.setStyle("bgColor1",owner.getStyleValue("bgColor1", true),true);
        background.setStyle("bgColor2",owner.getStyleValue("bgColor2", true),true);
        background.setStyle("borderColor1",owner.getStyleValue("borderColor1", true),true);
        background.setStyle("borderColor2",owner.getStyleValue("borderColor2", true),true);*/
    }

    override function updateState():Void {
        setCurrentStateToChilds();
    }

    override function updateSize():Void {
        super.updateSize();

        background.width = owner.width;
        background.height = owner.height;
// /*
        label.x = (owner.width - label.canvas.width) / 2;
        label.y = (owner.height - label.canvas.height) / 2;

        icon.x = label.x - icon.canvas.width - 5;
        icon.y = (owner.height - icon.canvas.height) / 2;
//*/
    }
}