function IO = isint(A)
% Call: function IO = isint(A)
%
% returns logical(1) if A is integer, or 0 if it is not.
% A can have multiple dimensions

if isequal(A,round(A))
    IO=logical(1);
else
    IO=logical(0);
end
