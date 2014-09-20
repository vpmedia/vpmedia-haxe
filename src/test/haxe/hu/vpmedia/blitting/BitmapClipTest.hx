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