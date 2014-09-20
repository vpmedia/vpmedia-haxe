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
package hu.vpmedia.entity.commons;

import hu.vpmedia.entity.BaseEntityComponent;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class DisplayComponent extends BaseEntityComponent {
    public var animation:String;
    public var inverted:Bool;
    public var registration:String;
    public var visible:Bool;
    public var layerIndex:Int;
    public var zIndex:Int;
    public var offsetX:Float;
    public var offsetY:Float;
    public var parallaxFactorX:Float;
    public var parallaxFactorY:Float;

    public function new(params:Dynamic = null) {
        animation = "default";
        visible = true;
        registration = AlignTypes.TOP_LEFT;
        layerIndex = 0;
        zIndex = 0;
        parallaxFactorX = 1;
        parallaxFactorY = 1;
        offsetX = 0;
        offsetY = 0;
        super(params);
    }

}