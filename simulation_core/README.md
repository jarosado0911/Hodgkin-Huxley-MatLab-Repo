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

