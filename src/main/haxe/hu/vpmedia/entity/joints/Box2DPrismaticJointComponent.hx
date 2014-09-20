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
import box2D.common.math.B2Vec2;
import box2D.dynamics.joints.B2PrismaticJoint;
import hu.vpmedia.box2d.Box2DDef;

import hu.vpmedia.entity.commons.JointTypes;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DPrismaticJointComponent extends Box2DBaseJointComponent {
    public function new(parameters:Dynamic = null) {
        jointType = JointTypes.PRISMATIC;
        super(parameters);
    }

    override function createJoint():Void {
        initJointDef(Box2DDef.prismaticJoint);
        Box2DDef.prismaticJoint.enableLimit = enableLimit;
        Box2DDef.prismaticJoint.lowerTranslation = lowerLimit;
        Box2DDef.prismaticJoint.upperTranslation = upperLimit;
        Box2DDef.prismaticJoint.enableMotor = enableMotor;
        Box2DDef.prismaticJoint.maxMotorForce = maxForce;
        Box2DDef.prismaticJoint.motorSpeed = motorSpeed;
        var anchor:B2Vec2 = b2body1.getWorldCenter();
        anchor.add(new B2Vec2(anchorX, anchorY));
        var axis:B2Vec2 = new B2Vec2(axisX, axisY);
        Box2DDef.prismaticJoint.initialize(b2body1, b2body2, anchor, axis);
        world.createJoint(Box2DDef.prismaticJoint);
    }
}