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

import hu.vpmedia.ds.DoublyLinkedSignalList;

import box2D.collision.B2DynamicTreeBroadPhase;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;

class Box2DGravitySystem extends BaseEntitySystem {
    public var nodeList:Dynamic;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        nodeList = world.getNodeList(Box2DGravityNode);
    }

    override function step(timeDelta:Float) {
        var node:Box2DGravityNode = nodeList.head;
        while (node != null) {
            var _body:B2Body = node.box2dphysics.getBody();
            if (_body != null && _body.isAwake() && _body.getType() == B2Body.b2_dynamicBody) {
                var velocity:B2Vec2 = _body.getLinearVelocity();
                velocity.x += node.motion.velocityX;
                velocity.y += node.motion.velocityY;
                _body.setLinearVelocity(velocity);
            }
            node = node.next;
        }
    }

}
