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

import box2D.collision.B2Manifold;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.contacts.B2Contact;
import hu.vpmedia.entity.BaseEntityComponent;
import hu.vpmedia.entity.commons.BodyTypes;
import hu.vpmedia.entity.commons.ShapeTypes;
import hu.vpmedia.entity.commons.CollisionCategories;

import hu.vpmedia.box2d.Box2DDef;
import box2D.common.math.B2Mat22;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2FilterData;
import box2D.dynamics.B2Fixture;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class Box2DPhysicsComponent extends BaseEntityComponent {
    private static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    private static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;
    private static var RAD_AREA:Float = Math.PI * 2;
    private static inline var DEG_AREA:Float = 360;

    private var _x:Float;
    private var _y:Float;
    private var _width:Float;
    private var _height:Float;
    private var _rotation:Float;
    private var _scale:Float;
// A body, which has a mass and a position.
    private var _body:B2Body;
// A fixture binds a shape to a body and adds material properties such as density, friction, and restitution.
    private var _fixtures:Array<B2Fixture>; /// An array of B2Fixtures - Get the shape by fixture.m_shape.
// fixture params
    private var _friction:Float;
    private var _restitution:Float; // Restitution measures how 'bouncy' a fixture is. 
    private var _density:Float;
    private var _isSensor:Bool;
    private var _conveyorBeltSpeed:Float;
// fixture contact event handler flags
    public var reportBeginContact:Bool;
    public var reportEndContact:Bool;
    public var reportPreSolve:Bool;
    public var reportPostSolve:Bool;
    public var bubbleContacts:Bool;
// body cats.
    private var _categoryBits:Int;
    private var _maskBits:Int;
    private var _groupIndex:Int;
// body params
    public var bodyType:BodyTypes;
    private var _isAllowSleep:Bool;
    private var _isBullet:Bool;
    private var _isAwake:Bool;
    private var _isActive:Bool;
    private var _fixedRotation:Bool;
    private var _linearDamping:Float;
    private var _angularDamping:Float;
    private var _angularVelocity:Float;
    private var _inertiaScale:Float;
// shape params
    public var shapeData:Array<Array<Array<Float>>>;
    public var shapeType:ShapeTypes;

    public function new(params:Dynamic = null) {
        _scale = Box2DDef.scale;

        _fixtures = new Array();

// body cats.
        _categoryBits = CollisionCategories.get([CollisionCategories.CATEGORY_LEVEL]);
        _maskBits = CollisionCategories.getAll();
//_categoryBits=1;
//_maskBits=1;
        _groupIndex = 0;
        _x = 0;
        _y = 0;
        _rotation = 0;
        width = 6;
        height = 6;
//
        bodyType = BodyTypes.DYNAMIC;
        shapeType = ShapeTypes.BOX;
//
        _linearDamping = 0;
        _angularDamping = 0;
        _angularVelocity = 0;
//
        _friction = 1;
        _restitution = 0;
        _density = 1;
//
        _inertiaScale = 1;
        _conveyorBeltSpeed = 0;
//
        bubbleContacts = true;
        _isAllowSleep = true;
        _isAwake = true;
        _isActive = true;
        _isBullet = false;

        super(params);
    }


    override function dispose():Void {
        Box2DDef.world.destroyBody(_body);
        _body = null;
        _fixtures = new Array();
    }

    override function initialize():Void {
        if (bodyType == BodyTypes.STATIC) {
            Box2DDef.body.type = B2Body.b2_staticBody;
        }
        else if (bodyType == BodyTypes.DYNAMIC) {
            Box2DDef.body.type = B2Body.b2_dynamicBody;
        }
        else if (bodyType == BodyTypes.KINEMATIC) {
            Box2DDef.body.type = B2Body.b2_kinematicBody;
        }
        Box2DDef.body.userData = this;
        Box2DDef.body.active = _isActive;
        Box2DDef.body.allowSleep = _isAllowSleep;
        Box2DDef.body.awake = _isAwake;
        Box2DDef.body.bullet = _isBullet;
        Box2DDef.body.position.x = _x;
        Box2DDef.body.position.y = _y;
        Box2DDef.body.angle = _rotation;
        Box2DDef.body.fixedRotation = _fixedRotation;
        Box2DDef.body.linearDamping = _linearDamping;
        Box2DDef.body.angularDamping = _angularDamping;
        Box2DDef.body.angularVelocity = _angularVelocity;
        Box2DDef.body.inertiaScale = _inertiaScale;
        _body = Box2DDef.world.createBody(Box2DDef.body);

        if (shapeType == ShapeTypes.BOX) {
            Box2DShapeFactory.box(this, width, height);
        }
        else if (shapeType == ShapeTypes.CIRCLE) {
            Box2DShapeFactory.circle(this, width * 0.5);
        }
        else if (shapeData != null) {
            Box2DShapeFactory.polys(this, shapeData);
            shapeType = ShapeTypes.DECOMPOSED;
        }
    }


//----------------------------------
//  Fixture getters/setters
//----------------------------------

    public function hasFixture():Bool {
        return _fixtures != null && _fixtures.length > 0;
    }

    public function getFirstFixture():B2Fixture {
        return _fixtures[0];
    }

    public function getFixtures():Array<B2Fixture> {
        return _fixtures;
    }

    public var friction(get_friction, set_friction):Float;

    function get_friction():Float {
        if (hasFixture())
            return _fixtures[0].getFriction();
        else
            return _friction;
    }

    function set_friction(value:Float):Float {
        _friction = value;
        if (_fixtures != null) {
            var n:Int = _fixtures.length;
            for (i in 0...n) {
                _fixtures[i].setFriction(value);
            }
        }
        return _friction;
    }

// restitution
    public var restitution(get_restitution, set_restitution):Float;

    function get_restitution():Float {
        if (hasFixture())
            return _fixtures[0].getRestitution();
        else
            return _restitution;
    }

    function set_restitution(value:Float):Float {
        _restitution = value;
        if (_fixtures != null) {
            var n:Int = _fixtures.length;
            for (i in 0...n) {
                _fixtures[i].setRestitution(value);
            }
        }
        return _restitution;
    }

// density
    public var density(get_density, set_density):Float;

    function get_density():Float {
        if (hasFixture())
            return getFirstFixture().getDensity();
        else
            return _density;
    }

    function set_density(value:Float):Float {
        _density = value;
        if (_fixtures != null) {
            var n:Int = _fixtures.length;
            for (i in 0...n) {
                _fixtures[i].setDensity(value);
            }
        }
        return _density;
    }

// sensor
    public var isSensor(get_isSensor, set_isSensor):Bool;

    function get_isSensor():Bool {
        if (hasFixture())
            return getFirstFixture().isSensor();
        else
            return _isSensor;
    }

    function set_isSensor(value:Bool):Bool {
        _isSensor = value;
        if (_fixtures != null) {
            var n:Int = _fixtures.length;
            for (i in 0...n) {
                _fixtures[i].setSensor(value);
            }
        }
        return _isSensor;
    }

// category bits
    public var categoryBits(get_categoryBits, set_categoryBits):Int;

    function set_categoryBits(value:Int):Int {
        _categoryBits = value;
        if (hasFixture()) {
            var n:Int = _fixtures.length;
            var i:Int;
            for (i in 0...n) {
                var b2f:B2FilterData = new B2FilterData();
                b2f.categoryBits = _categoryBits;
                _fixtures[i].setFilterData(b2f);
//_fixtures[i].Refilter();
            }
        }
        return _categoryBits;
    }

    function get_categoryBits():Int {
        if (hasFixture())
            return getFirstFixture().getFilterData().categoryBits;
        else
            return _categoryBits;
    }

// maskBits
    public var maskBits(get_maskBits, set_maskBits):Int;

    function set_maskBits(value:Int):Int {
        _maskBits = value;
        if (hasFixture()) {
            var n:Int = _fixtures.length;
            var i:Int;
            for (i in 0...n) {
                var b2f:B2FilterData = new B2FilterData();
                b2f.maskBits = _maskBits;
                _fixtures[i].setFilterData(b2f);
//_fixtures[i].Refilter();
            }
        }
        return _maskBits;
    }

    function get_maskBits():Int {
        if (hasFixture()) {
            return getFirstFixture().getFilterData().maskBits;
        }
        else {
            return _maskBits;
        }
    }

// ground index
    public var groupIndex(get_groupIndex, set_groupIndex):Int;

    function set_groupIndex(value:Int):Int {
        _groupIndex = value;
        if (hasFixture()) {
            var n:Int = _fixtures.length;
            var i:Int;
            for (i in 0...n) {
// _fixtures[i].m_filter.groupIndex=_groupIndex;
                var b2f:B2FilterData = new B2FilterData();
                b2f.groupIndex = _groupIndex;
                _fixtures[i].setFilterData(b2f);
//_fixtures[i].Refilter();
            }
        }
        return _groupIndex;
    }

    function get_groupIndex():Int {
        if (hasFixture()) {
            return getFirstFixture().getFilterData().groupIndex;
        }
        else {
            return _groupIndex;
        }
    }

//----------------------------------
//  Contact events
//----------------------------------

    public function handleBeginContact(contact:B2Contact):Void {

    }

    public function handleEndContact(contact:B2Contact):Void {

    }

    public function handlePreSolve(contact:B2Contact, oldManifold:B2Manifold):Void {

    }

    public function handlePostSolve(contact:B2Contact, impulse:B2ContactImpulse):Void {

    }

//----------------------------------
//  Body getters/setters
//----------------------------------

    public function getBody():B2Body {
        return _body;
    }

    public var width(get_width, set_width):Float;

    function get_width():Float {
        return _width * _scale;
    }

    function set_width(value:Float):Float {
        return _width = value / _scale;
    }

//
    public var height(get_height, set_height):Float;

    function get_height():Float {
        return _height * _scale;
    }

    function set_height(value:Float):Float {
        return _height = value / _scale;
    }

    public var x(get_x, set_x):Float;

    function get_x():Float {
        if (_body != null)
            return _body.getPosition().x * _scale;
        else
            return _x * _scale;
    }

    function set_x(value:Float):Float {
        _x = value / _scale;
        if (_body != null) {
            _body.setPosition(B2Vec2.make(_x, _y));
        }
        return _x;
    }

    public var y(get_y, set_y):Float;

    function get_y():Float {
        if (_body != null)
            return _body.getPosition().y * _scale;
        else
            return _y * _scale;
    }

    function set_y(value:Float):Float {
        _y = value / _scale;
        if (_body != null) {
            _body.setPosition(B2Vec2.make(_x, _y));
        }
        return _y;
    }


//
    public var rotation(get_rotation, set_rotation):Float;

    function get_rotation():Float {
        if (_body != null)
            return _body.getAngle() * RAD_TO_DEG % DEG_AREA; // TO TEST: % DEG_AREA is ok?
        else
            return _rotation * RAD_TO_DEG;
    }

    function set_rotation(value:Float):Float {
        _rotation = value * DEG_TO_RAD;
        if (_body != null) {
            _body.setAngle(_rotation);
        }
        return _rotation;
    }

//
    public var fixedRotation(get_fixedRotation, set_fixedRotation):Bool;

    function get_fixedRotation():Bool {
        if (_body != null)
            return _body.isFixedRotation();
        else
            return _fixedRotation;
    }

    function set_fixedRotation(value:Bool):Bool {
        _fixedRotation = value;
        if (_body != null)
            _body.setFixedRotation(value);
        return _fixedRotation;
    }

// bullet
    public var isBullet(get_isBullet, set_isBullet):Bool;

    function get_isBullet():Bool {
        if (_body != null)
            return _body.isBullet();
        else
            return _isBullet;
    }

    function set_isBullet(value:Bool):Bool {
        _isBullet = value;
        if (_body != null)
            _body.setBullet(value);
        return _isBullet;
    }

// angularVelocity
    public var angularVelocity(get_angularVelocity, set_angularVelocity):Float;

    function get_angularVelocity():Float {
        if (_body != null)
            return _body.getAngularVelocity();
        else
            return _angularVelocity;
    }

    function set_angularVelocity(value:Float):Float {
        _angularVelocity = value;
        if (_body != null)
            _body.setAngularVelocity(value);
        return _angularVelocity;
    }

// angularDamping
    public var angularDamping(get_angularDamping, set_angularDamping):Float;

    function get_angularDamping():Float {
        if (_body != null)
            return _body.getAngularDamping();
        else
            return _angularDamping;
    }

    function set_angularDamping(value:Float):Float {
        _angularDamping = value;
        if (_body != null)
            _body.setAngularDamping(value);
        return _angularDamping;
    }

//  linearDamping
    public var linearDamping(get_linearDamping, set_linearDamping):Float;

    function get_linearDamping():Float {
        if (_body != null)
            return _body.getLinearDamping();
        else
            return _linearDamping;
    }

    function set_linearDamping(value:Float):Float {
        _linearDamping = value;
        if (_body != null)
            _body.setLinearDamping(value);
        return _linearDamping;
    }

}