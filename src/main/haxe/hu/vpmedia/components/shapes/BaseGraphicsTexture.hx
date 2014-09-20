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
package hu.vpmedia.components.shapes;

import flash.display.Graphics;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */

class BaseGraphicsTexture implements IBaseGraphicsTexture {
    private var _width:Float;
    private var _height:Float;
    public var colorType:EGraphicsTextureType;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new() {
    }

    public var width(get, set):Float;
    public var height(get, set):Float;

    function set_width(value:Float):Float {
        return _width = value;
    }

    function get_width():Float {
        return _width;
    }

    function set_height(value:Float):Float {
        return _height = value;
    }

    function get_height():Float {
        return _height;
    }

    public function setSize(w:Float, h:Float):Void {
        _width = w;
        _height = h;
    }

    public function draw(graphics:Graphics):Void {
// Override
    }
}