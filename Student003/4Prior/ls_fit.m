function [delta_y, delta_x, h, s] = ls_fit(x)
x_bar = mean(x(:,1));
delta_y = sum((x(:,1)-x_bar).*x(:,2));
delta_x = (x(:,1)-x_bar)'*(x(:,1)-x_bar);
h = sqrt(delta_y*delta_y + delta_x*delta_x);
n = size(x,1);
hn = floor(n/2);
dx = sum(x(end-hn+1:end,1)) - sum(x(1:hn,1));
dy = sum(x(end-hn+1:end,2)) - sum(x(1:hn,2));
if abs(dx) > abs(dy)
    s = sign(dx);
else
    s = sign(dy) * sign(delta_y);
end
