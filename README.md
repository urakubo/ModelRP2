# Molecular concentrations required for dopamine dip-detection in D2 striatal spiny-projection neurons

![System requirements](https://img.shields.io/badge/platform-matlab2017b%20or%20newer-green.svg)
[![License: GPL v3](https://img.shields.io/badge/license-MIT-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Abstract
In the brain, phasic dopamine (DA) signals convey reward-related information in behavioral learning. In particular, a phasic decrease in DA (DA-dip) reflects unexpected reward omission, which triggers long-term potentiation (LTP) in DA D2 receptor (D2R) expressing spiny-projection neurons (D2 SPNs). This LTP is required for reward-discrimination, while it is unclear how such a rapid DA-dip signal (~0.5 s) is processed through intracellular signaling, especially up to a signal integrator, adenylate cyclase (AC). In the present study, we built a computational model of the D2 signaling to clarify the requirements for DA-dip detection. To detect the short DA-dip, basal DA signal must sufficiently inhibit AC, while the sudden decrease in DA must rapidly disinhibit AC. We found that the concentration balance of two key molecules, D2R and regulators of G protein signaling (RGS), is necessary to satisfy those two requirements, and an experimental study has shown that this balance is indeed realized. We further obtained analytical forms of the D2 model, demonstrating that the balance requirement appears regardless of model parameters, as far as the D2 model satisfies some constraints, many of which are supported by experimental evidence. The shortage of RGS is known to be a cause of movement disorders, such as DYT1 dystonia and L-DOPA induced dyskinesia, as well as the loss of RGS also increases the sensitivity against opioid drugs. We thus further simulated AC dynamics in the imbalanced states, and demonstrated that the excess amount of an active G-protein prevents DA-dip detection. We finally discuss that the D2 model can provide a unified view of the mechanism on DYT1 dystonia, and gives suggestions to drug abuse.

## System requirements

Matlab plus the toolbox SimBiology. We confirmed the safe executions of sample programs on Matlab 2017b and 2018a on Microsoft Windows10.

## Installation

1. Download source code from the github site:

	- git clone https://github.com/urakubo/ModelRP2.git

2. Execute plot_1C.m, etc., you will see the correpondent figures.

