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
class BaseEntitySystemTest extends MatchersBase
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
    public function test_addGetRemoveSystem():Void
    {
        var world:BaseEntityWorld = new BaseEntityWorld(new Sprite());
        var system:BaseEntitySystem = new MockSystem(0, world);
        
        world.addSystem(system);
        
        assertThat(world.getSystem(MockSystem), sameInstance(system));
        
        world.removeSystem(MockSystem);
        
        assertThat(world.getSystem(MockSystem), nullValue());
    }
      
    @Test
    public function test_cannotSingletonSystem():Void
    {
        var world:BaseEntityWorld = new BaseEntityWorld(new Sprite());
        var system:BaseEntitySystem = new MockSystem(0, world);
        
        assertThat(world.addSystem(system), is(true));
        assertThat(world.addSystem(system), is(false));
    }
      
}