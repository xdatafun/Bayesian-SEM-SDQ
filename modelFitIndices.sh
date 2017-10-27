grep "Posterior Predictive P-Value" wave*_5f-step2.out > ppp.txt
grep "Deviance" wave*_5f-step2.out > DIC.txt
grep "Estimated Number of Parameters" wave*_5f-step2.out > pD.txt
grep "Bayesian (BIC)" wave*_5f-step2.out > BIC.txt