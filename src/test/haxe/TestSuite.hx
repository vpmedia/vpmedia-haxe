import massive.munit.TestSuite;

import ExampleTest;
import hu.vpmedia.assets.AssetLoaderTest;
import hu.vpmedia.blitting.BitmapClipTest;
import hu.vpmedia.commands.CommandMapTest;
import hu.vpmedia.ds.DoublyLinkedListTest;
import hu.vpmedia.ds.DoublyLinkedPriorityListTest;
import hu.vpmedia.ds.DoublyLinkedSignalListTest;
import hu.vpmedia.ds.ObjectPoolTest;
import hu.vpmedia.ds.SinglyLinkedListTest;
import hu.vpmedia.entity.BaseEntityComponentTest;
import hu.vpmedia.entity.BaseEntityFamilyTest;
import hu.vpmedia.entity.BaseEntityNodeTest;
import hu.vpmedia.entity.BaseEntitySystemTest;
import hu.vpmedia.entity.BaseEntityTest;
import hu.vpmedia.entity.BaseEntityWorldTest;
import hu.vpmedia.math.Vector2DTest;
import hu.vpmedia.signals.SignalLiteTest;
import hu.vpmedia.statemachines.fsm.StateMachineTest;
import hu.vpmedia.statemachines.hfsm.StateMachineTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(hu.vpmedia.assets.AssetLoaderTest);
		add(hu.vpmedia.blitting.BitmapClipTest);
		add(hu.vpmedia.commands.CommandMapTest);
		add(hu.vpmedia.ds.DoublyLinkedListTest);
		add(hu.vpmedia.ds.DoublyLinkedPriorityListTest);
		add(hu.vpmedia.ds.DoublyLinkedSignalListTest);
		add(hu.vpmedia.ds.ObjectPoolTest);
		add(hu.vpmedia.ds.SinglyLinkedListTest);
		add(hu.vpmedia.entity.BaseEntityComponentTest);
		add(hu.vpmedia.entity.BaseEntityFamilyTest);
		add(hu.vpmedia.entity.BaseEntityNodeTest);
		add(hu.vpmedia.entity.BaseEntitySystemTest);
		add(hu.vpmedia.entity.BaseEntityTest);
		add(hu.vpmedia.entity.BaseEntityWorldTest);
		add(hu.vpmedia.math.Vector2DTest);
		add(hu.vpmedia.signals.SignalLiteTest);
		add(hu.vpmedia.statemachines.fsm.StateMachineTest);
		add(hu.vpmedia.statemachines.hfsm.StateMachineTest);
	}
}
