classdef Logger < Singleton
    %LOGGER Summary of this class goes here
    %   Singleton needs to be on path. addpath('~/Ph.D/Matlab/general-scripts/Singleton/')
    %   You can set a default store path by setting 'defaultLoggerPath' in
    %   ParameterStore before you use aquire an instance of Logger. Eg.:
    %   ps=ParameterStore.instance();
    %   ps.set('defaultLoggerPath','debug')
    %   logger = Logger.instance();
    %   logger.addEntry('use the logger functionality')
    %
    %   Copyright: Thomas Mosgaard Giselsson
    properties(Access=private)
        logfile;
        logEntries;
        logfilename;
        
    end
        
    methods(Access=private)
        function obj = Logger()
            psInstance = ParameterStore.instance();
            path='';
            if psInstance.hasKey('defaultLoggerPath')
                path=psInstance.get('defaultLoggerPath');
            end
            logPath = GetFullPath(path);
            if ~isdir(logPath)
                if ~mkdir(logPath)
                    error('Logger:setLoggerPath','could not create log file: %s',logPath);
                end
            end
            
            obj.logfilename = fullfile(logPath,[ datestr(now(),'YYYY-mm-DD HH_MM_ss') '.log']);
            obj.logfile = fopen(obj.logfilename,'w');
            if isempty(obj.logfile)
                error('Logger:createFile','could not create log file: %s',obj.logfilename);
            end
            obj.logEntries=[];            
        end
        
        function delete(obj)
            if ~isempty(obj.logfile)
                fclose(obj.logfile);
            end
        end
    end
    
    methods(Access=public)
        function addEntry(obj,entryString)
            fullEntryString=[datestr(now(),'HH-MM-ss: ') entryString];
            obj.logEntries{end+1}=fullEntryString;
            fprintf(obj.logfile,[fullEntryString '\n']);
            %TODO should logfile be flushed? NO: http://www.mathworks.se/support/solutions/en/data/1-PV371/?solution=1-PV371
        end
        
        function entries = entriesSince(obj, entrynumber)
            entries=[];
            % check input variables
            if nargin<2
                entrynumber=1;
            end
            numEntries = size(obj.logEntries,1);
            if numEntries<entrynumber
                return
            end
            entries = obj.logEntries{entrynumber:end};
        end
    end
    
    methods(Static)
      % Concrete implementation.  See Singleton superclass.
      function obj = instance()
         persistent uniqueInstance
         if isempty(uniqueInstance)
            obj = Logger();
            uniqueInstance = obj;
         else
            obj = uniqueInstance;
         end
      end
   end
    
end

