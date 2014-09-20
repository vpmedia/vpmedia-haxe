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
package hu.vpmedia.entity.commons;

/**
 * Box2D uses bits to represent collision categories.
 */
class CollisionCategories {
    private static var _allCategories:Int = 0;
    private static var _numCategories:Int = 0;
    private static var _categoryIndexes:Array<Int>=[1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384];
    private static var _categoryNames:Map<String, Int>=new Map();
    public static inline var CATEGORY_FRIEND:String = "friend";
    public static inline var CATEGORY_FOE:String = "foe";
    public static inline var CATEGORY_LEVEL:String = "level";
    public static inline var CATEGORY_GEM:String = "gem";

    public static function setDefaults():Void {
        add(CATEGORY_FRIEND);
        add(CATEGORY_FOE);
        add(CATEGORY_LEVEL);
        add(CATEGORY_GEM);
    }

/**
     * Returns true if the categories in the first parameter contain the category(s) in the second parameter.
     * @param    categories The categories to check against.
     * @param    theCategory The category you want to know exists in the categories of the first parameter.
     */

    public static function has(categories:Int, theCategory:Int):Bool {
        return cast(categories & theCategory, Bool);
    }

/**
     * Add a category to the collision categories list.
     * @param    categoryName The name of the category.
     */

    public static function add(categoryName:String):Void {
        if (_numCategories == 15) {
            trace("You can only have 15 categories.");
            return;
        }
        if (_categoryNames.get(categoryName) != null)
            return;
        _categoryNames.set(categoryName, _categoryIndexes[_numCategories]);
        _allCategories |= _categoryIndexes[_numCategories];
        _numCategories++;
    }

/**
     * Gets the category(s) integer by name. You can pass in multiple category names, and it will return the appropriate integer.
     * @param    ...args The categories that you want the integer for.
     * @return A signle integer representing the category(s) you passed in.
     */

    public static function get(args:Array<String>):Int {
        var categories:Int = 0;
        for (name in args) {
            var category:Int = _categoryNames.get(name);
            if (category == 0) {
                trace("Warning: " + name + " category does not exist.");
                continue;
            }
            categories |= _categoryNames.get(name);
        }
        return categories;
    }

/**
     * Returns an integer representing all categories.
     */

    public static function getAll():Int {
        return _allCategories;
    }

/**
     * Returns an integer representing all categories except the ones whose names you pass in.
     * @param    ...args The names of the categories you want excluded from the result.
     */

    public static function getAllExcept(args:Array<String>):Int {
        var categories:Int = _allCategories;
        for (name in args) {
            var category:Int = _categoryNames.get(name);
            if (category == 0) {
                trace("Warning: " + name + " category does not exist.");
                continue;
            }
            categories &= Std.int(~_categoryNames.get(name));
        }
        return categories;
    }

/**
     * Returns the number zero, which means no categories. You can also just use the number zero instead of this function (but this reads better).
     */

    public static function getNone():Int {
        return 0;
    }
}