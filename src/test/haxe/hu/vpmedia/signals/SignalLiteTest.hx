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
package hu.vpmedia.signals;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
* SignalLiteTest
*/
class SignalLiteTest extends MatchersBase
{
    private var signal:SignalLite;
    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
    
    @Before
    public function setup():Void
    {
        signal = new SignalLite();
    }
    
    @After
    public function tearDown():Void
    {
        signal.removeAll();
        signal = null;
    }
    
    @Test
    public function test_initSizeIsZero():Void
    {
        Assert.isTrue(signal.getSize() == 0);
    }
    
    @Test
    public function test_canAdd():Void
    {
        signal.add(onSignalChange);
        Assert.isTrue(signal.getSize() == 1);
        signal.add(onSignalChangeSecondary);
        Assert.isTrue(signal.getSize() == 2);
    }
    
    @Test
    public function test_canAddOnce():Void
    {
        signal.addOnce(onSignalChange);
        Assert.isTrue(signal.getSize() == 1);
    }
    
    @Test
    public function test_canRemove():Void
    {
        signal.add(onSignalChange);
        signal.add(onSignalChangeSecondary);
        signal.remove(onSignalChange);
        Assert.isTrue(signal.getSize() == 1);
        signal.remove(onSignalChangeSecondary);
        Assert.isTrue(signal.getSize() == 0);
    }
    
    @Test
    public function test_canRemoveAll():Void
    {
        signal.add(onSignalChange);
        signal.add(onSignalChangeSecondary);
        signal.removeAll();
        Assert.isTrue(signal.getSize() == 0);
    }
        
    @Test
    public function test_getSize():Void
    {
        Assert.isTrue(signal.getSize() == 0);
    }
    
    @Test
    public function test_cannotAddHandlerTwice():Void
    {
        signal.add(onSignalChange);
        signal.add(onSignalChange);
        Assert.isTrue(signal.getSize() == 1);
    }
    
    
    @Test
    public function test_dispatch():Void
    {
        signal.add(onSignalChange);
        signal.dispatch();
        Assert.isTrue(signal != null);        
    }
    
    @Test
    public function test_dispatchWithParams():Void
    {
        signal.add(onSignalWithParamsChange);
        signal.dispatch([1, "2", true, [1,2,3]]);
        Assert.isTrue(signal != null);        
    }
    
    /*private function initialize ():Void 
    {         
        // size should be == 2
        flash.Lib.trace("Signal list size: " + signal.getSize());
        
        // can dispatch params
        signalWithParam.dispatch([1, "2", true, [1,2,3]]);
    }*/
    
    private function onSignalChange():Void 
    {
        flash.Lib.trace("onSignalChange");
    }
    
    private function onSignalChangeSecondary():Void 
    {
        flash.Lib.trace("onSignalChangeSecondary");
    }
    
    private function onSignalWithParamsChange(a:Int, b:String, c:Bool, d:Array<Int>):Void 
    {
        flash.Lib.trace("onSignalWithParamsChange: " + a + " | " + b + " | " + c + " | " + d);
    }
        
}