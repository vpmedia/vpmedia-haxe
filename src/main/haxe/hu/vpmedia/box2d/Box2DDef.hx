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
package hu.vpmedia.box2d;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.collision.B2DistanceInput;
import box2D.collision.B2DistanceOutput;
import box2D.collision.B2SimplexCache;
import box2D.dynamics.joints.B2DistanceJointDef;
import box2D.dynamics.joints.B2FrictionJointDef;
import box2D.dynamics.joints.B2GearJointDef;
import box2D.dynamics.joints.B2LineJointDef;
import box2D.dynamics.joints.B2MouseJointDef;
import box2D.dynamics.joints.B2PrismaticJointDef;
import box2D.dynamics.joints.B2PulleyJointDef;
import box2D.dynamics.joints.B2RevoluteJointDef;
import box2D.dynamics.joints.B2WeldJointDef;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
/**
     * Holds static Box2D definition objects that can be reused for performance.
     */
class Box2DDef {

    public static var world:B2World;
    public static var scale:Float;
/// Body, shape, fixture & joint defs that can be reused for performance.
    public static var body:B2BodyDef;
    public static var fixture:B2FixtureDef;
    public static var polygon:B2PolygonShape;
    public static var circle:B2CircleShape;
    public static var edge:B2PolygonShape; //B2EdgeShape;
    public static var loop:B2PolygonShape; //B2LoopShape;
    public static var distanceJoint:B2DistanceJointDef;
    public static var gearJoint:B2GearJointDef;
    public static var lineJoint:B2LineJointDef;
    public static var mouseJoint:B2MouseJointDef;
    public static var prismaticJoint:B2PrismaticJointDef;
    public static var pulleyJoint:B2PulleyJointDef;
    public static var revoluteJoint:B2RevoluteJointDef;
    public static var weldJoint:B2WeldJointDef;
    public static var frictionJoint:B2FrictionJointDef;
//public static var ropeJoint:B2RopeJointDef;
/// Reusable B2Distance objects.
    public static var distanceInput:B2DistanceInput;
    public static var distanceOutput:B2DistanceOutput;
    public static var simplexCache:B2SimplexCache;

/**
     * Create static definition objects. Can be re-called to re-initialize.
     */

    public static function initialize():Void {
        if (body != null) {
            destroy();
        }
        body = new B2BodyDef();
        fixture = new B2FixtureDef();
        polygon = new B2PolygonShape();
        circle = new B2CircleShape();
        edge = new B2PolygonShape(); //B2EdgeShape();
        loop = new B2PolygonShape(); //B2LoopShape();
        distanceJoint = new B2DistanceJointDef();
        gearJoint = new B2GearJointDef();
        lineJoint = new B2LineJointDef();
        mouseJoint = new B2MouseJointDef();
        prismaticJoint = new B2PrismaticJointDef();
        pulleyJoint = new B2PulleyJointDef();
        revoluteJoint = new B2RevoluteJointDef();
        weldJoint = new B2WeldJointDef();
        frictionJoint = new B2FrictionJointDef();
//ropeJoint = new B2RopeJointDef();
        distanceInput = new B2DistanceInput();
        distanceOutput = new B2DistanceOutput();
        simplexCache = new B2SimplexCache();
    }

/**
     * Destroy all definitions.
     */

    public static function destroy():Void {
        if (body == null) {
            return;
        }
/* body.destroy();
         fixture.destroy();
         polygon.destroy();
         circle.destroy();
         edge.destroy();
         loop.destroy();
         distanceJoint.destroy();
         gearJoint.destroy();
         lineJoint.destroy();
         mouseJoint.destroy();
         prismaticJoint.destroy();
         pulleyJoint.destroy();
         revoluteJoint.destroy();
         weldJoint.destroy();
         frictionJoint.destroy();
         ropeJoint.destroy();*/
        body = null;
        fixture = null;
        polygon = null;
        circle = null;
        edge = null;
        loop = null;
        distanceJoint = null;
        gearJoint = null;
        lineJoint = null;
        mouseJoint = null;
        prismaticJoint = null;
        pulleyJoint = null;
        revoluteJoint = null;
        weldJoint = null;
        frictionJoint = null;
// ropeJoint=null;
/*  distanceInput.destroy();
          distanceOutput.destroy();
          simplexCache.destroy();*/
        distanceInput = null;
        distanceOutput = null;
        simplexCache = null;
    }
}