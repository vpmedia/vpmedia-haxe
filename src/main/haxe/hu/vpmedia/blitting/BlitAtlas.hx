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

import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BlitAtlas {
    private var _bitmapData:BitmapData;

    private var _regions:Map<String, Rectangle>;

    private var _frames:Map<String, Rectangle>;

    public function new(spriteSheet:BitmapData) {
        _regions = new Map();
        _frames = new Map();
        _bitmapData = spriteSheet;
        addArea("", new Rectangle(0, 0, spriteSheet.width, spriteSheet.height), new Rectangle());
    }

    public function addArea(name:String, region:Rectangle, frame:Rectangle = null):Void {
        _regions.set(name, region);
        if (frame != null)
            _frames.set(name, frame);
    }

    public function removeArea(name:String):Void {
        _regions.remove(name);
        if (_frames.get(name) != null)
            _frames.remove(name);
    }

    public function getArea(name:String):BlitArea {
        var region:Rectangle = _regions.get(name);
        if (region == null)
            return null;
        return new BlitArea(region, _frames.get(name));
    }

    public function getAreas(prefix:String = ""):Array<BlitArea> {
        var areas:Array<BlitArea >= [];
        var names:Array<String >= [];
        var name:String;
        for (name in _regions.keys()) {
            if (name.indexOf(prefix) == 0)
                names.push(name);
        }
// TODO: names.sort(Array.CASEINSENSITIVE);
        for (name in names)
            areas.push(getArea(name));
        return areas;
    }

    public function getBitmapData():BitmapData {
        return _bitmapData;
    }

    public function dispose():Void {
        _bitmapData.dispose();
    }
}