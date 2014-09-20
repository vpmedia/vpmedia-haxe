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

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
/**
 * Label class(textfield wrapper)
 */
class LabelSkin extends BaseSkin {
    public var textField:TextField;

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

        textField = new TextField();
        owner.addChild(textField);
    }

    override function updateData():Void {
        super.updateData();

        textField.htmlText = cast(owner, IBaseTextField).text;
//trace(textField.text);
    }

    override function updateStyle():Void {
        super.updateStyle();

        textField.selectable = owner.getStyleValue("selectable");
        textField.multiline = owner.getStyleValue("multiline");
        textField.defaultTextFormat = owner.getStyleValue("textFormat", true);
        textField.setTextFormat(owner.getStyleValue("textFormat", true));
        textField.autoSize = owner.getStyleValue("autoSize");
        textField.type = owner.getStyleValue("type");

/* if (textField.autoSize != TextFieldAutoSize.NONE)
        {
            owner.invalidate(ComponentChange.SIZE);
        }*/
    }

    override function updateSize():Void {
        super.updateSize();

        if (textField.autoSize == TextFieldAutoSize.NONE) {
            textField.width = owner.width;
            textField.height = owner.height;
        }
    }
}