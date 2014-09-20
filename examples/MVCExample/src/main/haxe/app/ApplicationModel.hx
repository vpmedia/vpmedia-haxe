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

import hu.vpmedia.framework.BaseTransmitter;
import hu.vpmedia.framework.IBaseTransmitter;

import hu.vpmedia.framework.Router;
import hu.vpmedia.assets.AssetLoader;

class ApplicationModel extends BaseTransmitter
{
    public var router:Router;
    
    public var assets:AssetLoader;
        
    public function new() 
    {        
        super();    
        initialize();
    }
    
    override function initialize():Void
    {
        
    }
    
    public function startup(context:Dynamic):Void
    {
        sendTransmission("modelStartup", null, null, this);
        
        assets = new AssetLoader();
        
        router = new Router(context);
        router.signal.add(onRouterChange);
        var s:RouterItem = new RouterItem();
        s.url="/start/";
        s.view=StartContext;
        router.addState(s);
        
        s = new RouterItem();
        s.url="/main/";
        s.view=MainContext;
        router.addState(s);    
        
        /*s = new RouterItem();
        s.url="/main/test/";
        s.view = StartContext;
        router.addState(s);    */    
    }
    
    public function onRouterChange(code:String, data:Dynamic=null, level:String=null, source:IBaseTransmitter=null):Void 
    {        
        signal.dispatch([code, data, level, source]);
        
        if(code == "routeChangeComplete" && level=="/start/")
        {            
            /*router.setState("/main/test/");
            router.setState("/start/");*/
        }
    }
}