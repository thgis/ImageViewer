classdef ImageSaver < Singleton
    %IMAGESAVER Summary of this class goes here
    %   Singleton needs to be on path. addpath('~/Ph.D/Matlab/general-scripts/Singleton/')
    %   You can set a default store path by setting 'defaultImageSaverPath' in
    %   ParameterStore. Eg.:
    %   ps=ParameterStore.instance();
    %   ps.set('defaultImageSaverPath','images')
    %
    %   Copyright: Thomas Mosgaard Giselsson
    
    properties(Access=private)
        imagePath;
        doLogging;
    end
    
    methods(Access=public)
        function bool=saveImage(obj,img,imgTitle)
            % construct filename
            fileName= [datestr(now(),'yy-mm-dd_HH:MM:ss_') imgTitle '.png'];
            fileNameAndPath = fullfile(obj.imagePath,fileName);
            if obj.doLogging
                l=Logger.instance();
                l.addEntry(sprintf('Saving image named: %s in: %s.....',imgTitle,fileNameAndPath));
            end
            imwrite(img,fileNameAndPath);
            if obj.doLogging
                if exist(fileNameAndPath,'file')
                    l.addEntry(sprintf('Image titles: %s has been saved to: %s',imgTitle,fileNameAndPath));
                    bool =1;
                else
                    l.addEntry(sprintf('Image titles: %s COULD NOT BE saved to: %s',imgTitle,fileNameAndPath));
                    bool=0;
                end
            end
            
            
        end
        
        function setLogStatus(obj,logStatus)
            obj.doLogging=logStatus;
        end
        
    end
    
    methods(Access=private)
        function obj = ImageSaver()
            psInstance = ParameterStore.instance();
            path='';
            if psInstance.hasKey('defaultImageSaverPath')
                path=psInstance.get('defaultImageSaverPath');
            end
            
            obj.imagePath = GetFullPath(path);
            obj.doLogging=1;
            if ~isdir(obj.imagePath)
                if ~mkdir(obj.imagePath)
                    error('ImageSaver:setImagePath','could not create log file: %s',obj.logfilename);
                end
            end       
        end
    end
    
    methods(Static)
      % Concrete implementation.  See Singleton superclass.
      function obj = instance()
         persistent uniqueInstance
         if isempty(uniqueInstance)
            obj = ImageSaver();
            uniqueInstance = obj;
         else
            obj = uniqueInstance;
         end
      end
   end
end

