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
class BaseEntityFamilyTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
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
    public function test_addEntityIfMatch_itemAdded():Void
    {
        var entity:BaseEntity = new BaseEntity();
        
        var component1:MockComponentA = new MockComponentA();
        var component2:MockComponentB = new MockComponentB();        
        
        entity.addComponent(component1);
        entity.addComponent(component2);        
                
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily(MockNode);
        
        assertThat(family.addEntityIfMatch(entity), is(true));
        
        assertThat(family.hasEntity(entity), is(true));
    }
    
    @Test
    public function test_addEntityIfMatch_itemNotAdded():Void
    {
        var entity:BaseEntity = new BaseEntity();
        
        var component1:MockComponentA = new MockComponentA();      
        
        entity.addComponent(component1);    
                
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily(MockNode);
        
        assertThat(family.addEntityIfMatch(entity), is(false));
        
        assertThat(family.hasEntity(entity), is(false));
    }
    
    @Test
    public function test_addEntityIfMatch_itemRemoved():Void
    {
        var entity:BaseEntity = new BaseEntity();
        entity.addComponent(new MockComponentA());
        entity.addComponent(new MockComponentB());  
                
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily(MockNode);
        
        assertThat(family.addEntityIfMatch(entity), is(true));
        
        entity.removeComponent(MockComponentA);           
        family.removeEntityIfNotMatch(entity);
        
        assertThat(family.hasEntity(entity), is(false));
    }
    
    @Test
    public function test_removeEntity():Void
    {
        var entity:BaseEntity = new BaseEntity();
        entity.addComponent(new MockComponentA());
        entity.addComponent(new MockComponentB());       
                
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily(MockNode);
        
        family.addEntityIfMatch(entity);
        family.removeEntity(entity);
        
        assertThat(family.hasEntity(entity), is(false));
    }
    
    @Test
    public function test_dispose():Void
    {
        var entity:BaseEntity = new BaseEntity();
        entity.addComponent(new MockComponentA());
        entity.addComponent(new MockComponentB());        
                
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily(MockNode);
        
        family.addEntityIfMatch(entity);
        family.dispose();
        
        assertThat(family.hasEntity(entity), is(false));
    }
}