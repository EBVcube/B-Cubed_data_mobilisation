# EBVCube specifications for the Invasive Alien Species of Union concern

## Specifications
Meeting 02.05.2024

* Extent: Bounding box of the official EEA grid at 10 km for EU27.
* Metric:
  * Total number of observation of species occurrence per pixel for each quarterly.
  * Cumulative number of all invasive species per pixel.
  * Date of first and last record per pixel per species.
  * Date of most recent record per pixel per species.
* Temporal resolution:
    * Quarterly following climate seasonality (DEF, MAM, JLA, SON)
    * The first time step will contain the cumulative values of the previous records (i.e. several years since the first record).
    * To define the starting time of the dataset ,e.g. 1990, 2000, a data exploration of the first records by decades will be performed (histograms).
* Spatial resolution:
    * Official EEA grid at 10 km for EU27. Create mask for terrestrial and marine species. (i.e., two different cubes)
    * Coordinate reference system EPSG: 3035
    * Exclude pixels with range uncertainty greater than the pixel size.
* Taxonomic match: Use latest list available by ETC BE.

