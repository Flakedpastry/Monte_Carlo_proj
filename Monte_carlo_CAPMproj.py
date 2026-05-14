import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm

np.random.seed(102)


reps = 10000
beta_true = [-1.5,-0.5,0.5,1.5]
Time_vals = [20,100,500]
betas = np.zeros(reps)
cover = np.zeros(reps)


results = []


for b in beta_true:
    for t in Time_vals:
        for r in range(reps):
            # normal distribution of rm_ex
            rm_ex = np.random.normal(0.05, 0.12, t)
            # normal ditribution of error term
            err = np.random.normal(0, 0.10, t)

            capm_ex_ret = b * rm_ex + err

            X = sm.add_constant(rm_ex)

            ols_regression = sm.OLS(capm_ex_ret, X).fit()

            beta_cap = ols_regression.params[1]
            # store beta cap in beta via appending to beta array
            betas[r] = beta_cap
            # calculate se of beta cap
            std_err = ols_regression.bse[1]

            # calculate t-staistic of beta cap, and see if it is less than 1.96
            cover[r] = int(abs((beta_cap - b) / std_err) <= 1.96)

        mean_beta = np.mean(betas)
        var_beta = np.var(betas)
        bias = mean_beta - b
        mean_coverage = np.mean(cover)

        results.append({
            "True Beta": b,
            "Time Sample":t,
            "Mean Beta": mean_beta,
            "Variance Beta": var_beta,
            "Bias": bias,
            "Mean Coverage": mean_coverage,
        })

        plt.hist(betas, 50)
        plt.axvline(b, color='k', linewidth=2)
        plt.title(f"Beta_hat distribution, true beta = {b:}, time sample {t}")
        plt.show()
        plt.savefig(f"Beta_hat_{b},time_{t}.png")



results = pd.DataFrame(results)
print(results)








