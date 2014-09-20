////////////////////////////////////////////////////////////////////////////////
//=BEGIN MIT LICENSE
//
// The MIT License
// 
// Copyright (c) 2012-2013 Andras Csizmadia
// http://www.vpmedia.eu
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//=END MIT LICENSE
////////////////////////////////////////////////////////////////////////////////
package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ExampleTest 
{
    private var timer:Timer;
    
    public function new() 
    {
        
    }
    
    @BeforeClass
    public function beforeClass():Void
    {
    }
    
    @AfterClass
    public function afterClass():Void
    {
    }
    
    @Before
    public function setup():Void
    {
    }
    
    @After
    public function tearDown():Void
    {
    }
    
    
    @Test
    public function testExample():Void
    {
        Assert.isTrue(true);
    }
    
    @AsyncTest
    public function testAsyncExample(factory:AsyncFactory):Void
    {
        var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
        timer = Timer.delay(handler, 200);
    }
    
    private function onTestAsyncExampleComplete():Void
    {
        Assert.isFalse(false);
    }
    
    
    /**
    * test that only runs when compiled with the -D testDebug flag
    */
    @TestDebug
    public function testExampleThatOnlyRunsWithDebugFlag():Void
    {
        Assert.isTrue(true);
    }

}