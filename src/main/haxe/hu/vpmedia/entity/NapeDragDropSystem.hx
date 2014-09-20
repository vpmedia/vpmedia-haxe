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

import nape.space.Space;
import nape.geom.Vec2;
import nape.constraint.PivotJoint;
import nape.constraint.Constraint;

import flash.Lib;
import flash.events.MouseEvent;

class NapeDragDropSystem extends BaseEntitySystem {
    public var physics:Space;
    public var hand:PivotJoint;

    public static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    public static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        physics = NapeDef.space;

        hand = new PivotJoint(physics.world, physics.world, new Vec2(), new Vec2());
        hand.stiff = false;
        hand.space = physics;
        hand.active = false;

        Lib.current.addEventListener(MouseEvent.MOUSE_DOWN, function(_) {
            var mp = new Vec2(Lib.current.mouseX, Lib.current.mouseY);
            for (b in physics.bodiesUnderPoint(mp)) {
                if (!b.isDynamic()) continue;
                hand.body2 = b;
                // TODO: change worldToLocal to new impl.
                //hand.anchor2 = b.worldToLocal(mp);
                hand.active = true;
            }
        });
        Lib.current.addEventListener(MouseEvent.MOUSE_UP, function(_) {
            hand.active = false;
        });
    }

    override function step(timeDelta:Float) {
        hand.anchor1.setxy(Lib.current.mouseX, Lib.current.mouseY);
    }

}
