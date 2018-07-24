
function ad=adapt(gam,sig2,train_x,train_y)

    ad=rclssvm(gam,sig2,train_x,train_y);
    
end