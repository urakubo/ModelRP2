# A healthy balance between dopamine D2 receptors and RGS enables regret-signal detection in the striatum

![System requirements](https://img.shields.io/badge/platform-matlab2020a%20or%20newer-green.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Abstract
In the brain, phasic dopamine (DA) signals convey reward-related information in behavioral learning. In particular, a phasic decrease in DA (DA-dip) reflects unexpected reward omission, which triggers long-term potentiation (LTP) in DA D2 receptor (D2R) expressing spiny-projection neurons (D2 SPNs). This LTP is required for reward-discrimination, while it is unclear how such a rapid DA-dip signal (~0.5 s) is processed through intracellular signaling, especially up to a signal integrator, adenylate cyclase (AC). In the present study, we built a computational model of the D2 signaling to clarify the requirements for DA-dip detection. To detect the short DA-dip, basal DA signal must sufficiently inhibit AC, while the sudden decrease in DA must rapidly disinhibit AC. We found that the concentration balance of two key molecules, D2R and regulators of G protein signaling (RGS), is necessary to satisfy those two requirements, and an experimental study has shown that this balance is indeed realized. We further obtained analytical forms of the D2 model, demonstrating that the balance requirement appears regardless of model parameters, as far as the D2 model satisfies some constraints, many of which are supported by experimental evidence. The shortage of RGS is known to be a cause of movement disorders, such as DYT1 dystonia and L-DOPA induced dyskinesia, as well as the loss of RGS also increases the sensitivity against opioid drugs. We thus further simulated AC dynamics in the imbalanced states, and demonstrated that the excess amount of an active G-protein prevents DA-dip detection. We finally discuss that the D2 model can provide a unified view of the mechanism on DYT1 dystonia, and gives suggestions to drug abuse.

## System requirements

Matlab plus the toolbox SimBiology. We confirmed safe executions of sample programs on Matlab 2020a on Microsoft Windows10.

## Installation

1. Download source code from the github site:

	- git clone https://github.com/urakubo/ModelRP2.git

2. Execute main_1D_plot.m, etc., and you will see the following figures.

| Program | Figure |
| ------------- | ------------- |
| main_0D_plot.m | Fig 1C, S1 Fig |
| main_1D_plot_scheme.m | Fig 2A |
| main_1D_plot.m | Fig 2B |
| main_2D_plot.m | Fig 2C, S2 Fig |
| main_2D_plot_theory.m | Fig 3 |
| main_3D_plot.m |S3 Fig |

## License

This project is licensed under the MIT license - see the [LICENSE](LICENSE) file for details.

## Reference
A healthy balance between dopamine D2 receptors and RGS enables regret-signal detection in the striatum

Hidetoshi Urakubo, Sho Yagishita, Haruo Kasai, Yoshiyuki Kubota, and Shin Ishii

In preparation.

2020/9/15

Correspondence: hurakubo@gmail.com
