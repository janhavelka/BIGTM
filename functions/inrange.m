function out=inrange( mainVal,compareVal,tol )
% This function takes the mainVal and compares it with compareVal, with
% tolerance +-tol.
% The output is than 0 is mainVal doesnt lie in the range or 1 if it does
% example: inrange(5,4,0.5) gives 1, because 5 lies in range of 2 and 6

compMax=compareVal*(1+tol);
compMin=compareVal*(1-tol);

if compMin<mainVal && compMax>mainVal
    out=true;
else
    out=false;
end


end

