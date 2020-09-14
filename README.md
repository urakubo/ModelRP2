# A healthy balance between dopamine D2 receptors and RGS enables regret-signal detection in the striatum

![System requirements](https://img.shields.io/badge/platform-matlab2020a%20or%20newer-green.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Abstract
In behavioral learning, reward-related events are encoded into phasic dopamine (DA) signals of the brain. In particular, unexpected reward omission, i.e., a regret signal, leads to a phasic decrease in DA (DA-dip) in the striatum, which triggers long-term potentiation (LTP) in DA D2 receptor (D2R) expressing spiny-projection neurons (D2 SPNs). This LTP is required for reward-discrimination, while it is unclear how such a short DA-dip signal (0.5 ~ 2 s) is processed through intracellular signaling to a coincidence detector, adenylate cyclase (AC). In the present study, we built a computational model of the D2 signaling to clarify conditions for the DA-dip detection. To detect the short DA-dip, the decrease in DA must rapidly disinhibit AC, while the basal DA signal must sufficiently inhibit AC. We found that those two requirements are simultaneously satisfied only if two key molecules, D2R and regulators of G protein signaling (RGS) are balanced within a narrow concentration range. Indeed, an experimental study has shown that this balance is realized. We further obtained analytical forms of those requirements, showing that the balanced region appears regardless of the model parameters. The simulation demonstrated that short DA-dips could not be detected if the concentration of D2R was larger than that of RGS, because of the slow disinhibition of AC. If the concentration of D2R was conversely smaller than that of RGS, any DA-dips could not be detected because of the insufficient inhibition of basal AC. These D2R-RGS imbalances appear in the patients of schizophrenia and DYT1 dystonia, respectively; thus, the missing DA-dip detection may be related to such mental or movement disorders. We discuss their relevance in detail.

## System requirements

Matlab plus the toolbox SimBiology. We confirmed safe executions of uploaded programs on Matlab 2020a in Microsoft Windows10.

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
