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
// http://www.box2d.org/manual.html
// http://www.box2dflash.org/docs/2.0.2/manual
// https://github.com/jesses/wck/wiki/world-construction-kit
package hu.vpmedia.entity;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import flash.ui.Keyboard;
import hu.vpmedia.utils.KeyInput;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DControlSystem extends BaseEntitySystem {
    private static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    private static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;

// config
    var acceleration:Float;
    var maxVelocity:Float;
    var jumpHeight:Float;
    var jumpAcceleration:Float;
// base
    var _groundContacts:Array<Dynamic>; //Used to determine if he's on ground or not.      
    var _lastFriction:Float;
    var _isOnGround:Bool;
    var _isMoving:Bool;
    var _isMovePressed:Bool;

    var keyboard:KeyInput;

    public var nodeList:Dynamic;

    public function new(priority:Int = 3, world:BaseEntityWorld) {
        super(priority, world);
        keyboard = new KeyInput();
        _groundContacts = [];
        jumpAcceleration = 2;
        _lastFriction = 0;
        jumpHeight = 10;
        maxVelocity = 8;
        acceleration = 1;
        nodeList = world.getNodeList(Box2DControlNode);
    }

    function onAdded(node:Box2DControlNode):Void {
//node.box2dphysics.isAllowSleep=false;
//node.box2dphysics.reportBeginContact=true;
//node.box2dphysics.reportEndContact=true;
//node.box2dphysics.addFixtureListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
//node.box2dphysics.addFixtureListener(ContactEvent.END_CONTACT, handleEndContact);
    }

    function onRemoved(node:Box2DControlNode):Void {
//node.box2dphysics.removeFixtureListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
//node.box2dphysics.removeFixtureListener(ContactEvent.END_CONTACT, handleEndContact);
    }

/*function handleBeginContact(e:ContactEvent):Void
    {
        trace(e);
        //Collision angle
        if (e.normal) //The normal property doesn't come through all the time. I think doesn't come through against sensors.
        {
        var collisionAngle:Float=Math.atan2(e.normal.y, e.normal.x) * RAD_TO_DEG;
        if (collisionAngle > 45 && collisionAngle < 135)
        {
            _groundContacts.push(e.other);
            _isOnGround=true;
        }
        }
    }
    
    function handleEndContact(e:ContactEvent):Void
    {
        trace(e);
        //Remove from ground contacts, if it is one.
        var index:Int=_groundContacts.indexOf(e.other);
        if (index != -1)
        {
        _groundContacts.splice(index, 1);
        if (_groundContacts.length == 0)
            _isOnGround=false;
        }
    }*/


    override function step(timeDelta:Float) {
        keyboard.step(timeDelta);
        super.step(timeDelta);
    }


    function onStep(node:Box2DControlNode, timeDelta:Float):Void {
        if (node.control.allowKeyboard) {
            var body:B2Body = node.box2dphysics.getBody();
            var velocity:B2Vec2 = body.getLinearVelocity();
            _isMovePressed = false;
            if (keyboard.isDown(Keyboard.RIGHT)) {
                velocity.x += (acceleration);
                _isMovePressed = true;
            }
            if (keyboard.isDown(Keyboard.LEFT)) {
                velocity.x -= (acceleration);
                _isMovePressed = true;
            }
//If player just started moving the hero this tick.
            if (_isMovePressed && !_isMoving) {
                _isMoving = true;
                if (node.box2dphysics.friction != 0)
                    _lastFriction = node.box2dphysics.friction;
                node.box2dphysics.friction = 0; //Take away friction so he can accelerate.
            }
//Player just stopped moving the hero this tick.
            else if (!_isMovePressed && _isMoving) {
                _isMoving = false;
                node.box2dphysics.friction = _lastFriction;
            }
            if (_isOnGround && keyboard.justPressed(Keyboard.SPACE)) {
                velocity.y = -jumpHeight;
            }
            if (keyboard.isDown(Keyboard.SPACE) && !_isOnGround && velocity.y < 0) {
                velocity.y -= jumpAcceleration;
            }
//Cap velocities
            if (velocity.x > (maxVelocity))
                velocity.x = maxVelocity;
            else if (velocity.x < (-maxVelocity))
                velocity.x = -maxVelocity;
//update physics with new velocity
// trace(_isDucking, _isMovePressed, _isMoving, _isOnGround);
            body.setLinearVelocity(velocity);
        }
    }
}