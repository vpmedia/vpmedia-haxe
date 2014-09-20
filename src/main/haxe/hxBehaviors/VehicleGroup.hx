package hxBehaviors; 

    import haxe.ds.GenericStack;
    
    import hxBehaviors.behavior.Behavior;

    /**
     * Vehicle Group
     * simple way to control large number of vehicles
     * 
     * @author Eugene Zatepyakin
     */
    class VehicleGroup 
     {
        inline public function iterator():Iterator<Vehicle> {
            return fastList.iterator();
        }

        private var fastList:GenericStack<Vehicle>;
        
        /**
         * @param defaultBehavior is used if Vehicle doesn't have any
         */
        public function new()
        {
            fastList = new GenericStack<Vehicle>();
        }
        
        /**
         * Update all vehicles in group
         */
        public function update():Void
        {    
            for (veh in fastList) 
            {
                for (behave in veh.behaviorList)
                {
                    behave.apply(veh);
                }
                
                veh.update();
            }
        }
        
        /**
         * Add vehicle to group
         * 
         * @param veh    Vehicle object to add
         */
        public function addVehicle(veh:Vehicle):Void
        {
            fastList.add(veh);
        }
        
        inline public function addVehicles(vehs:Iterable<Vehicle>):Void
        {
            for (veh in vehs){
                fastList.add(veh);
            }            
        }
        
        /**
         * Remove vehicle from group
         * 
         * @param veh    Vehicle to remove
         */
        public function removeVehicle(veh:Vehicle):Void
        {
            fastList.remove(veh);
        }
        
        /**
         * Remove all Vehicles
         */
        public function clear():Void
        {
            fastList = new GenericStack<Vehicle>();
        }
    }
