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
import flash.geom.Point;
import flash.media.Sound;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BlitClip {
    public var canvas:BitmapData;

    private var _spriteSheet:BitmapData;

    private var _areas:Array<BlitArea>;

    private var _defaultFrameDuration:Float;

    private var _totalTime:Float;

    private var _currentTime:Float;

    private var _currentFrame:Int;

    private var _loop:Bool;

    private var _playing:Bool;

    private var _durations:Array<Float>;

    private var _sounds:Array<Sound>;

    public var x:Float;

    public var y:Float;

    public var position:Point;

    public var name:String;

    public function new(canvas:BitmapData, atlas:BlitAtlas, prefix:String = "", fps:Int = 30) {
        x = 0;
        y = 0;
        position = new Point();
        this.canvas = canvas;
        _spriteSheet = atlas.getBitmapData();
        _defaultFrameDuration = 1.0 / fps;
        _loop = true;
        _playing = true;
        _totalTime = 0.0;
        _currentTime = 0.0;
        _currentFrame = 0;
        _areas = [];
        _durations = [];
        _sounds = [];
        var areas:Array<BlitArea >= atlas.getAreas(prefix);
        for (area in areas)
            addFrame(area);
    }

    public function addFrame(area:BlitArea, sound:Sound = null, duration:Float = -1):Void {
        addFrameAt(numFrames, area, sound, duration);
    }

    public function addFrameAt(index:Int, area:BlitArea, sound:Sound = null, duration:Float = -1):Void {
//trace("addFrameAt: " + index + " | " + area);

        if (duration < 0)
            duration = _defaultFrameDuration;

        _areas.insert(index, area);
        _sounds.insert(index, sound);
        _durations.insert(index, duration);
        _totalTime += duration;
    }

    public function removeFrameAt(index:Int):Void {
        _totalTime -= getFrameDuration(index);
        _areas.splice(index, 1);
        _sounds.splice(index, 1);
        _durations.splice(index, 1);
    }

    public function getFrameBlitArea(index:Int):BlitArea {
        return _areas[index];
    }

    public function setFrameBlitArea(index:Int, area:BlitArea):Void {
        _areas[index] = area;
    }

    public function getFrameSound(index:Int):Sound {
        return _sounds[index];
    }

    public function setFrameSound(index:Int, sound:Sound):Void {
        _sounds[index] = sound;
    }

    public function getFrameDuration(index:Int):Float {
        return _durations[index];
    }

    public function setFrameDuration(index:Int, duration:Float):Void {
        _totalTime -= getFrameDuration(index);
        _totalTime += duration;
        _durations[index] = duration;
    }

    public function play():Void {
        _playing = true;
    }

    public function pause():Void {
        _playing = false;
    }

    public function stop():Void {
        _playing = false;
        currentFrame = 0;
    }

    public function step(passedTime:Float):Void {
        if (_loop && _currentTime == _totalTime)
            _currentTime = 0.0;
        if (!_playing || passedTime == 0.0 || _currentTime == _totalTime)
            return;
        var i:Int = 0;
        var durationSum:Float = 0.0;
        var previousTime:Float = _currentTime;
        var restTime:Float = _totalTime - _currentTime;
        var carryOverTime:Float = passedTime > restTime ? passedTime - restTime : 0.0;
        _currentTime = Math.min(_totalTime, _currentTime + passedTime);
        for (duration in _durations) {
            if (durationSum + duration >= _currentTime) {
//if(_currentFrame !=i || numFrames==1)
//{
                _currentFrame = i;
                updateCurrentFrame();
//playCurrentSound();
//}
                break;
            }
            ++i;
            durationSum += duration;
        }
/* if(previousTime<_totalTime && _currentTime==_totalTime)
           {
           completeSignal.dispatch();
           }  */
        step(carryOverTime);
    }

    private function updateCurrentFrame():Void {
        position.x = x - _areas[_currentFrame].frame.x;
        position.y = y - _areas[_currentFrame].frame.y;
        canvas.copyPixels(_spriteSheet, _areas[_currentFrame].region, position, null, null, true);
    }

    private function playCurrentSound():Void {
        var sound:Sound = _sounds[_currentFrame];
        if (sound != null)
            sound.play();
    }

    public var isComplete(get, never):Bool;

    private function get_isComplete():Bool {
        return false;
    }

    public var totalTime(get, never):Float;

    private function get_totalTime():Float {
        return _totalTime;
    }

    public var numFrames(get, never):Int;

    private function get_numFrames():Int {
        return _areas.length;
    }

    public var loop(get, set):Bool;

    private function get_loop():Bool {
        return _loop;
    }

    private function set_loop(value:Bool):Bool {
        _loop = value;
        return _loop;
    }

    public var currentFrame(get, set):Int;

    private function get_currentFrame():Int {
        return _currentFrame;
    }

    private function set_currentFrame(value:Int):Int {
        _currentFrame = value;
        _currentFrame = 0;
        for (i in 0...value) {
            _currentTime += getFrameDuration(i);
        }
        updateCurrentFrame();
        return _currentFrame;
    }

    public var fps(get, set):Float;

    private function get_fps():Float {
        return 1.0 / _defaultFrameDuration;
    }

    private function set_fps(value:Float):Float {
        var newFrameDuration:Float = (value == 0) ? (1 / 30) : (1 / value);
        var acceleration:Float = newFrameDuration / _defaultFrameDuration;
        _currentTime *= acceleration;
        _defaultFrameDuration = newFrameDuration;
        for (i in 0...numFrames)
            setFrameDuration(i, getFrameDuration(i) * acceleration);
        return newFrameDuration;
    }

    public var isPlaying(get, null):Bool;

    private function get_isPlaying():Bool {
        if (_playing)
            return _loop || _currentTime < _totalTime;
        return false;
    }
}