# Robotic Warehouse | AI Planner: LPG Planner

## Artificial Intelligence for Robotics II - Assignment I 
Basit Akram, _[5161322@studenti.unige.it](mailto:5161322@studenti.unige.it)_
Durga Varun Gangesetti, _[5058219@studenti.unige.it](mailto:5058219@studenti.unige.it)_
Rakesh Motamarri, _[5058220@studenti.unige.it](mailto:5058220@studenti.unige.it)_
Soundarya Pallanti, _[4807289@studenti.unige.it](mailto:4807289@studenti.unige.it)_

MSc Robotics Engineering, University of Genoa, Italy

Instructor: [Prof. Mauro Vallati](https://pure.hud.ac.uk/en/persons/mauro-vallati)

## Overview

The assignment focused on the operational usage of a PDDL-based AI planner **_LPG_** and tested the understanding of planning models. The assignment is about a warehouse which uses two mover robots and a loader robot for carrying and loading the crates from the location of the crates to the conveyour belt. 

## Running the Assignemnt
For numerc and temporal planning we can use LPG planner. After cloning this repository make sure the planner file is executable.To make the file executable run the below command.:
```bashscript
chmod +x lpg
```
For the solution just run the every problem with the following command.
```bashscript
./lpg -o domain.pddl -f problem1.pddl -n 1
```
