function [x,nw,np,nt] = osccalc(x,y,nocomp,iter,tol)
%OSCCALC Calculates orthogonal signal correction
%  The inputs are the matrix of predictor variables (x)
%  and predicted variable(s) (y), scaled as desired, and
%  the number of OSC components to calculate (nocomp).
%  Optional input variables are the maximum number of
%  iterations used in attempting to maximize the variance
%  captured by orthogonal component (iter, default = 0),
%  and the tolerance on percent of x variance to consider
%  in formation of the final w vector (tol, default = 99.9).
%  The outputs are the OSC corrected x matrix (nx) and
%  the weights (nw), loads (np) and scores(nt) that were
%  used in making the correction. Once the calibration is 
%  done, new (scaled) x data can be corrected by 
%  newx = x - x*nw*inv(np'*nw)*np';
%
%I/O: [nx,nw,np,nt] = osccalc(x,y,nocomp,iter,tol);
%
%See also: CROSSVAL

%Copyright Eigenvector Research, Inc. 1998
%Barry M. Wise, January 23, 1998

[m,n] = size(x);
nw = zeros(n,nocomp);
np = zeros(n,nocomp);
nt = zeros(m,nocomp);
if nargin < 4 | isempty(iter)
  iter = 0;
end
if nargin < 5 | isempty(tol)
  tol = 99.9;
end
for i = 1:nocomp
  % Calculate the first score vector
  [u,s,v] = svds(x,1);
  p = v(:,1);
  p = p*sign(sum(p));
  told = u(:,1)*s(1);
  dif = 1;
  k = 0;
  while dif > 1e-12
    k = k+1;
    % Calculate scores from loads
    t = x*p/(p'*p);
    % Othogonalize t to y
	tnew = t - y*inv(y'*y)*y'*t;
    % Compute a new loading
    pnew = x'*tnew/(tnew'*tnew);
    % Check for convergence
    dif = norm(tnew-told)/norm(tnew);
    % Assign pnew to p
    told = tnew;
    p = pnew; 
    if k > iter
      dif = 0;
	end
  end
  % Build PLS model relating x to t
  nc = rank(x);
  [w,ssq] = pls(x,tnew,nc,0);
  % Include components as specified by tol on x variance
  z = size(find(ssq(:,3)<tol));
  nc = z(1)+1;
  w = w(nc,:)';  
  w = w/norm(w);
  % Calculate new scores vector
  t = x*w;
  % Othogonalize t to y
  t = t - y*inv(y'*y)*y'*t;
  % Compute new p
  p = x'*t/(t'*t);
  % Remove orthogonal signal from x
  x = x - t*p';
  np(:,i) = p;
  nw(:,i) = w;
  nt(:,i) = t;
end

