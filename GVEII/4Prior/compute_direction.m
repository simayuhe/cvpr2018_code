function direction = compute_direction(x,t)
% T = size(x,1);
% v = zeros(T,2);
% v(1,:) = x(2,:)-x(1,:);
% v(end-1,:) = (x(end,:)-x(end-2,:))/2;
% v(end,:) = x(end,:) - x(end-1,:);
% v_tmp = zeros(T,2);
% for t = 2:T-1
% 	v_tmp(t,:) = x(t+1,:) - x(t-1,:);
% end
% for t = 2:T-2
% 	v(t,:) = (v_tmp(t+1,:)+v_tmp(t,:))/4;
% end
%输入是轨迹，每一行代表轨迹点，总共有两列代表xy坐标
H = 5;
L = 2*H+1;
len = size(x,1);
if len <= L
    seg = x;
elseif t-H < 1
    seg = x(1:L,:);
elseif t+H > len
    seg = x(end-L+1:end,:);
else
    seg = x(t-H:t+H,:);
end
[delta_y, delta_x, ~, s] = ls_fit(seg);
direction = atan2(s*delta_y,s*delta_x);