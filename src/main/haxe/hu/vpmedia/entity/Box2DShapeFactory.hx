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

import hu.vpmedia.box2d.Box2DDef;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Fixture;
import flash.geom.Point;
/**
 * @author Andras Csizmadia
 * @version 1.0
 */

class Box2DShapeFactory {
    private static var RAD_TO_DEG:Float = 180 / Math.PI; //57.29577951;
    private static var DEG_TO_RAD:Float = Math.PI / 180; //0.017453293;

// SHAPE DRAWING

    public static function box(target:Box2DPhysicsComponent, w:Float, h:Float, pos:B2Vec2 = null, angle:Float = 0):B2Fixture {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var halfWidth:Float = w / 2;
        var halfHeight:Float = h / 2;
        var vertices:Array<B2Vec2 >= [new B2Vec2(-halfWidth, -halfHeight), new B2Vec2(halfWidth, -halfHeight), new B2Vec2(halfWidth, halfHeight), new B2Vec2(-halfWidth, halfHeight)];
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

/**
 * Define a circle. If you don't pass a radius, it'll guess one from the width. Note: Skew transforms wont work, neither will non-uniform XY
 * scaling (an oval shape).
 */

    public static function circle(target:Box2DPhysicsComponent, radius:Float = 0, pos:B2Vec2 = null):B2Fixture {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var v1:B2Vec2 = pos.copy();
        var v:Array<B2Vec2 >= [v1, new B2Vec2(v1.x + radius, v1.y)];
        transformVertices(v);
        var distance:B2Vec2 = v[0].copy();
        distance.subtract(v[1]);
        Box2DDef.circle.setRadius(distance.length());
/*Box2DDef.circle.m_p.x=v[0].x;
    Box2DDef.circle.m_p.y=v[0].y;*/
        Box2DDef.circle.setLocalPosition(v[0]);
        defineFixture(target);
        Box2DDef.fixture.shape = Box2DDef.circle;
        return createFixture(target);
    }

/**
 * Define a stretchable circle.
 */

    public static function oval(target:Box2DPhysicsComponent, width:Float = 0, height:Float = 0, pos:B2Vec2 = null, sides:Int = 0, detail:Float = 4, angle:Float = 0):Array<B2Fixture> {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var w2:Float = width / 2;
        var h2:Float = height / 2;
/// TO DO: better way to detect circle shape?
        var p1:Point = new Point(w2, 0);
        var p2:Point = new Point(0, h2);
        var p3:Point = new Point(0, 0);
        var d1:Float = Point.distance(p1, p3);
        var d2:Float = Point.distance(p2, p3);
        var a:Float = Math.abs(d1 - d2);
        if (a < 2) { // Tolerance to snap to circle.
            return [circle(target, w2, pos)];
        }
        if (sides == 0) {
            var d:Float = Point.distance(p1, p2);
            sides = Math.round(d / Box2DDef.scale * detail);
        }
        var polys:Array<B2Fixture >= [];
        sides = Std.int(Math.max(sides, 12));

        var i = 0;
        while (i < sides) {
            var v:Array<B2Vec2 >= [new B2Vec2(w2, 0)];
            var j2:Int = Std.int(Math.min(i + 6, sides - 1));
            for (j in i...j2) {
                var rad:Float = j / sides * Math.PI * 2;
                v.push(new B2Vec2(w2 * Math.cos(rad), h2 * Math.sin(rad)));
            }
            orientVertices(v, pos, angle);
            polys.push(polygon(target, v));

            i += 6;
        }

        return polys;
    }

/**
 * Define a polygon with a variable number of sides.
 */

    public static function polyN(target:Box2DPhysicsComponent, sides:Int = 5, radius:Float = 0, pos:B2Vec2 = null, angle:Float = 0):B2Fixture {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var vertices:Array<B2Vec2 >= new Array();
        for (i in 0...sides) {
            var vec:B2Vec2 = rotate(new B2Vec2(0, radius), i / sides * Math.PI * 2);
            vertices.push(vec);
        }
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

/**
 * Creates a solid semi circle.
 */

    public static function arc(target:Box2DPhysicsComponent, degrees:Float = 360, sides:Int = 0, radius:Float = 0, pos:B2Vec2 = null, angle:Float = 0, detail:Float = 4):Array<B2Fixture> {
        if (pos == null) {
            pos = new B2Vec2();
        }
        sides = Std.int(Math.max(sides, 12)); // Arbitrary minimum - but since <0,0> is part of every poly, forces them to be convex.
        var rad:Float = DEG_TO_RAD * degrees;
        var polys:Array<B2Fixture >= [];
        var i = 0;
        while (i < sides) {
            var v:Array<B2Vec2 >= [new B2Vec2()];
            var j2:Int = Std.int(Math.min(i + 4, sides));
            for (j in i...j2) {
                var vec:B2Vec2 = rotate(new B2Vec2(0, radius), j / sides * rad);
                v.push(vec);
            }
            orientVertices(v, pos, angle);
            polys.push(polygon(target, v));
            i += 4;
        }
        return polys;
    }

/**
 * Creates a solie semi circle using edges.
 */

    public static function edgeArc(target:Box2DPhysicsComponent, degrees:Float = 360, sides:Int = 0, radius:Float = 0, pos:B2Vec2 = null, angle:Float = 0, detail:Float = 8):Array<B2Fixture> {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var rad:Float = DEG_TO_RAD * degrees;
        var v:Array<B2Vec2 >= new Array();
        for (i in 0...sides) {
            var vec:B2Vec2 = rotate(new B2Vec2(0, radius), (i) / sides * rad);
            v.push(vec);
        }
        orientVertices(v, pos, angle);
        return edges(target, v);
    }

/**
 * Creates a solid semi circle using lines (two point polygons).
 */

    public static function lineArc(target:Box2DPhysicsComponent, degrees:Float = 360, sides:Int = 0, radius:Float = 0, pos:B2Vec2 = null, angle:Float = 0, detail:Float = 8):Array<B2Fixture> {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var rad:Float = DEG_TO_RAD * degrees;
        var polys:Array<B2Fixture >= [];
        var v:Array<B2Vec2 >= [new B2Vec2(0, radius)];
        for (i in 0...sides) {
            var vec:B2Vec2 = rotate(new B2Vec2(0, radius), (i + 1) / sides * rad);
            v[1] = vec;
            orientVertices(v, pos, angle);
            polys.push(line(target, v[0], v[1]));
            v[0].x = v[1].x;
            v[0].y = v[1].y;
        }
        return polys;
    }

/**
 * A right triangle constructed in the same way as the "box" function but with the upper right vertex deleted.
 */

    public static function triangle(target:Box2DPhysicsComponent, w:Float = 0, h:Float = 0, pos:B2Vec2 = null, angle:Float = 0):B2Fixture {
        if (pos == null) {
            pos = new B2Vec2();
        }
        var halfWidth:Float = w / 2;
        var halfHeight:Float = h / 2;
        var vertices:Array<B2Vec2 >= [new B2Vec2(-halfWidth, -halfHeight), //new B2Vec2(halfWidth, -halfHeight),
        new B2Vec2(halfWidth, halfHeight), new B2Vec2(-halfWidth, halfHeight)];
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

/**
 * A single line from point 1 to 2 using a polygon.
 */

    public static function line(target:Box2DPhysicsComponent, v1:B2Vec2 = null, v2:B2Vec2 = null):B2Fixture {
        return polygon(target, [v1, v2]);
    }

/**
 * A single edge shape.
 */

    public static function edge(target:Box2DPhysicsComponent, v1:B2Vec2 = null, v2:B2Vec2 = null):B2Fixture {
        var e:Array<B2Fixture >= edges(target, [v1, v2]);
        return e[0];
    }

/**
 * Define a polygon. Pass in an array of vertices in [[x, y], [x, y], ...] format
 */

    public static function poly(target:Box2DPhysicsComponent, vertices:Array<Array<Float>>):B2Fixture {
        var v:Array<B2Vec2 >= new Array();
        for (i in 0...vertices.length) {
            v.push(new B2Vec2(vertices[i][0], vertices[i][1]));
        }
        return polygon(target, v);
    }

/**
 * Takes an array of polygon points - each is sent to the "poly" function.
 */

    public static function polys(target:Box2DPhysicsComponent, vertices:Array<Array<Array<Float>>>):Array<B2Fixture> {
        var a:Array<B2Fixture >= [];
        for (i in 0...vertices.length) {
            a.push(poly(target, vertices[i]));
        }
        return a;
    }

/**
 *
 */
/* public static function decomposedPoly(target:Box2DComponent, vertices:Array<Float>):Array<B2Vec2>
{
for (i in 0...vertices.length)
{
vertices[i]/=_scale;
}
var s:Array<b2PolygonShape>=b2PolygonShape.AsArray(vertices);
defineFixture();
var f:Array=[];
for (i=0; i < s.length; ++i)
{
Box2DDef.fixture.shape=s[i];
f.push(createFixture());
//s[i].destroy();
s[i]=null;
}
return f;
}*/

    public static function polygon(target:Box2DPhysicsComponent, vertices:Array<B2Vec2>):B2Fixture {
        transformVertices(vertices);
/// If the bodyshape has been flipped on its y or x axis, then vertices are in the wrong direction.
//b2PolygonShape.EnsureCorrectVertexDirection(vertices);
        Box2DDef.polygon.setAsArray(vertices);
        defineFixture(target);
        Box2DDef.fixture.shape = Box2DDef.polygon;
        return createFixture(target);
    }

    public static function edges(target:Box2DPhysicsComponent, vertices:Array<B2Vec2>):Array<B2Fixture> {
        transformVertices(vertices);
        defineFixture(target);
        Box2DDef.fixture.shape = Box2DDef.edge;
        var e:Array<B2Fixture >= [];
        for (i in 1...vertices.length) {
/*Box2DDef.edge.m_vertex1.v2=vertices[i - 1];
    Box2DDef.edge.m_vertex2.v2=vertices[i];
    Box2DDef.edge.m_hasVertex0=i > 1;
    Box2DDef.edge.m_hasVertex3=i + 1 < vertices.length;
    Box2DDef.edge.m_vertex0.v2=Box2DDef.edge.m_hasVertex0 ? vertices[i - 2] : new B2Vec2();
    Box2DDef.edge.m_vertex3.v2=Box2DDef.edge.m_hasVertex3 ? vertices[i + 1] : new B2Vec2();*/
            e.push(createFixture(target));
        }
        return e;
    }

    private static function defineFixture(target:Box2DPhysicsComponent):Void {
        Box2DDef.fixture.density = target.density;
        Box2DDef.fixture.friction = target.friction;
        Box2DDef.fixture.restitution = target.restitution;
        Box2DDef.fixture.isSensor = target.isSensor;
        Box2DDef.fixture.filter.categoryBits = target.categoryBits;
        Box2DDef.fixture.filter.maskBits = target.maskBits;
        Box2DDef.fixture.filter.groupIndex = target.groupIndex;
    }

    private static function createFixture(target:Box2DPhysicsComponent):B2Fixture {
        var _fixture:B2Fixture = target.getBody().createFixture(Box2DDef.fixture);
        target.getFixtures().push(_fixture);
/* _fixture.m_reportBeginContact=_reportBeginContact;
    _fixture.m_reportEndContact=_reportEndContact;
    _fixture.m_reportPreSolve=_reportPreSolve;
    _fixture.m_reportPostSolve=_reportPostSolve;
    _fixture.m_conveyorBeltSpeed=_conveyorBeltSpeed;
    _fixture.m_bubbleContacts=_bubbleContacts;*/
//_fixtureSignalSet=new FixtureSignalSet(_fixture);
        return _fixture;
    }

    private static function dot(a:B2Vec2, b:B2Vec2):Float {
        return a.x * b.x + a.y * b.y;
    }

    private static function rotate(v:B2Vec2, r:Float):B2Vec2 {
        var cos:Float = Math.cos(r);
        var sin:Float = Math.sin(r);
        return new B2Vec2(v.x * cos - v.y * sin, v.x * sin + v.y * cos);
    }

/**
 * Takes a polygon (list of vertices) and rotates, repositions them.
 */

    private static function orientVertices(vertices:Array<B2Vec2>, pos:B2Vec2 = null, angle:Float = 0):Void {
        if (pos == null) {
            pos = new B2Vec2();
        }
        if (angle != 0 || pos.x != 0 || pos.y != 0) {
            for (i in 0...vertices.length) {
                vertices[i] = rotate(vertices[i], DEG_TO_RAD * angle);
                vertices[i].add(pos);
            }
        }
    }

/**
 * Takes an array of vertices ([[x,y],[x,y]]) and transforms them based on their MovieClip transformation.
 */

    private static function transformVertices(vertices:Array<B2Vec2>):Void {
        for (i in 0...vertices.length) {
            vertices[i] = transformVertex(vertices[i]);
        }
    }

/**
 * Will take a flash X,Y within this object and return a new X,Y reflecting where that
 * X, Y is in Box2d dimentions.
 */

    private static function transformVertex(xy:B2Vec2):B2Vec2 {
//var p:Point=matrix.transformPoint(xy.toP());
        var p:Point = new Point(xy.x, xy.y);
        return new B2Vec2(p.x / Box2DDef.scale, p.y / Box2DDef.scale);
    }
}