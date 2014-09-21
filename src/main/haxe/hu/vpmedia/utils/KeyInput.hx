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
package hu.vpmedia.utils;

import flash.events.KeyboardEvent;
import flash.events.TouchEvent;
import flash.Lib;

/**
 * Provides static helper methods and properties for Keyboard handling.
 */
class KeyInput {

    public static inline var JUST_PRESSED:Int = 0;
    public static inline var DOWN:Int = 1;
    public static inline var JUST_RELEASED:Int = 2;
    public static inline var UP:Int = 3;

    public var enabled(get_enabled, set_enabled):Bool;

    private var _keys:Map<Int, Int>;
    private var _keysReleased:Array<Int>;
    private var _isInitialized:Bool;
    private var _enabled:Bool;

    public function new() {
        _keys = new Map();
        _keysReleased = new Array<Int>();
        initialize();
    }

    public function initialize():Void {
        if (_isInitialized)
            return;
        _isInitialized = true;
        set_enabled(true);
    }

    public function dispose():Void {
        set_enabled(false);
    }

    public function step(timeDelta:Float):Void {
        if (!_enabled)
            return;
        for (key in _keys.keys()) {

            if (_keys.get(key) == JUST_PRESSED) {
                _keys.set(key, DOWN);
            }
        }
        _keysReleased = [];
    }

    public function isDown(keyCode:Int):Bool {
        return _keys.get(keyCode) == DOWN;
    }

    public function justPressed(keyCode:Int):Bool {
        return _keys.get(keyCode) == JUST_PRESSED;
    }

    public function justReleased(keyCode:Int):Bool {
        return Lambda.indexOf(_keysReleased, keyCode) != -1;
    }

    private function _onKeyDown(kEvt:KeyboardEvent):Void {
        if (_keys.get(kEvt.keyCode) == null) {
            _keys.set(kEvt.keyCode, JUST_PRESSED);
        }
    }

    private function _onKeyUp(kEvt:KeyboardEvent):Void {
        _keys.remove(kEvt.keyCode);
        _keysReleased.push(kEvt.keyCode);
    }

    public function get_enabled():Bool {
        return _enabled;
    }

    public function set_enabled(value:Bool):Bool {
        if (_enabled == value)
            return _enabled;
        _enabled = value;
        if (_enabled) {
            Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, false, 0, true);
            Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp, false, 0, true);
        } else {
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
            Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
        }
        return _enabled;
    }
}