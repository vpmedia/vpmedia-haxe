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
package hu.vpmedia.components;

import hu.vpmedia.components.BaseSkin;

/**
 * Manager class
 */
class ThemeManager {
    private static var registeredInstances:Map<String, Map<BaseSkin, Bool>>=new Map();
    private static var componentStyleSheets:Map<String, BaseStyleSheet>=new Map();
    public static var themeClass:Class<BaseTheme>;
    private static var theme:BaseTheme;

//--------------------------------------
//  Constructor
//--------------------------------------
/**
     * Constructor
     */

    public function new() {
    }

//--------------------------------------
//  Public
//--------------------------------------

    public static function setTheme(value:Class<BaseTheme>):Void {
        themeClass = value;
        theme = Type.createInstance(themeClass, []);
    }

/**
     *
     */

    public static function register(value:BaseSkin):Void {
        if (theme == null) {
            theme = Type.createInstance(themeClass, []);
        }
        var classDef:Class<BaseSkin> = Type.getClass(value);
        var className:String = Type.getClassName(classDef);

        if (!componentStyleSheets.exists(className)) {
            var defaultStyles:BaseStyleSheet = theme.getStyle(className);
            if (defaultStyles != null) {
                componentStyleSheets.set(className, defaultStyles);
            }
        }
        if (!registeredInstances.exists(className)) {
            registeredInstances.set(className, new Map());
        }
        if (!registeredInstances.get(className).exists(value)) {
            registeredInstances.get(className).set(value, true);
        }
    }

/**
     *
     */

    public static function unregister(value:BaseSkin):Void {
        var classDef:Class<BaseSkin> = Type.getClass(value);
        var className:String = Type.getClassName(classDef);
        registeredInstances.get(className).remove(value);
    }

/**
     *
     */

    public static function setStyle(className:String, name:String, value:Dynamic):Void {
        if (componentStyleSheets.exists(className)) {
            componentStyleSheets.get(className).setStyle(name, value);
            invalidate(className);
        }
    }

/**
     *
     */

    public static function getStyle(className:String, name:String):Dynamic {
        if (className == null || name == null) {
            return null;
        }
        if (componentStyleSheets.exists(className)) {
            return componentStyleSheets.get(className).getStyle(name);
        }
        return null;
    }

/**
     *
     */

    public static function hasStyle(className:String, name:String):Bool {
        if (className == null || name == null) {
            return false;
        }
        if (theme.hasStyle(className)) {
            var styleSheet:BaseStyleSheet = theme.getStyle(className);
            return styleSheet.hasStyle(name);
        }
        return false;
    }

//--------------------------------------
//  Private
//--------------------------------------

/**
     *
     */

    public static function invalidate(className:String):Void {
/* #if debug
        L.info("invalidate:"+className);
        #end*/
        var component:BaseSkin;
        var instances:Map<BaseSkin,Bool>=registeredInstances.get(className);
        for(p in instances.keys())
        {
        component = cast(p, BaseSkin);
/*#if debug
            L.info("drawing:"+component);
            #end */
        component.draw();
        }
    }

/**
     *
     */

    public static function invalidateAll():Void {
        var s:BaseSkin;
        for (p in registeredInstances) {
            for (q in p.keys()) {
                s = cast(q, BaseSkin);
                s.owner.getStyleSheet().reset();
/*#if debug
                L.info("drawing:"+s);
                #end */
                s.owner.draw();
            }
        }
    }
}