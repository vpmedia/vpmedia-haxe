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