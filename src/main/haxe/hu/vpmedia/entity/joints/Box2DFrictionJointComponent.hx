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
import hu.vpmedia.box2d.Box2DDef;

import hu.vpmedia.entity.commons.JointTypes;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DFrictionJointComponent extends Box2DBaseJointComponent {
    public function new(parameters:Dynamic = null) {
        jointType = JointTypes.FRICTION;
        super(parameters);
    }

    override function createJoint():Void {
        initJointDef(Box2DDef.frictionJoint);
        Box2DDef.frictionJoint.maxForce = maxForce;
        Box2DDef.frictionJoint.maxTorque = maxTorque;
        Box2DDef.frictionJoint.initialize(b2body1, b2body2, new B2Vec2());
        world.createJoint(Box2DDef.frictionJoint);
//b2joint=new b2FrictionJoint(world, Box2DDef.frictionJoint, _dispatcher);
    }
}