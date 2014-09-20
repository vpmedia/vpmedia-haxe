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

import haxe.ds.GenericStack;

import hxBehaviors.Vehicle;
import hxBehaviors.VehicleGroup;
import hxBehaviors.behavior.Arrival;
import hxBehaviors.behavior.Flee;
import hxBehaviors.behavior.Seek;
import hxBehaviors.behavior.Wander;
using hxBehaviors.Float3DTools;

import flash.geom.Vector3D;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Steering3DSystem extends BaseEntitySystem {
    public var nodeList:Dynamic;
    public var group:VehicleGroup;
    public var list:GenericStack<Vehicle>;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        list = new GenericStack<Vehicle>();
        group = new VehicleGroup();
        nodeList = world.getNodeList(Steering3DNode);
        nodeList.nodeAdded.add(onAdded);
        nodeList.nodeRemoved.add(onRemoved);
    }

    function onAdded(node:Steering3DNode):Void {
        list.add(node.steering3d.vehicle);

/*flocking.separate.separateList = flocking.align.alignList = flocking.cohere.cohereList = fxObjs;
        flocking.cohere.cohereDist = 50;
        flocking.cohere.cohereStrength = 12;
        flocking.align.alignDist = 60;
        flocking.align.alignStrength = 18;
        flocking.separate.separateDist = 20;
        flocking.separate.separateStrength = 20;*/

        var seek:Seek = new Seek(new Vector3D(100, 100, 0));
        var flee:Flee = new Flee(new Vector3D(0, 400, 0));
        var arrival:Arrival = new Arrival(new Vector3D(50, 50, 0));
        var wander:Wander = new Wander();

        node.steering3d.vehicle.position.setUnitRandom();
        node.steering3d.vehicle.position.scaleBy(200);
        node.steering3d.vehicle.velocity.setUnitRandom();
        node.steering3d.vehicle.boundsRadius = 500;
        node.steering3d.vehicle.behaviorList = cast([wander, seek], Array<Dynamic>);
        group.addVehicle(node.steering3d.vehicle);
    }

    function onRemoved(node:Steering3DNode):Void {
        group.removeVehicle(node.steering3d.vehicle);
    }

    override function step(timeDelta:Float) {
        group.update();

        var node:Steering3DNode = nodeList.head;
        while (node != null) {
            node.position.x = node.steering3d.vehicle.position.x + 400;
            node.position.y = node.steering3d.vehicle.position.y + 300;
            node = node.next;
        }
    }
}