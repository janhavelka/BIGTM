function [main_handle,rate,c] = UpdatePlot( main_handle, update_field )

rate=0;
c=0;
line_width=2;

% check if handle was deleted
if all(isvalid( main_handle ))
    if all(strcmp({main_handle.Type},'scatter'))
        if isempty(main_handle.ZData)
            main_handle.YData=update_field(:);
        else
            main_handle.ZData=update_field(:);
        end
    elseif all(strcmp({main_handle.Type},'line'))
        if length(main_handle)==1
            if update_field.Flag==0
                step=update_field.step;
                X=1./update_field.Y(:,step,:);
                x_point=[X(round(size(X,1)/4),1,1),X(round(size(X,1)*3/4),1,1)];
                y_point=[mean(update_field.temp_err(round(size(X,1)/4),step,:),3),mean(update_field.temp_err(round(size(X,1)*3/4),step,:),3)];
                rate=log10(x_point(2)/x_point(1))/log10(y_point(2)/y_point(1));
                c=y_point(2)-rate*x_point(2);
                
                main_handle.YData=y_point;
            else
                
                step=update_field.step;
                X=1./update_field.Y(:,step,:);
                x_point=[X(round(size(X,1)/4),1,1),X(round(size(X,1)*3/4),1,1)];
                y_point=[mean(update_field.moist_err(round(size(X,1)/4),step,:),3),mean(update_field.moist_err(round(size(X,1)*3/4),step,:),3)];
                tend_rate=log10(x_point./y_point);
                val=tend_rate(2)/tend_rate(1);
                
                main_handle.YData=y_point;
            end
        else
            for i=1:length(main_handle)
                main_handle(i).ZData=update_field(i,:);
            end
        end
    elseif all(strcmp({main_handle.Type},'patch')) && ~any(size(update_field)==2)
        % Update trisurf plot
        main_handle.Vertices(:,3)=update_field;
        main_handle.FaceVertexCData=update_field;
        
        if isappdata(main_handle,'contour')
            figure(getappdata(main_handle,'main_figure'));
            delete(getappdata(main_handle,'contour'));
            %             surf_contour=tricontour(getappdata(main_handle,'Elements'),getappdata(main_handle,'Nodes'),update_field,20,getappdata(main_handle,'ZMin')+0.01*abs(getappdata(main_handle,'ZMin')),2);
            surf_contour=tricontour(getappdata(main_handle,'Elements'),getappdata(main_handle,'Nodes'),update_field,20,getappdata(main_handle,'ZMin')+0.001*abs(getappdata(main_handle,'ZMin')),line_width);
            setappdata(main_handle,'contour',surf_contour);
        end
        
    elseif all(strcmp({main_handle.Type},'quiver')) && any(size(update_field)==2)
        % Update quiver plot
        set(main_handle,'udata',update_field(:,1),'vdata',update_field(:,2))
        if isappdata(main_handle,'contour')
            figure(getappdata(main_handle,'main_figure'));
            delete(getappdata(main_handle,'contour'));
            grad_contour=tricontour(getappdata(main_handle,'Elements'),getappdata(main_handle,'Nodes'),getappdata(main_handle,'ETN')*sqrt(update_field(:,1).^2+update_field(:,2).^2),20,0,1);
            %             grad_contour=tricontour(getappdata(main_handle,'Elements'),getappdata(main_handle,'Nodes'),getappdata(main_handle,'ETN')*sqrt(update_field(:,1).^2+update_field(:,2).^2),20,0,line_width);
            setappdata(main_handle,'contour',grad_contour);
        end
    else
        error('Wrong input format')
    end
end
