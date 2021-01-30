# Hodgkin-Huxley-MatLab-Repo
In this repo we endeavor to simulate Hodgkin-Huxley electrical dynamics on neurons.

## Software Requirements
* Most recent version of MatLab, [MatLab](https://www.mathworks.com/products/matlab.html)
* Recommended (for Windows Users): gitforwindows, [gitwindows](https://gitforwindows.org/)
* MacOS users using the bash is fine 

## Example Usage
The following steps have been tested on Windows 10 (will update when tested on Mac and Linux)
To run the code:
1. First open a  bash/terminal (whatever!) on your desktop (or wherever!) and
execute the following <code>git clone https://github.com/jarosado0911/Hodgkin-Huxley-MatLab-Repo.git</code> or you can download the ZIP of the repo. 
Below is a picture of what this may look like 

![gitclone](images/gitclone.PNG)

2. Next, open MatLab and navigate into the <code>Hodgkin-Huxley-MatLab-Repo</code>. It should look like this:

![matlab](images/matlab.PNG)

3. Next, execute in the MatLab command window <code>addpath('simulation_core');</code> this will tell MatLab to look inside the <code>addpath('simulation_core');</code> folder for the functions we wish to call! Nothing will happen when you do this!
4. Now, let us try to run a simulation. Execute 
<code>neuronSimTest('sample_geometry',[0],'C:/Users/jaros/Desktop/sampleTest',1);</code>
This will tell MatLab to look inside the <code>sample_geometry</code> folder for the <code>.swc</code> geometry file, it will run the simulation on 0 refinement, the output will be saved to the desktop in <code>sampleTest</code>, and <code>mysave</code> will save the voltage state of the entire cell at every time step.
