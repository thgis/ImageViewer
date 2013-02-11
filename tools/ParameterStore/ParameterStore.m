classdef ParameterStore < Singleton
    %PARAMETERSTORE Class that enables parameter storing and retrieving from any scope
    %   Singleton needs to be on path. addpath('~/Ph.D/Matlab/general-scripts/Singleton/')
    %   Copyright: Thomas Mosgaard Giselsson
    properties(Access=private)
        map;
    end
    
    
    methods(Access=public)
        function value=get(obj,key)
            value='';
            if obj.map.isKey(key)
                value=obj.map(key);
            end                
        end
        
        function bool = hasKey(obj,key)
            bool=isKey(obj.map,key);
        end
        function set(obj,key,value)
            obj.map(key)=value;
        end
        
        function delete(obj,key)
            if isKey(obj.map,key)
                remove(obj.map,key);
            end
        end
        
    end
    
    methods(Access=private)
        function obj = ParameterStore()
            obj.map = containers.Map();
        end
    end        
    
    methods(Static)
      % Concrete implementation.  See Singleton superclass.
      function obj = instance()
         persistent uniqueInstance
         if isempty(uniqueInstance)
            obj = ParameterStore();
            uniqueInstance = obj;
         else
            obj = uniqueInstance;
         end
      end
   end
    
end

