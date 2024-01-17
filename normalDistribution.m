function [pd, mu, sigma] = normalDistribution(intensities)
    % Second itinerary of fitting a normal distribution to the pixel intensities
    pd = fitdist(intensities, 'Normal');

    % Estimate mean and variance using percentiles
    lowerPercentile = 25;
    upperPercentile = 75;
    lowerThreshold = pd.icdf(lowerPercentile / 100);
    upperThreshold = pd.icdf(upperPercentile / 100);
    
    % Calculate IQR (Interquartile Range)
    IQR = upperThreshold - lowerThreshold;
    
    % Estimate standard deviation for a normal distribution
    sigma = IQR / 1.349;
    
    % Calculate mean using the median (assuming symmetry in a normal distribution)
    mu = (upperThreshold + lowerThreshold) / 2;
end