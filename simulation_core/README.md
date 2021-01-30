# NeuronSimTest.m

 - This is for running the simulation
 - <code>geomFolder</code>: this the folder with the <code>.swc</code> refinement geometries
 - the <code>geomFolder</code> would be something like: <code>'D:\path_to_geometry_folder\geometryfolder</code>
 - <code>refinements</code>: enter as an array <code>[0]</code> or can be like <code>[0,1,2,3]</code> for refines 0 through 3
 - <code>0</code> means do not save every time step data
 - <code>1</code> means save every time step == using lots of memory!!
 - <code>outputFolder</code> = name of folder where you want output to go

# NeuronSim.m

 - <code>neuronSim</code>  this runs the Hodgkin Huxley model equations on the neuron defined by the geometry(ies) in <code>geomFiles</code>
 - <code>LHS</code> = this is the left hand side of the stencil matrix from diffusion solve
 - <code>RHS</code> = this is the right hand side of the stencil matrix from diffusion solve
 - <code>dx</code> = this is the average edge length
 - <code>t</code> = the time vector
 - <code>rec_u</code> = this is the last voltage state at the end of the simulation
this code is still in development, the outputs defined above will be, removed, they are outputted for testing purposes

# readSWC.m

 - This functin reads in an swc file and outputs separate attachements of the cell
 - INPUT: SWC <code>filename</code>
 - OUTPUT: <code>A</code> is a matrix with all the information from SWC
 - <code>id</code> is a vector containing all the nodes
 - <code>pid</code> is a vector with the parent id nodes
 - <code>coord</code> is the coordinates [x,y,z] for each node
 - <code>r</code> is the radius at each node
 - <code>subset</code> is the type of node ie soma,dendrite, axon...

# stencilMaker.m

- <code>stencilMaker</code>  this generates the stencil matrix for the diffusion solve of the operator spliting for the Hodgkin Huxley model equations
- <code>n</code> = number of vertices in graph geometry
- <code>dt</code> = time step size which is fixed
- <code>dx</code> = this is the average --> this is NOT used need to remove later!
- <code>R</code> = this is the specific resistance
- <code>a</code> = vector of radii at each vertex
- <code>C</code> = this is the membrane capacitance which is fixed


