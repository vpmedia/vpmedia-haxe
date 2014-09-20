package hxBehaviors.behavior; 

    using hxBehaviors.Float3DTools;
    import hxBehaviors.Vehicle;
    import hxBehaviors.behavior.Behavior;

    import flash.geom.Vector3D;

    /**
     * @author Eugene Zatepyakin
     */
    class Wander extends Behavior {
        
        static private var SQRT2:Float = Math.sqrt(2);
        
        var wanderJiggle:Vector3D ;
        var wanderGlobal:Vector3D ;
        
        public var wanderStrength:Float ;
        public var wanderRate:Float ;
        public var wanderDirection:Vector3D ;
        
        public function new(?wanderStrength:Float = 0.2, ?wanderRate:Float = 0.8)
        {
            super();
            wanderJiggle = new Vector3D();
            wanderGlobal = new Vector3D();
            wanderDirection = new Vector3D();
            this.wanderStrength = wanderStrength;
            this.wanderRate = wanderRate;
        }
        
        public override function apply(veh:Vehicle):Void
        {
            wanderJiggle.setUnitRandom();
            
            wanderJiggle.x *= wanderRate;
            wanderJiggle.y *= wanderRate;
            wanderJiggle.z *= wanderRate;
            
            //wanderDirection.x += wanderJiggle.x;
            wanderDirection.y += wanderJiggle.y;
            wanderDirection.z += wanderJiggle.z;
            
            wanderDirection.setApproximateNormalize();
            
            veh.globalizeDirection(wanderDirection, wanderGlobal);
            
            wanderGlobal.x *= wanderStrength;
            wanderGlobal.y *= wanderStrength;
            wanderGlobal.z *= wanderStrength;
            
            accumulator.x = veh.forward.x * SQRT2 + wanderGlobal.x;
            accumulator.y = veh.forward.y * SQRT2 + wanderGlobal.y;
            accumulator.z = veh.forward.z * SQRT2 + wanderGlobal.z;
            
            veh.applyGlobalForce(accumulator);
        }
    }
