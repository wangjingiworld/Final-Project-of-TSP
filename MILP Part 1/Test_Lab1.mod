/*********************************************
 * OPL 12.9.0.0 Model
 * Author: Wang Jing
 * Creation Date: Dec 18, 2019
 * Updated Date	: Dec 19, 2019
 *********************************************/
int N=...;
range holes=0..N-1;


// generate random data
tuple randseed {
	int x;
	int y;
}
tuple edge{
	int i;
	int j;
}

setof(edge)	edges = {<i,j> | i,j in holes}; // (i,j) belongs to Arcs, i,j belongs to N
float c[edges] ;
randseed holeseed[holes];

execute {
	function getTime(hole1, hole2) {
		return Opl.sqrt(Opl.pow(hole1.x-hole2.x,2)+Opl.pow(hole1.y-hole2.y,2));	
	}

	for (var i in holes) {
		holeseed[i].x=Opl.rand(10);
		holeseed[i].y=Opl.rand(20);
	}
	for (var e in edges) {
		c[e]=getTime(holeseed[e.i],holeseed[e.j])

}
}

// create the model
//decision variables
dvar boolean b[edges];
dvar float+ f[edges];

// expressions
dexpr float TotalTime = sum(e in edges) c[e]*b[e];

minimize TotalTime;

//constraints
subject to {

	// constraint 10
	forall (k in holes: k!=0)
		sum (<i,k> in edges) f[<i,k>] - sum (<k,j> in edges:j!=0) f[<k,j>] == 1; 
		
	// constraint 11	
	forall (i in holes)
		sum (<i,j> in edges) b[<i,j>] ==1; 
	
	// constraint 12	
	forall (j in holes)
	  	sum (<i,j> in edges) b[<i,j>]==1; 
	  	
	// constraint 13
	forall (<i,j> in edges : j!=0)
	  	f[<i,j>] <= (N-1) * b[<i,j>]; 	

    forall(<i,0> in edges) f[<i,0>] == 0;
}

main {
	var mod = thisOplModel.modelDefinition;
	var dat = thisOplModel.dataElements;
	for (var size=5; size <= 50; size+=1) {
		var MyCplex = new IloCplex();
		var opl = new IloOplModel(mod, MyCplex);
		dat.N=size;
		opl.addDataSource(dat);
		// generate model; 
		opl.generate();		//everytime change the data of model, it needed to have to generate,
							//everytime assign new data source, have to include this statement
							
		
		if (MyCplex.solve()) {
			writeln ("solution:", MyCplex.getObjValue(),
			"/ size:",size,
			"/ time:", MyCplex.getSolvedTime());		
		}
		opl.end();
		MyCplex.end();
		}		
}
