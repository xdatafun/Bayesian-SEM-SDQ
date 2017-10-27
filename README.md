# Bayesian-SEM-SDQ

## Summary
This is a project where we use Bayesian structural equation model (BSEM) on 10 waves of the Strength and Difficulty Questionnaire (SDQ) data to study the measurement model.

## Background
The Strength and Difficulty Questionnaire (SDQ) was published by Dr.Goodman in 1997. It is a short screening questionnaire for 3-16 years old. It has 25 questions to measure 5 attributes (5 questions per attribute) -- Conduct Problems, Hyperactivity, Emotional Symptoms, Peer Problems, and Prosocial Behavior. Studies on the SDQ's measurement model have reported a few dozens of modified versions, usually with different cross-loadings and residual correlations. 

Office website of the SDQ: http://www.sdqinfo.com/

## Data
Thanks to Dr.Hughes (Texas A&M University), we -- Dr.Chen, Jayme Palka, and I (University of North Texas) -- have access to the 10 waves of the SDQ data. The data was collected annually as part of Dr.Hughes 10-year-long project "The impact of grade retention: Developmental approach". We analyzed the teacher version of the SDQ, teachers were asked to evaluate each student's behavior for the last 6 months. We needed to pass special trainings to be permitted the access to human subject data. Therefore, I cannot release the data here. 

## The Problem
We wanted to validate the measurement model with our data. I did the analysis, Jayme did the literature review, Dr.Chen initiated the project and did corrdination with Dr.Hughes as well as supervised us. The original 5-item-5-attribute measurement model did not fit when I used traditional factor analysis. In order to estimated the confirmatory factor analysis model, maximum likelihood requires the model to be identified, which means there is a upper limit of the number of parameters that can be estimated, and the rest has to be fixed as 0. The SDQ is known to have cross-loadings (questions load on attributes that they are not designed to load on) as well as residual correlations, studies usually modify the original model to achieve adequate model fit. Yet it is also known that modifications suggested by software have their own problems -- one can only make one modification at a time, and then re-evaluate the model, the software makes suggestions again, he/she add another modification and re-evaluate the model. It soon becomes cumbersome, also the step-wise procedure tends to capitalize on sample idiosyncrasy and lead to overfit.  

## Bayesian Structural Equation Modeling (BSEM)
After every usual approach failed (using R, SPSS, LISREL), BSEM caught my eyes. Muthen and Asparouhov designed a particular statistical procedure to diagnose model misfit in 2012. It is referred as BSEM because there are other ways to apply Bayesian methods on structural equation models. Their BSEM is able to estimate cross-loadings and residual covariances directly because Bayesian methods identify models in a different way. Instead of having the upper limit of number of free parameters, Bayesian models are identified by highly informed priors. Therefore, the loadings and correlations that were fixed to be 0 in traditional approaches were set to have highly informed priors, so that cross-loadings and residual covariances were specified to be approximate 0s instead of exact 0s. The idea is that in really, parameters that are supposed to be 0 are rarely actually 0. If cross-loadings result in approximate 0s that are not statistical significant, it just represents random noise and need no farther interpretation. If approximate 0 parameters turn out to be statistically significant -- 95 credible intervals don't contain 0 -- a deeper look is granted. 

There are three steps of the model estimation:
  - Step 1, estimate models with no cross-loadings and residual covariances, as the baseline models;
  - Step 2, estimate models with approximate 0 cross-loadings and no residual covariances;
  - Step 3, estimate models with approximate 0 cross-loadings and approximate 0 residual covariances.

Step 1 models are supposed to fit the worst; Step 2 models should have improved model fit, yet Step 3 should have the best model fit. There are debates on how to use BSEM carefully and correctly, not as an escape capsule for model misspecifications. I ran numerous models and careful compared and contrasted the results. We cared about practical interpretations and theoretical ground. We didn't make any decision solely because of statistical significance. Blindly trusting model fit indices is bad practice in any field.  

More information please see https://www.statmodel.com/BSEM.shtml

