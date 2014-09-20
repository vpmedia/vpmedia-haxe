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

class SimpleMotionSystem extends BaseEntitySystem {
    public var nodeList:Dynamic;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        nodeList = world.getNodeList(SimpleMotionNode);
    }

    override function step(timeDelta:Float) {
        timeDelta = timeDelta * 100;

        var node:SimpleMotionNode = nodeList.head;
        while (node != null) {
// apply velocity
            node.position.x += node.motion.velocityX * timeDelta;
            node.position.y += node.motion.velocityY * timeDelta;
            if (node.position.x > 800) {
                node.position.x = 0;
            } else if (node.position.x < 0) {
                node.position.x = 800;
            }
            if (node.position.y > 600) {
                node.position.y = 0;
            } else if (node.position.y < 0) {
                node.position.y = 600;
            }
            node.position.rotation += node.motion.angularVelocity * timeDelta;
// trace(node.position.rotation);
// apply damping
            if (node.motion.damping > 0) {
                var xDamp:Float = Math.abs(Math.cos(node.position.rotation) * node.motion.damping * timeDelta);
                var yDamp:Float = Math.abs(Math.sin(node.position.rotation) * node.motion.damping * timeDelta);
                if (node.motion.velocityX > xDamp) {
                    node.motion.velocityX -= xDamp;
                }
                else if (node.motion.velocityX < -xDamp) {
                    node.motion.velocityX += xDamp;
                }
                else {
                    node.motion.velocityX = 0;
                }
                if (node.motion.velocityY > yDamp) {
                    node.motion.velocityY -= yDamp;
                }
                else if (node.motion.velocityY < -yDamp) {
                    node.motion.velocityY += yDamp;
                }
                else {
                    node.motion.velocityY = 0;
                }
            }

            node = node.next;
        }
    }

}
