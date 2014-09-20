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
package hu.vpmedia.assets;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

import hu.vpmedia.assets.AssetLoader;

/**
 * TBD
 */
class AssetLoaderTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
        
    @Test
    public function testAddItem():Void
    {
        var loader:AssetLoader = new AssetLoader();
        loader.name = "testAddItemLoader";
        loader.add("test.txt");
        Assert.isTrue(loader.numTotal == 1);
    }
    
    @Test
    public function testUnexistingItem():Void
    {
        var loader:AssetLoader = new AssetLoader();
        loader.name = "testUnexistingItemLoader";
        loader.add("unknown1");
        loader.execute();
    }
    
    @Test
    public function testLoadItemPriorityQueue():Void
    {
        var loader:AssetLoader = new AssetLoader();        
        loader.name = "testLoadItemPriorityQueueLoader";
        loader.add("test.xml", 10);
        loader.add("test.jpg", 5);
        loader.add("test.json", 3);
        loader.add("test.png", 20);
        loader.add("test.txt", 0);
        loader.add("test.swf", 30);
        loader.add("test.mp3", 40);    
        loader.add("test.zip", 50);
        loader.add("test.css", 4);
        loader.execute();            
    }
    
    @Test
    public function testInvalidContent():Void
    {
        var loader:AssetLoader = new AssetLoader();    
        loader.name = "testInvalidContentLoader";
        loader.add("test-bad.xml");    
        loader.add("test-bad.json");
        loader.add("test-bad.png");
        loader.add("test-bad.swf");
        //loader.add("test-bad.zip");// goes to timeout
        loader.execute();            
    }
}