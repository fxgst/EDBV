classdef GUI
    %GUI Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        function init 
            f = figure();
            layout = uix.HBox('parent',f);
            %set(layout,'Widths', [100], 'Spacing', 5);
            buttonBox = uix.VBox('parent', layout);
            uicontrol( 'String', 'Button 1', 'parent', buttonBox );
            uicontrol( 'String', 'Button 2', 'parent', buttonBox );
        end
    end
end

