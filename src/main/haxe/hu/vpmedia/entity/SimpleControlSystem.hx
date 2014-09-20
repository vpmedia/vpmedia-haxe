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
import flash.ui.Keyboard;
import hu.vpmedia.utils.KeyInput;

class SimpleControlSystem extends BaseEntitySystem {
    public var nodeList:Dynamic;

    private var acceleration:Float;
    private var rotateSpeed:Float;
    private var maxSpeed:Float;
    private var friction:Float;

    var keyboard:KeyInput;

    public function new(priority:Int, world:BaseEntityWorld) {
        super(priority, world);

        keyboard = new KeyInput();

        acceleration = 0.3;
        rotateSpeed = 5;
        maxSpeed = 5;
        friction = 0.95;

        nodeList = world.getNodeList(SimpleControlNode);
    }

    override function step(timeDelta:Float) {
        keyboard.step(timeDelta);

        timeDelta = timeDelta * 100;

        var node:SimpleControlNode = nodeList.head;
        while (node != null) {
            if (node.control.allowKeyboard) {
                if (keyboard.isDown(Keyboard.UP)) {
                    node.motion.velocityX += Math.cos((node.position.rotation - 90) * Math.PI / 180) * acceleration;
                    node.motion.velocityY += Math.sin((node.position.rotation - 90) * Math.PI / 180) * acceleration;
                }
                else {
                    node.motion.velocityX *= friction;
                    node.motion.velocityY *= friction;
                }

// Maintain speed limit
                var currentSpeed:Float = Math.sqrt((node.motion.velocityX * node.motion.velocityX) + (node.motion.velocityY * node.motion.velocityY));
                if (currentSpeed > maxSpeed) {
                    node.motion.velocityX *= maxSpeed / currentSpeed;
                    node.motion.velocityY *= maxSpeed / currentSpeed;
                }
                if (keyboard.isDown(Keyboard.RIGHT)) {
                    node.position.rotation += rotateSpeed;
                }
                else if (keyboard.isDown(Keyboard.LEFT)) {
                    node.position.rotation -= rotateSpeed;
                }
            }

            node = node.next;
        }
    }

}
