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
package hu.vpmedia.ds;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import org.hamcrest.MatchersBase;

/**
* TBD
*/
class DoublyLinkedPriorityListTest extends MatchersBase
{    
    public function new() 
    {
        super();
        // https://github.com/massiveinteractive/MassiveUnit/wiki/Working-with-test-classes
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
    public function test_add():Void
    {
        var list:DoublyLinkedPriorityList<DoublyLinkedPriorityListNode> = new DoublyLinkedPriorityList<DoublyLinkedPriorityListNode>();
        
        var node1:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        node1.data = 1;
        list.add(node1);
        
        var node2:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        node2.data = 2;
        list.add(node2);
        
        assertThat(list.head, sameInstance(node1));
        assertThat(list.tail, sameInstance(node2));
        assertThat(list.head.data, is(1));
        assertThat(list.tail.data, is(2));
    }
      
    @Test
    public function test_remove():Void
    {
        var list:DoublyLinkedPriorityList<DoublyLinkedPriorityListNode> = new DoublyLinkedPriorityList<DoublyLinkedPriorityListNode>();
        var node:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        list.add(node);
        list.remove(node);
        assertThat(list.head, nullValue());
        assertThat(list.tail, nullValue());
    }
      
    @Test
    public function test_removeAll():Void
    {
        var list:DoublyLinkedPriorityList<DoublyLinkedPriorityListNode> = new DoublyLinkedPriorityList<DoublyLinkedPriorityListNode>();
        var node:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        list.add(node);
        list.removeAll();
        assertThat(list.head, nullValue());
        assertThat(list.tail, nullValue());
    }
      
    @Test
    public function test_prioritize():Void
    {
        var list:DoublyLinkedPriorityList<DoublyLinkedPriorityListNode> = new DoublyLinkedPriorityList<DoublyLinkedPriorityListNode>();
        
        var node1:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        node1.priority = 1;        
        list.add(node1);
        
        var node3:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        node3.priority = 3;        
        list.add(node3);
        
        var node2:DoublyLinkedPriorityListNode = new DoublyLinkedPriorityListNode();
        node2.priority = 2;        
        list.add(node2);
        
        
        assertThat(list.head, sameInstance(node1));
        assertThat(list.tail, sameInstance(node3));
    }
}

@:rtti
class DoublyLinkedPriorityListNode implements IDoublyLinkedListNode<DoublyLinkedPriorityListNode> implements IPriorityListNode
{    
    public var next:DoublyLinkedPriorityListNode;
    public var prev:DoublyLinkedPriorityListNode;    
    public var priority:Int;    
    public var data:Dynamic;
    
    //----------------------------------
    //  Constructor
    //----------------------------------
    
    public function new() 
    {           
    }
}