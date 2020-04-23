# Dyfrat
Matlab package implementing the DYFRAT methodology for fuzzy rating scales.

# Publication
Calcagnì, A., Lombardi, L. Dynamic Fuzzy Rating Tracker (DYFRAT): A novel methodology for modeling real-time dynamic cognitive processes in rating scales. Applied Soft Computing Journal, 24, pp. 948-961.
Publisher website: https://www.sciencedirect.com/science/article/abs/pii/S1568494614004141?via%3Dihub

# Summary
DYFRAT is a new methodology for modeling human rating evaluations from a fuzzy-set perspective (Calcagnì & Lombardi, 2014). In particular, DYFRAT captures the fuzziness of human ratings by modeling some real-time biometric events that occur during the cognitive process of rating in an ecological measurement setting. This methodology records peculiar cognitive information (derived from the motor control of the computer-mouse device) which provide a continuous on-line measure of the cognitive processes involved in the rating task.

In DYFRAT, the process of human rating is described as a temporal and dynamic changing course of data information which is in turn modelled by two physical components: a) the motor activation involved in the process of rating and b) the overall time spent by the rater to provide h(er/is) final rating outcome. The first component is measured by means of tracking computer-mouse movements whereas the second component is measured in terms of response times (recorded in ms).

DYFRAT implements an original method to integrate such physical components into a common and comprehensive fuzzy model which allows to express the overall fuzziness of the rating process.

DYFRAT components:
(1) A Data-Capturing Procedure (DCP) which implements a customized computerized interface for collecting the motor and temporal components in the process of rating (2) a Data-Modeling Procedure (DMP) which provides a fuzzy model for the recorded information (3) a User's Guide. This guide will provide a detailed description about the functioning of the DYFRAT system.

# Note
The DYFRAT package, along with its graphical interface, has been implemented under Matlab 2012a. Some users may therefore experience some problems in running the DYFRAT graphical interface with newest Matlab versions. However, all the scripts implementing the DYFRAT algorithms can still be run manually. The package contains the following main functions:
- <i>main.m</i> starts the graphical interface.
- <i>readValues.m</i> reads the raw mouse-tracking data. The file is called values.txt, it should be formatted as indicated in Calcagnì & Lombardi (2014), and must be located in the same folder where the .m functions are located. As example, see the demo file values.txt which is provided in the current version of the package.
- <i>data_analysis_main.m</i> starts the three steps data analysis:
+ <i>analysis_movements.m</i> for the analysis of the spatial component of the fuzzy sets



