function [ height ] = estimateHeight( depth )
%Estimate the height of the pedestrian box based on the depth of the
%coordinates. The used regression model was derived in analyze_stored.m

if depth > -1500 %close by point -> exponential regression model
   coeffs = [178.1, 0.0009016, 761, 0.006654]; 
   expo = @(x, c) c(1)*exp(c(2)*x) + c(3)*exp(c(4)*x);
   height = expo(depth, coeffs);
   
else %Far away point -> linear regression model
    coeffs = [0.0150900914922355,69.0421883786375];
    height = polyval(coeffs, depth);
end


end

