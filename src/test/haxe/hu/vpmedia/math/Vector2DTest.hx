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
package hu.vpmedia.math;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
* TBD
*/
class Vector2DTest extends MatchersBase
{
    private var subject:Vector2D;
    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
    
    @Before
    public function setup():Void
    {
        subject = new Vector2D(0,0);
    }
    
    @After
    public function tearDown():Void
    {
        subject = null;
    }
        
    @Test
    public function test_isZero():Void
    {
        Assert.isTrue(subject.isZero());
    }
    
    @Test
    public function test_add_sub_mul_div():Void
    {
        subject.add(new Vector2D(1, 2));
        subject.subtract(new Vector2D(3, 4));
        subject.multiply(new Vector2D(2, -3));
        subject.divide(new Vector2D(2, 3));
        
        //flash.Lib.trace(subject);
        Assert.isTrue(Std.int(subject.x) == -2 && Std.int(subject.y) == 2);
    }
    
    @Test
    public function test_scale():Void
    {
        Assert.isTrue(subject.setXY(1,2).multiplyScalar(3).equalsXY(3, 6));
    }
    
    @Test
    public function test_normalize():Void
    {
        Assert.isTrue(subject.setXY(10, 0).normalize().equalsXY(1, 0));
        Assert.isTrue(subject.setXY(0, 10).normalize().equalsXY(0, 1));
    }
    
    @Test
    public function test_isNormalized():Void
    {        
        Assert.isTrue(subject.setXY(1, 1).normalize().isWithinXY(0.7, 0.7, 0.1));
        Assert.isTrue(subject.isNormalized());
    }
    
    @Test
    public function test_rotate():Void
    {
        // rotate
        Assert.isTrue(subject.setXY(1, 0).normalLeft().equalsXY(0, -1));
        Assert.isTrue(subject.setXY(1, 0).normalRight().equalsXY(0, 1));
        Assert.isTrue(subject.setXY(1, 0).normalLeft().equalsXY(0, -1));
        Assert.isTrue(subject.setXY(1, 0).normalRight().equalsXY(0, 1));
        Assert.isTrue(subject.setXY(-13, 3).negate().equalsXY(13, -3));
        Assert.isTrue(subject.setXY( -13, 3).negate().equalsXY(13, -3));
        Assert.isTrue(subject.setXY(1, 0).rotate(Math.PI * 0.5).isNearXY(0, 1));
        Assert.isTrue(subject.setXY(1, 0).rotate(Math.PI * 0.5).isNearXY(0, 1));
        Assert.isTrue(subject.getAngle() == Math.PI * 0.5);
        Assert.isTrue(subject.getRotation() == 90);
    }
    
    @Test
    public function test_swap():Void
    {
        /*var v2:Vector2D = new Vector2D(3, 4);
        Vector2D.swap(subject.setXY(12, 13), v2);
        Assert.isTrue(subject.equalsXY(3, 4));
        Assert.isTrue(v2.equalsXY(12, 13)); */
    }
    
    @Test
    public function test_distance():Void
    {
        /*Assert.isTrue(Near.isNear(subject.setXY(3, 4).length(), 5));
        Assert.isTrue(subject.lengthSqr() == 25);
        Assert.isTrue(subject.distance(new Vector2D(3, 4)) == 0);
        Assert.isTrue(subject.distance(new Vector2D(3, 0)) == 4);
        Assert.isTrue(subject.distanceXY(3, 0) == 4);*/
    }
    
    @Test
    public function test_dot():Void
    {
       /* Assert.isTrue(subject.setXY(1, 0).dotXY(1, 0) == 1);
        Assert.isTrue(subject.setXY(1, 0).dotXY( -1, 0) == -1);
        Assert.isTrue(subject.setXY(1, 0).dotXY(0, 1) == 0);
        Assert.isTrue(subject.setXY(1, 1).normalize().dot(subject.normalLeft()) == 0);*/
    }
    
    @Test
    public function test_cross():Void
    {
        /*Assert.isTrue(subject.setXY(1, 0).crossDetXY(1, 0) == 0)
        Assert.isTrue(subject.setXY(1, 0).crossDetXY(0, -1) == -1)
        Assert.isTrue(subject.setXY(1, 0).crossDetXY(0, 1) == 1)
        Assert.isTrue(subject.setXY(1, 0).crossDet(new Vector2D(1, 0)) == 0)
        Assert.isTrue(subject.setXY(1, 0).crossDet(new Vector2D(0, -1)) == -1)
        Assert.isTrue(subject.setXY(1, 0).crossDet(new Vector2D(0, 1)) == 1)*/
    }
    
    @Test
    public function test_lerp():Void
    {
        /*Assert.isTrue(subject.setXY(1, 0).lerp(new Vector2D(0, -1), 0.5).isWithinXY(0.5, -0.5, 0.01));
        Assert.isTrue(subject.setXY(1, 0).lerp(new Vector2D(-1, 0), 0.5).isWithinXY(0, 0, 0.01));
        Assert.isTrue(subject.setXY(1, 0).lerp(new Vector2D(0, -1), 0.5).isWithinXY(0.5, -0.5, 0.01));
        Assert.isTrue(subject.setXY(1, 0).lerp(new Vector2D(-1, 0), 0.5).isWithinXY(0, 0, 0.01));    */ 
    }
    
    @Test
    public function test_slerp():Void
    {
        //Assert.isTrue(subject.setXY(1, 0).slerp(new Vector2D(0, -1), 0.5).isWithinXY(0.7, -0.7, 0.1));    
    }
        
}