---
title: "R Markdown Example"
author: "Your Name"
date: "2024-06-24"
output: html_document
---

# Introduction

This is an example of an R Markdown document. You can write text in **Markdown** and embed R code chunks for analysis.

## Loading Data

First, let's load some sample data.

```{r load-data}
# Load necessary library
library(datasets)

# Load the iris dataset
data(iris)

# Show the first few rows of the dataset
head(iris)

# Generate summary statistics for the iris dataset
summary(iris)

# Load necessary library for plotting
library(ggplot2)

# Create a scatter plot of Sepal.Length vs Sepal.Width
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  labs(title = "Sepal Length vs Sepal Width",
       x = "Sepal Length",
       y = "Sepal Width") +
  theme_minimal()




### Explanation

- **YAML Header**: The document starts with a YAML header (between `---` lines) that specifies the document's title, author, date, and output format (e.g., `html_document`).

- **Markdown Text**: You can write text using Markdown syntax. For example, `# Introduction` creates a level-1 heading, and `## Loading Data` creates a level-2 heading.

- **R Code Chunks**: R code chunks are enclosed in triple backticks with `{r}`. You can add options like `echo=FALSE` to control the output. In the example:
  - `{r load-data}` loads the `iris` dataset and displays the first few rows.
  - `{r data-summary}` generates summary statistics for the dataset.
  - `{r plot-data, echo=FALSE}` creates a scatter plot using `ggplot2` and does not show the R code used to generate the plot (due to `echo=FALSE`).

### How to Run the R Markdown Document

1. **Open RStudio**: If you have RStudio installed, open it.
2. **Create New R Markdown File**: Go to `File` -> `New File` -> `R Markdown...`. Fill in the details and click OK.
3. **Copy and Paste the Code**: Copy the above R Markdown content and paste it into the new `.Rmd` file.
4. **Knit the Document**: Click the "Knit" button in RStudio to render the document into the specified output format (e.g., HTML).

The rendered output will show the combined text, code output, and visualizations in a nicely formatted document.
