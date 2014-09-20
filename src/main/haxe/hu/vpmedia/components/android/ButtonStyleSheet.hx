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
package hu.vpmedia.components.android;

import flash.text.TextFormat;
import hu.vpmedia.components.BaseStyleSheet;

class ButtonStyleSheet extends BaseStyleSheet {
    public function new() {
        super();
    }

    override function initialize():Void {
        setStyle("bgColor1:DEFAULT", Color.GREY_LIGHT_1);
        setStyle("bgColor2:DEFAULT", Color.GREY_LIGHT_2);
        setStyle("borderColor1:DEFAULT", Color.GREY_LIGHT_1);
        setStyle("borderColor2:DEFAULT", Color.WHITE);

        setStyle("bgColor1:OVER", Color.GREY_LIGHT_2);
        setStyle("bgColor2:OVER", Color.GREY_LIGHT_1);
        setStyle("borderColor1:OVER", Color.WHITE);
        setStyle("borderColor2:OVER", Color.GREY_LIGHT_1);

        setStyle("bgColor1:DOWN", Color.GREY_DARK_2);
        setStyle("bgColor2:DOWN", Color.GREY_MID_1);
        setStyle("borderColor1:DOWN", Color.GREY_LIGHT_1);
        setStyle("borderColor2:DOWN", Color.GREY_LIGHT_2);

        setStyle("textFormat:DEFAULT", new TextFormat("Arial", 11, Color.GREY_MID_1));
        setStyle("textFormat:OVER", new TextFormat("Arial", 11, Color.GREY_MID_2));
        setStyle("textFormat:DOWN", new TextFormat("Arial", 11, Color.WHITE));

        setStyle("ellipse", 10);
    }
}