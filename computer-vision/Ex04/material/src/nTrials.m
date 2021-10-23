function [n] = nTrials(inlierRatio,nSamples,desiredConfidence)
    n = log(1-desiredConfidence) / log(1-(inlierRatio)^nSamples);
end