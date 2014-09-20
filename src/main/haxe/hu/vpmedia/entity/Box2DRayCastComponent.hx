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
class Box2DRayCastComponent extends BaseEntityComponent {
    private static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    private static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;


    public var x:Float;
    public var y:Float;
    public var rotation:Float;
    public var isBusy:Bool;
    public var isDirty:Bool;
    public var hasFound:Bool;
    public var magnitude:Float;
    public var totalMagnitude:Float;
    public var maxMagniude:Float;
    public var leftMagnitude:Float;
    public var stepMagnitude:Float;
    public var maxReflection:Int;
    public var numReflection:Int;
    public var startPoint:B2Vec2;
    public var endPoint:B2Vec2;
    public var foundFixture:B2Fixture;
    public var foundPoint:B2Vec2;
    public var foundNormal:B2Vec2;
    public var foundFraction:Float;
    public var reflectionRotation:Float;
    public var onRayCast:Signal;

    public function new(parameters:Dynamic = null) {
        onRayCast = new Signal();
        reflectionRotation = 0;
        foundFraction = 1;
        numReflection = 0;
        maxReflection = 16;
        stepMagnitude = 1;
        leftMagnitude = 0;
        maxMagniude = 100;
        totalMagnitude = 0;
        isDirty = true;
        magnitude = 1;
        rotation = 0;
        x = 0;
        y = 0;
        super(parameters);
    }

    public function doRayCast(v1:B2Vec2, v2:B2Vec2):Void {
        foundFraction = 1;
        isBusy = true;
        hasFound = false;
        startPoint = new B2Vec2(v1.x, v1.y);
        endPoint = new B2Vec2(v2.x, v2.y);
        Box2DDef.world.rayCast(rayCastHandler, v1, v2);
        if (hasFound) {
            isDirty = false;
            numReflection++;
            onRayCast.dispatch([this]);
        }
        else {
            foundPoint = endPoint.copy();
            onRayCast.dispatch([this]);
        }
//trace(this.toString(), "doRayCast");
    }

    function rayCastHandler(fixture:B2Fixture, point:B2Vec2, normal:B2Vec2, fraction:Float):Float {
        isBusy = false;
        if (fixture.isSensor()) {
            return -1;
        }
//fixture.m_body.m_flags
        if (fraction == 1 || fraction == 0) {
            return -1;
        }
        if (fraction < foundFraction) {
            foundFixture = fixture;
            foundPoint = point.copy();
            foundNormal = normal.copy();
            foundFraction = fraction;
            var foundLength:Float = B2Math.distance(startPoint, foundPoint);
            leftMagnitude -= foundLength;
            if (leftMagnitude < 0) {
                leftMagnitude = 0;
            }
            totalMagnitude += foundLength;
// source plus normal
//var normalEnd:B2Vec2 = point.copy().add(normal);
            var remainingRay:B2Vec2 = endPoint.copy();
            remainingRay.subtract(point);
            var dot:Float = B2Math.dot(remainingRay, normal);
            var projectedOntoNormal:B2Vec2 = new B2Vec2(dot * 2 * normal.x, dot * 2 * normal.y);
            var nextEnd:B2Vec2 = endPoint.copy();
            nextEnd.subtract(projectedOntoNormal);
// reflection
            reflectionRotation = Math.atan2(nextEnd.y - point.y, nextEnd.x - point.x) * RAD_TO_DEG;
// continue path
//reflectionRotation = _rotation * RAD_TO_DEG;
// retraction - TODO
//reflectionRotation = _rotation * ret * RAD_TO_DEG;
        }
        hasFound = true;
//trace(this.toString(), "rayCastHandler", fixture.m_body.m_userData);
        return fraction;
    }

    override function dispose():Void {
//trace(this, "dispose");
        onRayCast.removeAll();
    }

    public function next():Void {
        trace(this, "next");
        x = foundPoint.x * Box2DDef.scale;
        y = foundPoint.y * Box2DDef.scale;
        rotation = reflectionRotation;
        updateMagnitude();
        isBusy = false;
        isDirty = true;
//trace(this.toString(), "next");
    }

    public function reset():Void {
        startPoint = null;
        endPoint = null;
        foundFixture = null;
        foundPoint = null;
        foundNormal = null;
        foundFraction = 1;
        reflectionRotation = 0;
        numReflection = 0;
        leftMagnitude = totalMagnitude;
        totalMagnitude = 0;
        updateMagnitude();
//trace(this.toString(), "reset");
    }

    function updateMagnitude():Void {
        if (leftMagnitude > 0) {
            magnitude = leftMagnitude;
        }
        else {
            magnitude = 1;
        }
//trace(this.toString(), "updateMagnitude");
    }

    public function toString():String {
        return "[Laser {magnitude:" + magnitude + ", totalMagnitude: " + totalMagnitude + ", leftMagnitude: " + leftMagnitude + ", isBusy: " + isBusy + ", isDirty: " + isDirty + ", hasFound: " + hasFound + "}]";
    }
}