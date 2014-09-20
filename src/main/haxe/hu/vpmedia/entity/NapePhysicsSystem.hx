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
import hu.vpmedia.entity.commons.BodyTypes;
import hu.vpmedia.entity.commons.CollisionCategories;

import nape.geom.AABB;
import nape.geom.Vec2;

import nape.space.Broadphase;
import nape.space.Space;

import nape.util.ShapeDebug;

import nape.phys.Body;
import nape.phys.BodyType;

class NapePhysicsSystem extends BaseEntitySystem {
    public var nodeList:Dynamic;

    public var bounds:AABB;
    public var physics:Space;
    public var gravity:Vec2;
    public var broadphase:Broadphase;

    public static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    public static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        gravity = new Vec2(0, 200);

        bounds = new AABB(0, 0, 800, 600);
        physics = new Space(gravity, broadphase);
        NapeDef.space = physics;

        CollisionCategories.setDefaults();

        nodeList = world.getNodeList(NapePhysicsNode);
        nodeList.nodeAdded.add(onNodeAdded);
        nodeList.nodeRemoved.add(onNodeRemoved);
    }

    public function onNodeAdded(node:NapePhysicsNode) {
        node.napephysics.body.position.x = node.position.x;
        node.napephysics.body.position.y = node.position.y;
        node.napephysics.body.rotation = node.position.rotation;
        node.napephysics.body.space = physics;
    }

    public function onNodeRemoved(node:NapePhysicsNode) {
    }

    override function step(timeDelta:Float) {
        physics.step(timeDelta, 8, 4);

        var node:NapePhysicsNode = nodeList.head;
        while (node != null) {
            if (node.napephysics.bodyType != BodyTypes.STATIC) {
                node.position.x = node.napephysics.body.position.x;
                node.position.y = node.napephysics.body.position.y;
                node.position.rotation = node.napephysics.body.rotation * RAD_TO_DEG;
            }
            node = node.next;
        }
    }

}
