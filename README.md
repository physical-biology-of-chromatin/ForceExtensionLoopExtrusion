# Polymer Simulation of Force-Dependent Loop-Extrusion
## Overview
This code simulates the force-dependent loop-extrusion process of Structural Maintenance of Chromosomes (SMC) complexes on a polymer chain. It models how loop extruding factors (LEFs) interact with chromatin under external force, accounting for processivity, binding, extrusion rates, and directionality.

The simulation outputs the end-to-end vector of the polymer, which can be used to study conformational changes under varying mechanical and extrusion conditions.
## Input Parameters
Each line of `input.dat` corresponds to one parameter, in the order below:
| Parameter  | Description                                                | 
| ---------- | -----------------------------------------------------------| 
| **Nchain** | Chain size (number of monomers) (in kbp)                   | 
| **L**      | Box size (in `28.2` nm)                                    | 
| **Niter**  | Number of iterations                                       |
| **Nequ**   | Number of Monte Carlo steps (MCSs) for equilibration       |
| **Nmeas**  | Number of measurements                                     |
| **Ninter** | Number of MCSs between successive measurements             | 
| **kint**   | Bending energy (in k_BT)                                   | 
| **dir**    | Extrusion directionality (`1` = one-sided, `2` = two-sided)| 
| **p**      | Zero-force processivity (in kbp)                           |
| **ro**     | Zero-force LEF binding rate (between `0` and `1`)          |
| **km0**    | Zero-force extrusion rate (in `1000` kbp/s)                |
| **Ksmc**   | Spring constant between SMC legs (in `0.0062` pN/nm)       |
| **Fe**     | Characteristic force for extrusion rate (in `0.13` pN)     | 
| **Fu**     | Characteristic force for unbinding rate (in `0.13` pN)     | 
| **Nlef**   | Maximum number of LEFs in the system                       |
| **Perm**   | Permeability of extruders (Between `0` and `1`)            | 
| **Fext**   | External force (in `0.13` pN)                              | 

**Important**: Ensure that L (box size) is an even number.

## Output
`eedz.out` → contains the polymer end-to-end vector at each measurement interval (Ninter).
This file can be used to analyze:

- Chain extension under different forces

- Impact of loop extrusion on polymer compaction

## Software Requirements

To compile and run the simulation, the following software is required:

- **Fortran compiler** (e.g., `gfortran`)
- **C compiler** (e.g., `gcc`)
- **GNU Make** (`make`)  
- **Bash shell** (`bash`)  

## Compilation and Running
1. **Compile the code**  
   Open a terminal in the project directory and run:
   ```bash
   make
2. **Run the simulation**
- Open the `script.sh` file.
- Modify the simulation parameters if needed.
- Save the file.
- Run the program by executing:
  ```bash
  bash script.sh

## Example Usage
```text
   500       :: Nchain 
   20        :: L 
   1         :: Niter 
   1000000   :: Nequ 
   1000      :: Nmeas 
   1000      :: Ninter 
   3.217     :: kint 
   2         :: dir 
   500.0     :: p 
   0.5       :: ro 
   1.0e-3    :: km0 
   5.0       :: Ksmc 
   1.5       :: Fe 
   10.0      :: Fu 
   10        :: Nlef 
   0.0       :: Perm 
   3.0       :: Fext
```

**Note**: This set of parameters runs in less than 5 minutes on a Mac Studio with an Apple M2 Ultra chip.
