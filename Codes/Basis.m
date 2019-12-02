 X = linspace(-2,2,100)';
L = [ones(size(X)), (1 - X), (1 - 2*X - 0.5*X.^2), 1/6*(6 - 18*X + 9*X.^2 - X.^3), 1/24*(X.^4-16*X.^3+72*X.^2-96*X+24), 1/120*(-X.^5+25*X.^4-200*X.^3+600*X.^2-600*X+120)];
 L2 = [ones(size(X)) 2*X 4*X.^2-2 8*X.^3-12*X 16*X.^4-48*X.^2+12 32*X.^5-160*X.^3+120*X];
 L3= [ones(size(X)) X X.^2 X.^3 X.^4 X.^5];

 subplot(2,2,1)
 hold on
 plot(X,L(:,2));
 plot(X,L(:,3));
 plot(X,L(:,4));
 plot(X,L(:,5));
 plot(X,L(:,6));
 hold off
 subplot(2,2,2)
 hold on
  plot(X,L2(:,2));
 plot(X,L2(:,3));
 plot(X,L2(:,4));
 plot(X,L2(:,5));
 plot(X,L2(:,6));
 hold off
 subplot(2,2,3)
 hold on
 plot(X,L3(:,2));
 plot(X,L3(:,3));
 plot(X,L3(:,4));
 plot(X,L3(:,5));
 plot(X,L3(:,6));
 hold off
 