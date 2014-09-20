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

import hu.vpmedia.ds.SinglyLinkedList;
import hu.vpmedia.ds.DoublyLinkedList;
import hu.vpmedia.ds.DoublyLinkedSignalList;
import hu.vpmedia.ds.DoublyLinkedPriorityList;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
class BaseEntityWorld {
    public var context:Sprite;

    public var isUpdating:Bool;
    public var isPaused:Bool;

    public var fixedTimeStep:Float;
    public var lastTimeStep:Float;

    public var entityList:DoublyLinkedList<BaseEntity>;
    public var familyList:SinglyLinkedList<BaseEntityFamily<Dynamic>>;
    public var systemList:DoublyLinkedPriorityList<BaseEntitySystem>;

//----------------------------------
//  Constructor
//----------------------------------

    public function new(context:Sprite) {
        this.context = context;
        initialize();
    }

//----------------------------------
//  Lifecycle
//----------------------------------

    public function initialize():Void {
        entityList = new DoublyLinkedList<BaseEntity>();
        familyList = new SinglyLinkedList<BaseEntityFamily<Dynamic>>();
        systemList = new DoublyLinkedPriorityList<BaseEntitySystem>();

        fixedTimeStep = 1 / 30;
        lastTimeStep = 0;

        context.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function dispose():Void {
        isPaused = true;

        context.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        entityList.removeAll();
        familyList.removeAll();
        systemList.removeAll();

        entityList = null;
        familyList = null;
        systemList = null;
    }

//----------------------------------
//  Event handlers
//----------------------------------

    public function onEnterFrame(event:Event):Void {
        if (isPaused != true) {
            var deltaTime:Float = (Lib.getTimer() - lastTimeStep) / 1000;
            lastTimeStep = Lib.getTimer();
            step(fixedTimeStep);
        }
    }

//----------------------------------
//  Entity API
//----------------------------------

    public function addEntity(value:BaseEntity):Void {
        value.componentAdded.add(componentAdded);
        value.componentRemoved.add(componentRemoved);
        entityList.add(value);
        addEntityToFamily(value);
    }

    public function removeEntity(value:BaseEntity):Void {
        value.componentAdded.remove(componentAdded);
        value.componentRemoved.remove(componentRemoved);
        removeEntityFromFamily(value, true);
        entityList.remove(value);
        value.dispose();
    }

    public function hasEntity(value:BaseEntity):Bool {
        var entity:BaseEntity = entityList.head;
        while (entity != null) {
            if (entity == value) {
                return true;
            }
            entity = entity.next;
        }
        return false;
    }

//----------------------------------
//  Entity Helpers
//----------------------------------

    function componentAdded(entity:BaseEntity, componentClass:Class<Dynamic>):Void {
        addEntityToFamily(entity);
    }

    function componentRemoved(entity:BaseEntity, componentClass:Class<Dynamic>):Void {
        removeEntityFromFamily(entity, false);
    }

    function removeEntityFromFamily(value:BaseEntity, forced:Bool):Void {
        var family:BaseEntityFamily<Dynamic> = familyList.head;
        while (family != null) {
            if (family.hasEntity(value)) {
                if (forced == true) {
                    family.removeEntity(value);
                } else {
                    family.removeEntityIfNotMatch(value);
                }
            }
            family = family.next;
        }
    }

    function addEntityToFamily(value:BaseEntity):Void {
        var family:BaseEntityFamily<Dynamic> = familyList.head;
        while (family != null) {
            family.addEntityIfMatch(value);
            family = family.next;
        }
    }

//----------------------------------
//  System API
//----------------------------------

    public function createSystem(systemClass:Class<BaseEntitySystem>, priority:Int, ?params:Array<Dynamic> = null):Bool {
        if (hasSystem(systemClass)) {
            return false;
        }
        var systemParams:Array<Dynamic> = [priority, this];
        if (params != null) {
            systemParams = systemParams.concat(params);
        }
        var system:BaseEntitySystem = Type.createInstance(systemClass, systemParams);
        system.priority = priority;
        systemList.add(system);
        return true;
    }

    public function addSystem(system:BaseEntitySystem):Bool {
        if (hasSystem(Type.getClass(system))) {
            return false;
        }
        systemList.add(system);
        return true;
    }

    public function removeSystem(systemClass:Class<BaseEntitySystem>):Bool {
        if (!hasSystem(systemClass)) {
            return false;
        }
        var system:BaseEntitySystem = getSystem(systemClass);
        systemList.remove(system);
        return true;
    }

    public function hasSystem(systemClass:Class<BaseEntitySystem>):Bool {
        return getSystem(systemClass) != null;
    }

    public function getSystem(systemClass:Class<BaseEntitySystem>):BaseEntitySystem {
        var s = systemList.head;
        while (s != null) {
            if (Std.is(s, systemClass)) {
                return s;
            }
            s = s.next;
        }
        return null;
    }

//----------------------------------
//  Family API
//----------------------------------

    public function getNodeList<T:BaseEntityNode<T>>(nodeClass:Class<T>):DoublyLinkedSignalList<T> {
// check for existing family
        var family:BaseEntityFamily<Dynamic> = familyList.head;
        while (family != null) {
            if (family.nodeClass == nodeClass) {
                return cast family.nodeList;
            }
            family = family.next;
        }

// create new family
        var family:BaseEntityFamily<Dynamic> = new BaseEntityFamily<Dynamic>(nodeClass);
        familyList.add(family);

// add entity to family if matches
        var entity:BaseEntity = entityList.head;
        while (entity != null) {
            family.addEntityIfMatch(entity);
            entity = entity.next;
        }

// return new family node list
        return cast family.nodeList;
    }

//----------------------------------
//  Step
//----------------------------------

    public function step(timeDelta:Float):Void {
// remove flagged disposable entites outside system step
        var entity:BaseEntity = entityList.head;
        while (entity != null) {
            if (entity.isDisposable) {
                removeEntity(entity);
            }
            entity = entity.next;
        }

// flag update start
        isUpdating = true;

// update systems
        var s:BaseEntitySystem = systemList.head;
        while (s != null) {
            s.step(timeDelta);
            s = s.next;
        }

// flag update end
        isUpdating = false;
    }
}