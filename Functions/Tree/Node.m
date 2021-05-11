classdef Node < handle
    %LTREE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        left %left child
        right %right child
        
        split_dim %attr dimension to split on
        split_value %Cutoff point
        
        attr %attributes matrix
        I %identification vector
        c %class
        
    end
    
    methods
        
        %Basic constructor
        function obj = Node(attr, I)
            obj.attr = attr;
            obj.I = I;
            obj.c = getClass(obj);
        end
        
        function node = SplitNode(node)
            [dim, val] = OptimalSplit(node);
            
            node.split_dim = dim;
            node.split_value = val;
            
            s = node.attr(dim,:);
            L = s <= val;
            R = s > val;
            
            node.left = Node(node.attr(:,L), node.I(L));
            node.right = Node(node.attr(:,R), node.I(R));
        end
        
        function [bestDim, bestVal] = OptimalSplit(node)
            bestDim = -1;
            bestVal = -1;
            bestErr = -1;
            for dim = 1:size(node.attr,1) %iterate over all attribute dims
                sorted = sort(node.attr(dim,:));
                
                for i = 1:size(sorted,2)-1 %iterate over all the data
                    val = (sorted(i+1)+sorted(i))/2;
                    err = split_err(node, dim, val);
                    if(err < bestErr || bestErr == -1)
                        bestVal = val;
                        bestDim = dim;
                        bestErr = err;
                    end
                end 
                
            end
            
        end
        
        function e = split_err(node, dim, val)
            s = node.attr(dim,:); %Just the attribute on the split dimension
            
            e = 0;
            p = size(node.attr,2);
            
            %Get the left section
            L = s <= val;
            pL = nnz(L);
            %gini
            gL = 1;
            for j = unique(node.I)
                gL = gL - (nnz(L & node.I==j)/pL)^2;
            end
            e = e+ pL/p * gL;
            
            %Get the right section
            R = s > val;
            pR = nnz(R);
            %gini
            gR = 1;
            for j = unique(node.I)
                gR = gR - (nnz(R & node.I==j)/pR)^2;
            end
            e = e+ pR/p * gR;
        end
        
        function e = getErr(node)
            e = 1;
            p = size(node.attr,2);
            for j = unique(node.I)
                e = e - (nnz(node.I==j)/p)^2;
            end
        end
        
        function c = getClass(node)
            c = node.I(1);
            n = nnz (node.I==c);
            for j = unique(node.I)
                n_ = nnz (node.I==j);
                if n_ > n
                    n = n_;
                    c = j;
                end
            end
        end
        
        function c = classify(node, atr)
            d = node.split_dim;
            v = node.split_value;
            if(isLeaf(node))
                c = node.c;
            elseif atr(d) <= v
                c = classify(node.left, atr);
            else
                c = classify(node.right, atr);
            end
        end
        
        function leaf = isLeaf(node)
            leaf = (numel(node.split_dim) == 0);
        end
    end
end

