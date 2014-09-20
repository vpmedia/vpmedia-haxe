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

import flash.display.Sprite;

import nape.util.ShapeDebug;

class NapeDebugSystem extends BaseEntitySystem {
    public var debug:ShapeDebug;
    public var canvas:Sprite;

    public function new(priority:Int = 4, world:BaseEntityWorld) {
        super(priority, world);


        canvas = new Sprite();
        world.context.addChild(canvas);

        debug = new ShapeDebug(800, 600, 0xFFFFFF);
        debug.drawShapeAngleIndicators = true;
        debug.drawShapeDetail = true;
        debug.drawBodies = true;
        debug.drawBodyDetail = true;
        canvas.addChild(debug.display);
    }

    override function step(timeDelta:Float) {
        debug.clear();
        debug.draw(NapeDef.space);
        debug.flush();
    }

}
