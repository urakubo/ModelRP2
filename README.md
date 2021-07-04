# The critical balance between dopamine D2 receptor and RGS for the sensitive detection of a transient decay in dopamine signal

![System requirements](https://img.shields.io/badge/platform-matlab2020a%20or%20newer-green.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Abstract
In behavioral learning, reward-related events are encoded into phasic dopamine (DA) signals in the brain. In particular, unexpected reward omission leads to a phasic decrease in DA (DA dip) in the striatum, which triggers long-term potentiation (LTP) in DA D2 receptor (D2R)-expressing spiny-projection neurons (D2 SPNs). While this LTP is required for reward discrimination, it is unclear how such a short DA-dip signal (0.5–2 s) is transferred through intracellular signaling to the coincidence detector, adenylate cyclase (AC). In the present study, we built a computational model of the D2 signaling to determine conditions for the DA-dip detection. The DA dip can be detected only if the basal DA signal sufficiently inhibits AC, and if the DA-dip signal sufficiently disinhibits AC. We found that those two requirements were simultaneously satisfied only if two key molecules, D2R and regulators of G protein signaling (RGS) were balanced within a certain range; this balance has indeed been observed in an experimental study. We also found that the high level RGS is required for the detection of a 0.5-s short DA dip, and the analytical solutions for these requirements confirmed their universality. The imbalance between D2R and RGS is known to appear in schizophrenia and DYT1 dystonia, both of which are accompanied by abnormal striatal LTP. Our simulation showed that D2 SPNs in both the patients with schizophrenia and DYT1 dystonia cannot detect short DA dips. We finally discussed that such psychiatric and movement disorders can be understood in terms of the imbalance between D2R and RGS.

## System requirements

Matlab plus the toolbox SimBiology. Parallel computing toolbox is recommended. We confirmed safe executions of uploaded programs on Matlab 2020a in Microsoft Windows10.

## Installation

1. Download source code from the github site:

	- git clone https://github.com/urakubo/ModelRP2.git

2. Please run the simulation before drawing figures, i.e., please execute "main_2D_sim.m" before executing "main_2D_plot.m."

3. Execute main_1D_plot.m, etc., and you will see the following figures.


| Program | Figure |
| ------------- | ------------- |
| main_demo1.m | Fig 2A, 2B, 2D, 2E |
| main_demo2.m | Fig 2F |
| main_demo3.m | Figs 3A, 4A, S4A |
| main_demo4.m | S3 Fig |
| main_1D_plot.m | Figs 3B, 4B, S4B-S4D |
| main_2D_plot.m | Figs 2C, 2D, 3C, 3D, S7 |
| main_2D_plot_theory.m | Fig 5 |
| main_2D_plot_conc_DA.m | S5 Fig |
| main_2D_plot_tau_Golf.m | S6 Fig |
| main_tw_plot.m | Figs 1, 7A-7D  |
| main_tw_plot_summary | Fig 7E |
| main_tw_AC5_DA_Golf_plot.m | S9 Fig |

## License

This project is licensed under the MIT license - see the [LICENSE](LICENSE) file for details.

## Reference
The critical balance between dopamine D2 receptor and RGS for the sensitive detection of a transient decay in dopamine signal

Hidetoshi Urakubo, Sho Yagishita, Haruo Kasai, Yoshiyuki Kubota, and Shin Ishii

In preparation.

2021/7/4

Correspondence: hurakubo@gmail.com
