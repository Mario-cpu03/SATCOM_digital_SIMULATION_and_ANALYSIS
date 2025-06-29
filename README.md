# SATCOM_digital_SIMULATION_and_ANALYSIS


### Project Overview:
The project aims to simulate, at a low-level perspective, the satellite communication between two static terrestrial nodes representing operative military bases. The simulation is based on an **X-Band MIL-STD-188 SATCOM** system, characterized by asymmetric carrier frequencies and a geostationary passive relay satellite.
Through a set of custom MATLAB scripts, synthetic communication data is generated under varying environmental and physical conditions. These include meteorological factors, thermal noise, additive white Gaussian noise, and signal-to-noise ratio (SNR).
A statistical analysis will be conducted on the simulated results. In particular, a linear regression model will be developed to investigate and formalize the correlation between the system’s overall performance—evaluated in terms of effective throughput, Bit Error Rate (BER), and Packet Error Rate (PER)—and the aforementioned influencing parameters.


### Repository Structure:
- **src/**: Source code, divided in two directories. "src/MatLab/" contains .m source code, whereas "src/RStudio/" contains .R source code.
- **data/**: Project related datasets, i.e. the one with simulated results
- **assets/**: Static resources
- **results/**: RStudio and Matlab generated results that needs persistence logic
- **docs/**: Report with results analysis and interpretation.
 

### How to Interpret the Project:
If you're just interested in the analysis results, then visit "./results/" and "./docs/" where you will find relevant content generated as if you've ran the project.
If you want to test the source code:
1. Clone the repository:
    ```bash
    git clone https://github.com/Mario-cpu03/ATCOM_digital_SIMULATION_and_ANALYSIS.git
    ```
2. Open the project in MATLAB.
3. Run the scripts in the `src/MatLab/` folder to perform the simulation.
4. Open the project in the `src/RStudio/` folder
5. Run the scripts in the same folder to perform the analysis.


### Contacts:
For questions or suggestions, contact me at:
- marioambrosone03@gmail.com
- m.ambrosone12@studenti.unisa.it
- @_mario.ambrosone on Instagram
