## Specification for the generation of Birds Directive cubes

## Agreements
Meeting 25.04.2024

* Extent: Bounding box of the official EEA grid at 10 km for EU27.
* Metric: Cumulative value of species occurrence per pixel.
* Temporal resolution:
    * Annual time steps
    * The first time step will contain the cumulative values of the previous records (i.e. several years since the first record).
    * To define the starting time of the dataset ,e.g. 1980, 2000, a data exploration of the first records by decades will be performed.
* Spatial resolution:
    * Official EEA grid at 10 km for EU27.
    * Exclude pixels with range uncertainty greater than the pixel size.
* Taxonomic match: Investigate which criteria to apply. Categorical or percentage. Avoid fuzzy matches.
