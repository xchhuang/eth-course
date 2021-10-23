function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)

[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

pos_prob = log(normpdf(histogram, muPos, sigmaPos)); % avoid overflow of multiplication
pos_prob(isnan(pos_prob)) = [];
p_hist_given_car = exp(sum(pos_prob));   % log then exp to calculate the multiplications
p_car = 0.5;    % prior prob.
p_car_given_hist = p_hist_given_car * p_car; % bayesian rule

neg_prob = log(normpdf(histogram, muNeg, sigmaNeg));
neg_prob(isnan(neg_prob)) = [];
p_hist_given_notcar = exp(sum(neg_prob));
p_notcar = 0.5;
p_notcar_given_hist = p_hist_given_notcar * p_notcar;

if p_car_given_hist > p_notcar_given_hist % compare prob. to see which one is more likely to be
    label = 1;
else
    label = 0;
end

end




