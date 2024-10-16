# Decision Trees, Bagging, and Random Forests

this project demonstrates the application of decision trees, bagging, and random forests for both regression and classification tasks. The datasets used are:

Prostate dataset (regression) to predict lpsa (logarithm of prostate-specific antigen).
SAheart dataset (classification) to predict the presence of coronary heart disease (chd).
Key Components
Decision Trees:

Regression Trees: Fit to the prostate data to predict the lpsa response using various features. The tree is then pruned based on cross-validation to improve its performance and reduce overfitting.
Classification Trees: Applied to the SAheart data to predict coronary heart disease (CHD). After building the tree, cross-validation is used to determine the optimal tree size, followed by pruning to avoid overfitting.
Bagging (Bootstrap Aggregating):

Used for both regression (prostate dataset) and classification (SAheart dataset).
Bagging trains multiple trees on bootstrapped samples and averages their predictions (for regression) or takes a majority vote (for classification). This reduces variance and improves accuracy.
Random Forests:

Similar to bagging, but random forests introduce an additional layer of randomness by selecting a random subset of predictors at each split.
Applied to both regression and classification, random forests provide insights into variable importance and improve predictive accuracy over simple decision trees.
Summary of Results
Regression Trees: Provide interpretable models but can overfit. Pruning helps balance complexity and performance.
Classification Trees: Useful for predicting categorical outcomes, but similarly prone to overfitting. Pruning via cross-validation helps control model complexity.
Bagging and Random Forests: Ensemble methods like bagging and random forests are more robust than individual trees. Random forests, in particular, offer better accuracy by reducing the model’s variance and highlighting important features.
