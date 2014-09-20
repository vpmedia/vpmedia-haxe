/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.entity;

import flash.display.Sprite;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
* TBD
*/
class BaseEntityTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
    }
    
    private var entity:BaseEntity;
    
    @Before
    public function setup():Void
    {
        entity = new BaseEntity();
    }
    
    @After
    public function tearDown():Void
    {
        entity = null;
    }
     
    @Test
    public function test_hasComponent():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        var component2:MockComponentB = new MockComponentB();
        
        entity.addComponent(component1);
        entity.addComponent(component2);
        
        assertThat(entity.hasComponent(MockComponentA), is(true));
        assertThat(entity.hasComponent(MockComponentB), is(true));
        assertThat(entity.hasComponent(MockComponentC), is(false));
    }

    @Test
    public function test_getComponent():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        component1.n = 5;
        var component2:MockComponentB = new MockComponentB();
        component2.m = "10";
        var component3:MockComponentC = new MockComponentC();
        
        entity.addComponent(component1);
        entity.addComponent(component2);
        entity.addComponent(component3);
        
        assertThat(entity.getComponent(MockComponentA), sameInstance(component1));
        assertThat(entity.getComponent(MockComponentB), sameInstance(component2));
        assertThat(entity.getComponent(MockComponentC), sameInstance(component3));
        
        assertThat(entity.getComponent(MockComponentA).n, is(5));
        assertThat(entity.getComponent(MockComponentB).m, is("10"));
    }

    @Test
    public function test_removeComponent():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        var component2:MockComponentB = new MockComponentB();
        
        entity.addComponent(component1);
        entity.addComponent(component2);
        entity.removeComponent(MockComponentA);
        entity.removeComponent(MockComponentB);
        
        assertThat(entity.hasComponent(MockComponentA), is(false));
        assertThat(entity.hasComponent(MockComponentB), is(false));
    }
        
    @Test
    public function test_removeAllComponent():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        var component2:MockComponentB = new MockComponentB();
        
        entity.addComponent(component1);
        entity.addComponent(component2);
        entity.removeAllComponent();
        entity.removeComponent(MockComponentB);
        
        assertThat(entity.hasComponent(MockComponentA), is(false));
        assertThat(entity.hasComponent(MockComponentB), is(false));
    }
        
    @Test
    public function test_replaceComponent():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        var component2:MockComponentA = new MockComponentA();
        
        entity.addComponent(component1);
        entity.addComponent(component2);
        
        assertThat(entity.getComponent(MockComponentA), not(sameInstance(component1)));
        assertThat(entity.getComponent(MockComponentA), sameInstance(component2));
    }
    
    @Test
    public function test_clone():Void
    {
        var entity:BaseEntity = new BaseEntity();
        var component1:MockComponentA = new MockComponentA();
        component1.n = 5;
        
        entity.addComponent(component1);
        
        var clone:BaseEntity = entity.clone();
                
        assertThat(clone, not(sameInstance(entity)));
        assertThat(clone.hasComponent(MockComponentA), is(true));
        assertThat(clone.hasComponent(MockComponentB), is(false));
        assertThat(entity.getComponent(MockComponentA).n, is(5));
        assertThat(clone.getComponent(MockComponentA).n, is(5));
    }
    
    private function testSignalContent(signalEntity:BaseEntity, componentClass:Class<Dynamic>):Void
    {
        assertThat(signalEntity, sameInstance(entity));
        assertThat(componentClass, sameInstance(MockComponentA));
    }
}