## Specification for the generation of Birds Directive cubes

## Agreements
Meeting 25.04.2024

* Extent: Bounding box of the official EEA grid at 10 km for EU27.
* Metric: Cumulative value of species occurrence per pixel.
* Temporal resolution:
    * Temporal resolution: Only one time step per metric.
    * The unique time step will contain the cumulative values of the previous records or
    * The metric calculated across all years.
* Spatial resolution:
    * Official EEA grid at 10 km for EU27.
    * Exclude pixels with range uncertainty greater than the pixel size.
* Taxonomic match: Investigate which criteria to apply. Categorical or percentage. Avoid fuzzy matches.
