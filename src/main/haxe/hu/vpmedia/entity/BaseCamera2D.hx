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
package hu.vpmedia.entity;

import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseCamera2D {
    public var x:Float;
    public var y:Float;
    public var width:Int;
    public var height:Int;
    public var rotation:Float;
    public var zoom:Float;
    public var offset:Point;
    public var easing:Point;
    public var bounds:Rectangle;
    public var target:Dynamic;

    public function new(width:Int, height:Int) {

        this.width = width;
        this.height = height;
        initialize();
    }

    public function initialize():Void {
        this.bounds = new Rectangle(0, 0, width, height);
        this.x = 0;
        this.y = 0;
        this.rotation = 0;
        this.zoom = 1;
        this.offset = new Point(width / 2, height);
        this.easing = new Point(0.25, 0.05);
    }

    public function dispose():Void {
        target = null;
        bounds = null;
        offset = null;
        easing = null;
    }

    public function step(timeDelta:Float):Void {
        if (target != null) {
            var diffX:Float = (-target.x + offset.x) - x;
            var diffY:Float = (-target.y + offset.y) - y;
            var velocityX:Float = diffX * easing.x;
            var velocityY:Float = diffY * easing.y;
            x += velocityX;
            y += velocityY;
            if (bounds != null) {
                if (-x <= bounds.left)
                    x = -bounds.left;
                else if (-x + width >= bounds.right)
                    x = -bounds.right + width;
                if (-y <= bounds.top)
                    y = -bounds.top;
                else if (-y + height >= bounds.bottom)
                    y = -bounds.bottom + height;
            }
        }
    }
}