## Result Summary, Mplus Automation, and Shell Scripting
With 10 waves of data, each wave with three steps of model, for each set of prior hyperparameters, there are 30 analyses. After convergence was achieved, I needed to double the number of samples and ran the analyses again to guarantee the convergence. For sensitivity analysis, I ran numerous sets of prior hyperparameters. For each round of analyses, I need to summarize the results, including how often a cross-loading turned out to be statistical significant. The SDQ is a screening tool, not designed to measure longitudinal growth. We used 10 waves of data from the same group of participants in order to control for the within subject variances. So usually studies analyze one sample and deem significant cross-loadings to be substantial, we counted how often a cross-loading turned out as significant among 10 waves. 

If I did this manually after each round of analysis, we probably stuck at testing different priors, and far away from comparing cross-loading patterns between different rounds. Shell scripting made it much easier. I could grab significant loadings fairly easily, as well as model fit indices. Copy and paste the results into MS Excel, it still took some cleaning and formating, but it's already way better.  

Also, each time I ran analysis on BSEM creators' software Mplus, if I used Mplus directly, I need to click "run" on every Mplus script. But thanks to R package MplusAutomation, I prepared all the scripts in one folder, and used the package to call Mplus from R. It usually ran overnight, and next morning all the results were ready for shell scripting. 

```R
library(MplusAutomation)
runModels("/Users/xxin/BSEM-SDQ-Project", 
          recursive=TRUE, replaceOutfile=TRUE,showOutput=TRUE)
```

Finally, we compared multiple rounds of analyses, saw the changing pattern of cross-loadings and residual covariances, compared it with previous studies, and came up with our modification of measurement model. BSEM let us diagnose the SDQ thoroughly, free from traditional step-wise modification, but saw the bigger picture. We took one more step to see how our measurement model may change the outcome of the SDQ. The SDQ can be hand calculated, and based on the sum scores of each attribute, participants are categorized as one of the three groups -- "normal", "borderline", and "abnormal". I wanted to see taking into account the cross-loadings in the scoring, how many participants would have been categorized differently. The SDQ official site provided some codes for scoring. I re-coded our data, used their scoring strategy and our alternative one. 15%-20% participants would have been categorized different with the scoring rubric based on our measurement model. 

## Tables and Codes
BSEM_SDQ_Tables.pdf
  - Table 1 is the SDQ questions, retrieved from www.infosdq.com
  - Table 2 shows how questions are related to attributes
  - Table 3 shows model fit indices
  - Table 4 shows frequency of siginicant loadings (cross-loadings) of 10 waves in Step 2 models
  - Table 5 shows frequency and range of significant loadings in Step 3 models, a lot of significant cross-loadings have disappeared once residual covariances are added to the model, which indicates forcing residual covariances to be 0 may inflate loadings, Muthen and Asparouhov have more in-depth discussion
  - Table 6 shows the pattern of siginificant residual covariances, it's mostly within attributes, probably due to shared content
  - Figure 1 shows the changes of the number of participants being categorized as "abnormal" in original and our scoring rubric
  
Codes
  - factorLoading_factorCorrelations.sh # grab all the significant loadings and cross-loadings, and factor correlations
  - modelFitIndices.sh # grab BIC, DIC, pD, PPP
  - pD.txt # an example of outcome from shell scripting, copy and paste it to Excel is very handy
  - residualCovariances.sh # this extremely cumbersome to do manually, to summarize the frequency of significant residual covariances of 10 waves of data in the lower 25X25 correlation matrix
  - sampleOutputStep1Models.txt # first part of the output is input script, the sigificant parameters have "*" at the end
  - sampleOutputStep2Models.txt 
  - sampleOutputStep3Models.txt # latter steps have more complex models, thus more number of parameters to summary
  
This is a over-simplified version of our study, I put the codes here to borrow both the good habit of sharing in the industry and the strength of GitHub that encourages more transparency. Usually in my field authors either do not share codes or put the codes on journal's page or email the codes to the people contact them. To be fair, a lot of times researchers cannot share the data because of human subject concerns, which make it harder to read their codes anyway. 

It is my pleasure to share our project here. 
