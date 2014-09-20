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
class BaseEntityWorldTest extends MatchersBase
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
    public function test_addGetRemoveEntity():Void
    {
        var world:BaseEntityWorld = new BaseEntityWorld(new Sprite());
        var entity:BaseEntity = new BaseEntity();
        entity.addComponent(new MockComponentA());
        entity.addComponent(new MockComponentB());
        entity.addComponent(new MockComponentC());
       
        world.addEntity(entity); 
        
        assertThat(world.hasEntity(entity), is(true));
        
        assertThat(world.entityList.head, sameInstance(entity));
        assertThat(world.entityList.tail, sameInstance(entity));
        
        world.removeEntity(entity);
        
        assertThat(world.entityList.head, nullValue());
        assertThat(world.entityList.tail, nullValue());
    }
}