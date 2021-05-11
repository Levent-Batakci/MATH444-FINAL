function [root, Nodes, Leaves] = MaximalTree(attr, I)
root = Node(attr, I);
Nodes = cell(1);
Nodes{1} = root;

%GROW THE TREE !
Lpure = [];
Lmixed = [1];
count=1;

Leaves = cell(1);
i = 1;
while numel(Lmixed) ~= 0
    index = Lmixed(1);
    chosen = Nodes{index}; %Choose mixed node
    
    %Adjust Lmixed
    if(numel(Lmixed) == 1)
        Lmixed = [];
    else
        Lmixed = Lmixed(2:end);
    end
    
    %Optimally split the node
    chosen = SplitNode(chosen);
    
    %Check the children
    L = chosen.left;
    count=count+1;
    if(getErr(L) ~= 0)
        Lmixed(end+1) = count;
    else
        Lpure(end+1) = count;
        Leaves{i} = L;
        i=i+1;
    end
    Nodes{count} = L;
    
    R = chosen.right;
    count=count+1;
    if(getErr(R) ~= 0)
        Lmixed(end+1) = count;
    else
        Lpure(end+1) = count;
        Leaves{i} = R;
        i=i+1;
    end
    Nodes{count} = R;
    
    if(mod(count+1,100) == 0)
        disp(count)
    end
end

root = Nodes{1};
end

