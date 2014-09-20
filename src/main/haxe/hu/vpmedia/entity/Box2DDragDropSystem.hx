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
import box2D.dynamics.controllers.B2Controller;
import box2D.dynamics.joints.B2MouseJoint;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import hu.vpmedia.box2d.Box2DDef;
import flash.events.MouseEvent;
import flash.Lib;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DDragDropSystem extends BaseEntitySystem {
    private var _mouseJoint:B2MouseJoint;
    private var _isMouseDown:Bool;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler, false, 0, true);
    }

    public function mouseHandler(event:MouseEvent):Void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            _isMouseDown = true;
            return;
        }
        _isMouseDown = false;
    }

    override function step(timeDelta:Float):Void {
        var mp:B2Vec2 = new B2Vec2(world.context.stage.mouseX / Box2DDef.scale, world.context.stage.mouseY / Box2DDef.scale);
        var body:B2Body;
        if (_isMouseDown && _mouseJoint == null) {
            body = getBodyAtMouse(mp, false);
            if (body != null) {
                Box2DDef.mouseJoint.bodyA = Box2DDef.world.m_groundBody;
                Box2DDef.mouseJoint.bodyB = body;
                Box2DDef.mouseJoint.target = mp;
                Box2DDef.mouseJoint.collideConnected = true;
                Box2DDef.mouseJoint.maxForce = 300.0 * body.getMass();
                _mouseJoint = cast(Box2DDef.world.createJoint(Box2DDef.mouseJoint), B2MouseJoint);
                body.setAwake(true);
            }
        }
        if (!_isMouseDown && _mouseJoint != null) {
            Box2DDef.world.destroyJoint(_mouseJoint);
            _mouseJoint = null;
        }
        if (_mouseJoint != null) {
            _mouseJoint.setTarget(mp);
        }
    }

    public function getBodyAtMouse(mp:B2Vec2, includeStatic:Bool = false):B2Body {
        var body:B2Body = null;
        Box2DDef.world.queryPoint(function(f:B2Fixture):Bool {
            var b:B2Body = f.getBody();
            if (b.getType() == B2Body.b2_dynamicBody || includeStatic) {
                body = b;
                return false;
            }
            return true;
        }, mp);
        return body;
    }
}