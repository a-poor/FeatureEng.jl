# Manual

```@contents
```

## Categorical Features

Functions for encoding a column of categorical data as multiple,
binary columns.

```@autodocs
Modules = [FeatureEng]
Pages = ["categorical.jl"]
```

## DateTime Features

Functions for extracting helpful information from a column `DateTime` data.

```@autodocs
Modules = [FeatureEng]
Pages = ["datetime.jl"]
```

## Numeric Features

Working with numeric features.

### Numeric – Binning Features

Converting continuous data to categorical data.

```@autodocs
Modules = [FeatureEng]
Pages = ["binning.jl"]
```

### Numeric – Scaling Features

Scaling or normalizing numeric columns.

A helpful pre-processing step for ML models that are sensitive to data scale (ex _k-means clustering_, _regularized regression_).

```@autodocs
Modules = [FeatureEng]
Pages = ["scaling.jl"]
```

### Numeric – Transforming Features

[Power transformations](https://en.wikipedia.org/wiki/Power_transform) for numeric data.

Helpful for data with a distribution that doesn't work well with the model you're using (ex log-transforming data drawn from an exponential distribution before linear regression).

```@autodocs
Modules = [FeatureEng]
Pages = ["transforming.jl"]
```

### Numeric – Interaction Features

Calculate polynomial features to a specified degree before performing something like [polynomial regression](https://en.wikipedia.org/wiki/Polynomial_regression).

```@autodocs
Modules = [FeatureEng]
Pages = ["interactions.jl"]
```
