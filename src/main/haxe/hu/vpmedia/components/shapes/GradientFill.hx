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
package hu.vpmedia.components.shapes;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
class GradientFill extends BaseGraphicsTexture {
    public var colors:Array<GradientItem>;
    public var matrix:Matrix;
    public var rotation:Float;
    public var type:GradientType;
    public var spreadMethod:SpreadMethod;
    public var interpolationMethod:InterpolationMethod;
    public var focalPtRatio:Float;
    public var gradientColors:Array<UInt>;
    public var gradientAlphas:Array<Float>;
    public var gradientRatios:Array<UInt>;

//--------------------------------------
//  Constructor
//--------------------------------------

    public function new(colors:Array<GradientItem>) {
        super();
        setColors(colors);
        rotation = 90;
        focalPtRatio = 0;
        type = GradientType.LINEAR;
        spreadMethod = SpreadMethod.PAD;
        interpolationMethod = InterpolationMethod.RGB;
        colorType = EGraphicsTextureType.GRADIENT;
    }

    public function setColors(value:Array<GradientItem>):Void {
        colors = value;
        gradientColors = [];
        gradientAlphas = [];
        gradientRatios = [];
        var item:GradientItem;
        var n:Int = value.length;
        for (i in 0...n) {
            item = value[i];
            gradientColors.push(item.color);
            gradientAlphas.push(item.alpha);
            gradientRatios.push(item.ratio);
        }
    }

    override function draw(graphics:Graphics):Void {
        if (colors == null) {
            return;
        }
        if (matrix == null) {
            matrix = new Matrix();
        }
//convert rotation to radians
        var r:Float = rotation * (Math.PI / 180);
        matrix.createGradientBox(_width, _height, r);
        graphics.beginGradientFill(type, gradientColors, gradientAlphas, gradientRatios, matrix, spreadMethod, interpolationMethod, focalPtRatio);
    }
}