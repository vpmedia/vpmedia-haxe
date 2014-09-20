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
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;
import flash.display.IGraphicsData;
import flash.Vector;
import hu.vpmedia.framework.BaseDisplayObject;

/*
 * http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Graphics.html#drawGraphicsData%28%29 
 */
class GraphicsDataShape extends BaseDisplayObject implements IBaseShape {
    public var data:Vector<IGraphicsData>;

    public var type:EShapeType;

    public var fill:IBaseGraphicsTexture;
    public var stroke:IBaseGraphicsTexture;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new(parent:DisplayObjectContainer, x:Int, y:Int, data:Vector<IGraphicsData>, ?drawAfter:Bool = true) {
        super();
        type = EShapeType.GRAPHICS_DATA;
        this.data = data;

        canvas = new Sprite();
        move(x, y);
        parent.addChild(canvas);
        if (drawAfter) {
            draw();
        }
    }

    public function clear():Void {
        canvas.graphics.clear();
    }

    public function draw():Void {
        canvas.graphics.clear();
        canvas.graphics.drawGraphicsData(data);
    }
}