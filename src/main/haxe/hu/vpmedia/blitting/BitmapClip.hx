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

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BitmapClip extends Sprite {
    private var _bitmap:Bitmap;

    private var _bitmapData:BitmapData;

    private var _blit:BlitGroup;

    private var _fillRect:Rectangle;

    public function new(atlas:BlitAtlas, width:Int, height:Int, prefix:String = "", fps:Int = 30) {
        _bitmapData = new BitmapData(width, height, true, 0x00FFFFFF);
        _bitmap = new Bitmap(_bitmapData);
        addChild(_bitmap);
        _fillRect = new Rectangle(0, 0, width, height);
        var clip:BlitClip = new BlitClip(_bitmapData, atlas, prefix, fps);
        _blit = new BlitGroup(clip);
        _blit.currentSequence.step(0.0001);
        super();
    }

    public function play(value:String):Void {
        _blit.play(value);
    }

    public function step(timeDelta:Float):Void {
        _blit.currentSequence.canvas.fillRect(_fillRect, 0x00FFFFFF);
        _blit.currentSequence.step(timeDelta);
    }
}