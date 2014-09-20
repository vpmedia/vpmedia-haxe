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
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
 * TBD
 * @author Andras Csizmadia
 */
class BitmapClipTest extends MatchersBase
{    
    public function new() 
    {
        super();
    }
    
    @Before
    public function setup():Void
    {
        // This will run before every test
    }
    
    @After
    public function tearDown():Void
    {
        // This will run after every test
    }
        
    @Test
    public function test_can_create():Void
    {
        var bitmapData:BitmapData = new BitmapData(50, 50);
        var blitAtlas:BlitAtlas = new BlitAtlas(bitmapData);
        var bitmapClip:BitmapClip = new BitmapClip(blitAtlas, 50, 50); 
        
        assertThat(bitmapClip, not(nullValue()));
        assertThat(bitmapClip.width, is(50));
        assertThat(bitmapClip.height, is(50));
    }
    
    @Test
    public function test_same_created():Void
    {
        var bitmapData:BitmapData = new BitmapData(50, 50);
        var blitAtlas:BlitAtlas = new BlitAtlas(bitmapData);
        var bitmapClip:BitmapClip = new BitmapClip(blitAtlas, 50, 50); 
                
        var screenshot:BitmapData = new BitmapData(50, 50);
        screenshot.draw(bitmapClip);        
        assertThat(bitmapData.compare(screenshot), is(0));
    }
}