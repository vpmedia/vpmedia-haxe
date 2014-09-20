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
package hu.vpmedia.entity.joints;
import box2D.dynamics.joints.B2Joint;
import box2D.dynamics.joints.B2JointDef;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import hu.vpmedia.box2d.Box2DDef;
import hu.vpmedia.entity.BaseEntityComponent;
import hu.vpmedia.entity.commons.JointTypes;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DBaseJointComponent extends BaseEntityComponent {
    public var b2joint:B2Joint;
    public var b2body1:B2Body;
    public var b2body2:B2Body;
    public var world:B2World;
    public var dispatcher:IEventDispatcher;
    public var collideConnected:Bool;
    public var maxForce:Float;
    public var maxTorque:Float;
    public var enableMotor:Bool;
    public var motorSpeed:Float;
    public var enableLimit:Bool;
    public var upperLimit:Float;
    public var lowerLimit:Float;
    public var enableSpring:Bool;
    public var springConstant:Float;
    public var springDamping:Float;
    public var frequencyHz:Float;
    public var dampingRatio:Float;
    public var pulleyGearRatio:Float;
    public var jointType:JointTypes;
    public var anchorX:Float;
    public var anchorY:Float;
    public var axisX:Float;
    public var axisY:Float;

    public static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    public static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;
    public static var RAD_AREA:Float = Math.PI * 2;
    public static inline var DEG_AREA:Float = 360;

    public function new(params:Dynamic = null) {
        maxForce = 0.0;
        maxTorque = 0.0;
        motorSpeed = 0.0;
        upperLimit = 0.0;
        lowerLimit = 0.0;
        springConstant = 0.0;
        springDamping = 0.0;
        frequencyHz = 5.0;
        dampingRatio = 0.7;
        pulleyGearRatio = 1.0;
        anchorX = 0;
        anchorY = 0;
        axisX = 0;
        axisY = 0;

        world = Box2DDef.world;
        dispatcher = new EventDispatcher();

        super(params);
    }

    function initJointDef(def:B2JointDef):Void {
        def.collideConnected = collideConnected;
        def.userData = this;
    }

    public function attach():Void {
        if (b2body2 == null) {
            b2body2 = world.getGroundBody();
        }
        createJoint();
    }

    override function dispose():Void {
//trace(this, "dispose");
        if (b2joint != null && b2joint.isActive()) {
// TODO
//b2joint.destroy();
            b2joint = null;
        }
    }

    function createJoint():Void {
// abstract
    }
}