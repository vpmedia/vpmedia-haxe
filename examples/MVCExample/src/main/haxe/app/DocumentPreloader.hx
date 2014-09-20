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

package app;

import flash.display.Sprite;  
import flash.events.Event;

/**
 * ...
 * @author Andras Csizmadia
 */
class DocumentPreloader extends NMEPreloader
{
    //----------------------------------
    //  Constructor
    //----------------------------------
    
    public function new()
    {
      super();
    }
    
    //----------------------------------
    //  Event handlers
    //----------------------------------

    override public function onInit() 
    {
        
    }
    
    override public function onUpdate(inBytes:Int,inTotal:Int)
    {
        var percent = inBytes/inTotal;

        var w = getWidth();
        var h = getHeight(); 

        graphics.clear();

        graphics.beginFill(0x000000);
        graphics.drawRect(0, h/2-6, percent*w, 6);
        graphics.endFill();
    }

    override public function onLoaded()
    {
        dispatchEvent (new Event (Event.COMPLETE));
    }
}



