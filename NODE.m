classdef NODE < handle
% A node in the tree

    properties
        value;
        left  = [];
        right = [];
    end
    methods
        function obj = NODE(varargin)
            obj.value = varargin{1};
            if nargin > 1
                obj.left  = varargin{2};
                if nargin > 2
                    obj.right = varargin{3};
                end
            end
        end
        function out = type(obj)
            % Type of node: 0. operand 1. unary operator 2. binary operator
            if isempty(obj.left)
                out = 0;
            elseif isempty(obj.right)
                out = 1;
            else
                out = 2;
            end
        end
        function out = iscons(obj)
            % Whether the node is a constant
            out = obj.value <= 1;
        end
        function out = isscalar(obj)
            % Whether the node is a scalar
            out = ismember(obj.value,[1,3,7]) || obj.value <= 1;
        end
        function out = isbinary(obj)
            % Whether the node is a binary operator
            out = ismember(obj.value,[11,12,13,14]);
        end
        function out = isvector(obj)
            % Whether the node is a vector-oriented operator
            out = ismember(obj.value,[32,33,34,35,36]);
        end
    end
end