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
package hu.vpmedia.entity;

import hu.vpmedia.signals.SignalLite;
import hu.vpmedia.ds.IDoublyLinkedListNode;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseEntity implements IDoublyLinkedListNode<BaseEntity> {
    public var next:BaseEntity;
    public var prev:BaseEntity;

    public var componentAdded:Signal;
    public var componentRemoved:Signal;

    public var isDisposable:Bool;

//TODO: Fix compiler error: Type parameters of multi type abstracts must be known (for _Map.IMap<Class<Dynamic>, Unknown<0>>)
    private var components:Map<String, BaseEntityComponent>;

//----------------------------------
//  Constructor
//----------------------------------

    public function new() {
        initialize();
    }

//----------------------------------
//  API
//----------------------------------

    public function addComponent(component:Dynamic, componentClass:Class<Dynamic> = null):Void {
        if (componentClass == null) {
            componentClass = Type.getClass(component);
        }
        var componentName:String = Type.getClassName(componentClass);
        components.set(componentName, component);

        componentAdded.dispatch([this, componentClass]);
    }

    public function removeComponent(componentClass:Class<Dynamic>):Void {
        var componentName:String = Type.getClassName(componentClass);
        if (components.exists(componentName)) {
            components.get(componentName).dispose();
            components.remove(componentName);
            componentRemoved.dispatch([this, componentClass]);
        }
    }

    public function getComponent(componentClass:Class<Dynamic>):Dynamic {
        var componentName:String = Type.getClassName(componentClass);
        return components.get(componentName);
    }

    public function getAllComponent():Iterator<Dynamic> {
        return components.iterator();
    }

    public function hasComponent(componentClass:Class<Dynamic>):Bool {
        var componentName:String = Type.getClassName(componentClass);
        return components.exists(componentName);
    }

    public function removeAllComponent():Void {
        for (component in components.iterator()) {
            removeComponent(Type.getClass(component));
        }
        components = new Map();
    }

    private function initialize():Void {
        componentAdded = new Signal();
        componentRemoved = new Signal();

        components = new Map();
    }

    public function dispose():Void {
        removeAllComponent();
    }

    public function clone():BaseEntity {
        var newInstance:BaseEntity = new BaseEntity();
        for (component in components.iterator()) {
            var componentClass:Class<Dynamic> = Type.getClass(component);
            var newComponent:Dynamic = Type.createInstance(componentClass, []);
            for (p in Type.getInstanceFields(componentClass)) {
                var value = Reflect.field(component, p);
                if (p != "initialize" && p != "dispose") {
                    if (Reflect.hasField(newComponent, p)) {
                        Reflect.setField(newComponent, p, value);
                    }
                    try {
                        Reflect.callMethod(newComponent, Reflect.field(newComponent, "set_" + p), [value]);
                    } catch (e:Dynamic) {}
                }

            }
            newInstance.addComponent(newComponent, componentClass);
        }
        return newInstance;
    }


}