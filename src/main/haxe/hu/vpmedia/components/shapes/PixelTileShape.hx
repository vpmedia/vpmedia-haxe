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
import flash.display.DisplayObjectContainer;

class PixelTileShape extends BaseShape {
    public static var ZOOM:Int = 1;
    public var data:Array<String>;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new(parent:DisplayObjectContainer, x:Int, y:Int, data:Array<String>, ?fill:IBaseGraphicsTexture = null, ?drawAfter:Bool = true) {
        type = EShapeType.PIXEL_TILE;
        this.data = data;
        super(parent, x, y, 1, 1, fill, null, drawAfter);
    }

    override function drawGeometry():Void {
        var maxRows:Int = data.length;
        var maxColumns:Int = 0;
        var row:Int;
        var col:Int;
        var s:String;
        for (row in 0...maxRows) {
            maxColumns = data[row].length;
            for (col in 0...maxColumns) {
                s = cast(data[row], String);
                if (s.charAt(col) != " ") {
                    canvas.graphics.drawRect(col * ZOOM, row * ZOOM, ZOOM, ZOOM);
                }
            }
        }
        width = maxColumns * ZOOM;
        height = maxRows * ZOOM;

    }
}