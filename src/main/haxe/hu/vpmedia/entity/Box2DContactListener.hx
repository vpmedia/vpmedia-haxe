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

import box2D.collision.B2Manifold;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.contacts.B2Contact;

class Box2DContactListener extends B2ContactListener {

    public function new() {

        super();
    }

    override function beginContact(contact:B2Contact):Void {

        if (contact.m_fixtureA.getBody().getUserData().reportBeginContact)
            contact.m_fixtureA.getBody().getUserData().handleBeginContact(contact);
        if (contact.m_fixtureB.getBody().getUserData().reportBeginContact)
            contact.m_fixtureB.getBody().getUserData().handleBeginContact(contact);
    }

    override function endContact(contact:B2Contact):Void {

        if (contact.m_fixtureA.getBody().getUserData().reportEndContact)
            contact.m_fixtureA.getBody().getUserData().handleEndContact(contact);
        if (contact.m_fixtureB.getBody().getUserData().reportEndContact)
            contact.m_fixtureB.getBody().getUserData().handleEndContact(contact);
    }

    override function preSolve(contact:B2Contact, oldManifold:B2Manifold):Void {
        if (contact.m_fixtureA.getBody().getUserData().reportPreSolve)
            contact.m_fixtureA.getBody().getUserData().handlePreSolve(contact, oldManifold);
        if (contact.m_fixtureB.getBody().getUserData().reportPreSolve)
            contact.m_fixtureB.getBody().getUserData().handlePreSolve(contact, oldManifold);
    }

    override function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void {
        if (contact.m_fixtureA.getBody().getUserData().reportPostSolve)
            contact.m_fixtureA.getBody().getUserData().handlePostSolve(contact, impulse);
        if (contact.m_fixtureB.getBody().getUserData().reportPostSolve)
            contact.m_fixtureB.getBody().getUserData().handlePostSolve(contact, impulse);
    }
}