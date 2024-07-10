# EBVCube specifications for the Invasive Alien Species of Union concern

## Specifications
Meeting 02.05.2024

* Extent: Bounding box of the official EEA grid at 10 km for EU27.
* Metric:
  * Cumulative number of all invasive species per pixel.
  * Date of first and last record per pixel per species.
  * Date of most recent record per pixel per species.
* Temporal resolution: Only one time step per metric.
    * The unique time step will contain the cumulative values of the previous records.
    * The time span is from the first available record until June 2024.
* Spatial resolution:
    * Official EEA grid at 10 km for EU27. Create mask for terrestrial and marine species. (i.e., two different cubes)
    * Coordinate reference system EPSG: 3035
    * Exclude pixels with range uncertainty greater than the pixel size.
* Taxonomic match: Use the latest list available from the ETC BE and then search for the corresponding accepted names according to the GBIF backbone taxonomy.
