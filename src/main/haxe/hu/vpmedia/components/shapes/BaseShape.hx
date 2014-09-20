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

import hu.vpmedia.framework.BaseDisplayObject;
import flash.display.Sprite;
import flash.display.DisplayObjectContainer;

/**
 * @author Andras Csizmadia
 * @version 1.0
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Graphics.html#lineStyle%28%29
 */
class BaseShape extends BaseDisplayObject implements IBaseShape {
    public var fill:IBaseGraphicsTexture;
    public var stroke:IBaseGraphicsTexture;

    public var type:EShapeType;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new(parent:DisplayObjectContainer, x:Int, y:Int, width:Float, height:Float, ?fill:IBaseGraphicsTexture = null, ?stroke:IBaseGraphicsTexture = null, ?drawAfter:Bool = true) {
        super();
//
        _width = width;
        _height = height;
//
        move(x, y);
        parent.addChild(canvas);
//
        if (fill != null) {
            this.fill = fill;
        }
        if (stroke != null) {
            this.stroke = stroke;
        }
        if (drawAfter) {
            draw();
        }
    }

//----------------------------------
//  API
//----------------------------------

    public function draw():Void {
        canvas.graphics.clear();

        if (hasFill()) {
            fill.width = width;
            fill.height = height;
            fill.draw(canvas.graphics);
        }
        if (hasStroke()) {
            stroke.width = width;
            stroke.height = height;
            stroke.draw(canvas.graphics);
        }

        drawGeometry();

        canvas.graphics.endFill();
    }

    public function drawGeometry():Void {
// abstract
    }

    public function clear():Void {
        canvas.graphics.clear();
    }

    public function hasStroke():Bool {
        return stroke != null;
    }

    public function hasSolidStroke():Bool {
        return hasStroke() && stroke.colorType == EGraphicsTextureType.SOLID;
    }

    public function hasGradientStroke():Bool {
        return hasStroke() && stroke.colorType == EGraphicsTextureType.GRADIENT;
    }

    public function hasFill():Bool {
        return fill != null;
    }

    public function hasSolidFill():Bool {
        return hasFill() && fill.colorType == EGraphicsTextureType.SOLID;
    }

    public function hasGradientFill():Bool {
        return hasFill() && fill.colorType == EGraphicsTextureType.GRADIENT;
    }

    public function hasBitmapFill():Bool {
        return hasFill() && fill.colorType == EGraphicsTextureType.BITMAP;
    }
}