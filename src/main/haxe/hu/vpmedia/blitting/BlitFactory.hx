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
package hu.vpmedia.blitting;

import flash.geom.Rectangle;
import flash.display.BitmapData;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BlitFactory {
    private static var point:Point = new Point(0, 0);

    private static inline var smoothing:Bool = true;

    private static inline var noRGBA:Int = 0x00000000;

    public function new() {
    }

    public static function parse(xml:Xml, atlas:BlitAtlas):Void {
        for (item in xml.firstElement().elements()) {
            var subTexture = new haxe.xml.Fast(item);
            var name:String = subTexture.att.name;
            var x:Float = Std.parseFloat(subTexture.att.x);
            var y:Float = Std.parseFloat(subTexture.att.y);
            var width:Float = Std.parseFloat(subTexture.att.width);
            var height:Float = Std.parseFloat(subTexture.att.height);
            var frameX:Float = 0;
            var frameY:Float = 0;
            var frameWidth:Float = 0;
            var frameHeight:Float = 0;
            if (subTexture.has.frameX)
                frameX = Std.parseFloat(subTexture.att.frameX);
            if (subTexture.has.frameY)
                frameY = Std.parseFloat(subTexture.att.frameY);
            if (subTexture.has.frameWidth)
                frameWidth = Std.parseFloat(subTexture.att.frameWidth);
            if (subTexture.has.frameHeight)
                frameHeight = Std.parseFloat(subTexture.att.frameHeight);
            var region:Rectangle = new Rectangle(x, y, width, height);
            var frame:Rectangle = frameWidth > 0 && frameHeight > 0 ? new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
            atlas.addArea(name, region, frame);
        }
    }

    public static function createRotationListFromBitmapData(source:BitmapData, inc:Int, offset:Int = 0):Array<Dynamic> {
        var tileList:Array<Dynamic >= [];
        var rotation:Int = offset;
        while (rotation < (360 + offset)) {
            var angleInRadians:Float = Math.PI * 2 * (rotation / 360);
            var rotationMatrix:Matrix = new Matrix();
            rotationMatrix.translate(-source.width * .5, -source.height * .5);
            rotationMatrix.rotate(angleInRadians);
            rotationMatrix.translate(source.width * .5, source.height * .5);
            var bitmapData:BitmapData = new BitmapData(source.width, source.height, smoothing, noRGBA);
            bitmapData.draw(source, rotationMatrix);
            tileList.push(bitmapData.clone());
            rotation += inc;
            bitmapData.dispose();
            bitmapData = null;
            rotationMatrix = null;
        }
        return(tileList);
    }

    public static function createFadeOutListFromBitmapData(source:BitmapData, steps:Int):Array<Dynamic> {
        var tileList:Array<Dynamic >= [];
        var stepAmount:Float = 1 / steps;
        var i:Int;
        for (i in 0...steps) {
            var alpha:Float = 1 - (i * stepAmount);
            var alphaMatrix:ColorMatrixFilter = new ColorMatrixFilter([ 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, alpha, 0 ]);
            var bitmapData:BitmapData = new BitmapData(source.width, source.height, smoothing, noRGBA);
            bitmapData.applyFilter(source, bitmapData.rect, point, alphaMatrix);
            tileList.push(bitmapData.clone());
            bitmapData.dispose();
            bitmapData = null;
            alphaMatrix = null;
        }
        return(tileList);
    }
}