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
// http://www.box2d.org/manual.html
// http://www.box2dflash.org/docs/2.0.2/manual
// https://github.com/jesses/wck/wiki/world-construction-kit
package hu.vpmedia.entity;

import hu.vpmedia.box2d.Box2DDef;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Fixture;

import flash.display.Graphics;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DSliceSystem extends BaseEntitySystem {
    private static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    private static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;

    public var nodeList:Dynamic;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);
        nodeList = world.getNodeList(Box2DSliceNode);
    }


    function onAdded(node:Box2DSliceNode):Void {
//trace(this, "onAdded", node);
        node.rayCast.onSliceCast.add(onSliceCast);
        node.rayCast.onFraction.add(onFraction);
        world.context.graphics.lineStyle(2, 0xE20074);
    }

    function onRemoved(node:Box2DSliceNode):Void {
//trace(this, "onRemoved", node);
        node.rayCast.onSliceCast.remove(onSliceCast);
    }

    function onStep(node:Box2DSliceNode, timeDelta:Float):Void {
        var rc:Box2DSliceComponent = node.rayCast;
        if (!rc.isBusy) {
            var v1:B2Vec2 = new B2Vec2(rc.x / Box2DDef.scale, rc.y / Box2DDef.scale);
            var tmp:B2Vec2 = new B2Vec2(rc.magnitude, 0);

// rotate
            var r:Float = rc.rotation * DEG_TO_RAD;
            var cos:Float = Math.cos(r);
            var sin:Float = Math.sin(r);
            tmp.set(tmp.x * cos - tmp.y * sin, tmp.x * sin + tmp.y * cos);
//tmp.rotate(rc.rotation * DEG_TO_RAD);
            var v2:B2Vec2 = v1.copy();
            v2.add(tmp);
            rc.doRayCast(v1, v2);
        }
    }

    function drawLaser(graphics:Graphics, lX:Float, lY:Float, draw:Bool = true):Void {
        if (draw) {
            graphics.lineTo(lX, lY);
        }
        else {
            graphics.moveTo(lX, lY);
        }
    }

    function drawCircle(graphics:Graphics, x:Float, y:Float, r:Float = 3):Void {
        graphics.drawCircle(x, y, r);
    }

    function onSliceCast(laser:Box2DSliceComponent):Void {
//trace(this, "onSliceCast", laser);
        var s:Float = Box2DDef.scale;
        world.context.graphics.lineStyle(2, 0xE20074);
        var sx:Float = laser.startPoint.x * s;
        var sy:Float = laser.startPoint.y * s;
        var fx:Float = laser.foundPoint.x * s;
        var fy:Float = laser.foundPoint.y * s;
        var ex:Float = laser.endPoint.x * s;
        var ey:Float = laser.endPoint.y * s;
        drawLaser(world.context.graphics, sx, sy, false);
        drawLaser(world.context.graphics, fx, fy, true);
//world.context.graphics.lineStyle(2, 0x999999);
//drawLaser(world.context.graphics, ex, ey, true);
//  drawLaser(world.context.graphics, fx, fy, false);
// normal (debug)
        world.context.graphics.lineStyle(0, 0, 0);
        world.context.graphics.beginFill(0xFFFF00, 1);
        drawCircle(world.context.graphics, fx, fy, 2);
        world.context.graphics.endFill();
        world.context.graphics.lineStyle(1, 0x0000FF);
        drawLaser(world.context.graphics, fx, fy, false);
        var normalEnd:B2Vec2 = laser.foundPoint.copy();
        normalEnd.add(laser.foundNormal);
        drawLaser(world.context.graphics, normalEnd.x * s, normalEnd.y * s, true);
        if (laser.isOpposite && laser.rotation < 420) {
            laser.rotation += 15;
            laser.reset();
        }
    }

    function onFraction(fixture:B2Fixture, point:B2Vec2, normal:B2Vec2, fraction:Float):Void {
//trace(this, "onFraction", fixture, point, normal, fraction, fixture.m_body.m_userData);
        var s:Float = Box2DDef.scale;
        world.context.graphics.lineStyle(1, 0xFFFFFF, 1);
        var fx:Float = point.x * s;
        var fy:Float = point.y * s;
        drawCircle(world.context.graphics, fx, fy, 2);
//
    }
}