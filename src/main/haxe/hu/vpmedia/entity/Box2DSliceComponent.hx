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

import box2D.common.math.B2Vec2;
import box2D.common.math.B2Math;
import box2D.dynamics.B2Fixture;

import hu.vpmedia.box2d.Box2DDef;
import hu.vpmedia.signals.SignalLite;

import hu.vpmedia.entity.BaseEntityComponent;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DSliceComponent extends BaseEntityComponent {
    public var x:Float;
    public var y:Float;
    public var rotation:Float;
    public var isBusy:Bool;
    public var magnitude:Float;
    public var leftMagnitude:Float;
    public var stepMagnitude:Float;
    public var startPoint:B2Vec2;
    public var endPoint:B2Vec2;
    public var foundFixture:B2Fixture;
    public var foundPoint:B2Vec2;
    public var foundNormal:B2Vec2;
    public var foundFraction:Float;
    public var onSliceCast:Signal;
    public var onFraction:Signal;
    public var isOpposite:Bool;

    public function new(parameters:Dynamic = null) {
        rotation = 0;
        x = 0;
        y = 0;
        leftMagnitude = 0;
        stepMagnitude = 1;
        magnitude = 100;
        foundFraction = 1;
        super(parameters);
        onSliceCast = new Signal();
        onFraction = new Signal();
    }

    public function doRayCast(v1:B2Vec2, v2:B2Vec2):Void {
        trace("doRayCast", v1, v2);
        foundFraction = 1;
        isBusy = true;
        startPoint = new B2Vec2(v1.x, v1.y);
        endPoint = new B2Vec2(v2.x, v2.y);
        Box2DDef.world.rayCast(rayCastHandler, v1, v2);
        if (isOpposite) {
            onSliceCast.dispatch([this]);
        }
        else {
            onSliceCast.dispatch([this]);
            isOpposite = true;
            doRayCast(endPoint, startPoint);
        }
    }

    function rayCastHandler(fixture:B2Fixture, point:B2Vec2, normal:B2Vec2, fraction:Float):Float {
//isBusy=false;
//fixture.m_body.m_flags
        if (fraction == 1 || fraction == 0) {
            return -1;
        }
        if (fraction < foundFraction && !isOpposite) {
            foundFixture = fixture;
            foundPoint = point.copy();
            foundNormal = normal.copy();
            foundFraction = fraction;
            var foundLength:Float = B2Math.distance(startPoint, foundPoint);
            leftMagnitude -= foundLength;
            if (leftMagnitude < 0) {
                leftMagnitude = 0;
            }
// source plus normal
//var normalEnd:B2Vec2 = point.copy().add(normal);
            var remainingRay:B2Vec2 = endPoint.copy();
            remainingRay.subtract(point);
            var dot:Float = B2Math.dot(remainingRay, normal);
            var projectedOntoNormal:B2Vec2 = new B2Vec2(dot * 2 * normal.x, dot * 2 * normal.y);
            var nextEnd:B2Vec2 = endPoint.copy();
            nextEnd.subtract(projectedOntoNormal);
        }
        onFraction.dispatch([fixture, point, normal, fraction]);
//trace(this.toString(), "rayCastHandler", fixture.m_body.m_userData);
// return fraction; // nearest fraction
        return 1; // all fraction
    }

    override function dispose():Void {
//trace(this, "dispose");
        onSliceCast.removeAll();
        reset();
    }

//----------------------------------
//  API
//----------------------------------

    public function reset():Void {
//trace(this.toString(), "reset");
        startPoint = null;
        endPoint = null;
        foundFixture = null;
        foundPoint = null;
        foundNormal = null;
        foundFraction = 1;
        isOpposite = false;
        isBusy = false;
    }

    public function toString():String {
        return "[Laser {startPoint: " + startPoint + ", endPoint: " + endPoint + ", foundPoint: " + foundPoint + ", isBusy: " + isBusy + ", isOpposite: " + isOpposite + "}]";
    }
}