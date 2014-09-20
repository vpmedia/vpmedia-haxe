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

import hu.vpmedia.entity.BaseEntityComponent;
import hu.vpmedia.entity.commons.ShapeTypes;
import hu.vpmedia.entity.commons.BodyTypes;
import hu.vpmedia.entity.commons.CollisionCategories;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Circle;
import nape.shape.Shape;
import nape.geom.Vec2;

class NapePhysicsComponent extends BaseEntityComponent {
    public var width:Float;
    public var height:Float;
    public var body:Body;
    public var bodyType:BodyTypes;
    public var shape:Shape;
    public var shapeData:Array<Array<Array<Float>>>;
    public var shapeType:ShapeTypes;
    public var categoryBits:Int;
    public var maskBits:Int;

    public function new(params:Dynamic = null) {
        width = height = 6;
        shapeType = ShapeTypes.BOX;
        bodyType = BodyTypes.DYNAMIC;

        categoryBits = CollisionCategories.get([CollisionCategories.CATEGORY_LEVEL]);
        maskBits = CollisionCategories.getAll();


        super(params);
    }

    override function initialize():Void {
        if (bodyType == BodyTypes.STATIC) {
            body = new Body(BodyType.STATIC);
        }
        else if (bodyType == BodyTypes.DYNAMIC) {
            body = new Body(BodyType.DYNAMIC);
        }
        else if (bodyType == BodyTypes.KINEMATIC) {
            body = new Body(BodyType.KINEMATIC);
        }

//
        var vertices:Array<Vec2 >= new Array();

        if (shapeType == ShapeTypes.BOX) {
            vertices = Polygon.box(width, height);
            shape = new Polygon(vertices);
        }
        else if (shapeType == ShapeTypes.CIRCLE) {
            shape = new Circle(width * 0.5);
        }
        else if (shapeData != null) {
            vertices = Polygon.rect(0, 0, width, height);
            shapeType = ShapeTypes.DECOMPOSED;
            shape = new Polygon(vertices);
        }
        body.shapes.add(shape);

    }


    override function dispose():Void {

    }

}